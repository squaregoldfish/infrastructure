package se.lu.nateko.cp.sbttsgen
import scala.meta._
import java.io.Writer
import scala.collection.mutable

class NaiveTransformer(writer: Writer){

	import NaiveTransformer._

	def declareMappings(customTypeMappings: Iterable[(String, String)]): Unit = {
		for((from, to) <- customTypeMappings){
			writer.append(s"type $from = $to\n")
		}
		writer.append("\n")
	}

	def fromSource(srcTxt: String): Unit = {
		val src = srcTxt.parse[Source].get

		src.traverse{
			case Defn.Class(mods, Type.Name(name), _, Ctor.Primary(_, _, params :: Nil), _) if hasCase(mods) =>
				fromCaseClass(name, params)
		}

		src.traverse{
			case Defn.Trait(mods, Type.Name(name), _, _, _) if hasSealed(mods)=>
				fromSealedTrait(name, src)
		}

	}

	private def fromSealedTrait(name: String, src: Source): Unit = {
		writer.append(s"export type $name = ")

		def extendsTrait(inits: List[Init]): Boolean = inits.collectFirst{
			case Init(Type.Name(`name`), _, _) => true
		}.isDefined

		val typeUnionMembers = mutable.Buffer.empty[String]

		src.traverse{
			case Defn.Class(mods, Type.Name(name), _, _, Template(_, inits, _, _)) if hasCase(mods) && extendsTrait(inits) =>
				typeUnionMembers += name
		}
		val typeUnion = if(typeUnionMembers.isEmpty) "void" else typeUnionMembers.mkString(" | ")
		writer.append(s"$typeUnion\n\n")
	}

	private def fromCaseClass(name: String, members: List[Term.Param]): Unit = {
		writer.append(s"export interface $name{\n")
		members.foreach{memb =>
			memb.decltpe.foreach{tpe =>
				writer.append('\t')
				fromCaseClassMember(memb.name.value, tpe)
				writer.append('\n')
			}
		}
		writer.append("}\n\n")
	}

	private def fromCaseClassMember(name: String, declType: Type): Unit = {
		def appendFor(forType: Type): Unit = typeRepresentation(forType).foreach{typeRepr =>
			writer.append(s"$name: $typeRepr")
		}

		declType match{
			case Type.Apply(Type.Name("Option"), typeArgs) =>
				fromCaseClassMember(name.stripSuffix("?") + "?", typeArgs.head)

			case _: Type.Name | _: Type.Apply =>
				appendFor(declType)

			case _ =>
		}
	}
}


object NaiveTransformer{

	def typeNameConversion(scala: String): String = scala match{
		case "Int" | "Float" | "Double" | "Long" | "Byte" => "number"
		case "String" => "string"
		case _ => scala
	}

	def typeRepresentation(t: Type): Option[String] = t match{
		case Type.Name(name) =>
			Some(typeNameConversion(name))

		case Type.Apply(Type.Name(collName), typeArg :: Nil) if collsToArray.contains(collName) =>
			typeRepresentation(typeArg).map(inner => s"Array<$inner>")

		case Type.Apply(Type.Name("OptionalOneOrSeq"), typeArg :: Nil) =>
			typeRepresentation(typeArg).map(inner => s"$inner | Array<$inner> | undefined")

		case Type.Apply(Type.Name("Either"), List(type1, type2)) =>
			for(t1 <- typeRepresentation(type1); t2 <- typeRepresentation(type2))
			yield s"$t1 | $t2"

		case _ => None
	}

	private val collsToArray = Set("Seq", "Array", "IndexedSeq", "Vector")

	def hasCase(mods: List[Mod]): Boolean = mods.collectFirst{
		case m @ Mod.Case() => m
	}.isDefined

	def hasSealed(mods: List[Mod]): Boolean = mods.collectFirst{
		case m @ Mod.Sealed() => m
	}.isDefined

}
