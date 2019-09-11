package se.lu.nateko.cp.sbttsgen
import org.scalatest.FunSuite
import java.io.StringWriter
import java.io.FileWriter

class NaiveTransformerTests extends FunSuite{

	private val example = """|
	|	case class UriResource(uri: URI, label: Option[String])

	|	sealed trait Agent{
	|		val self: UriResource
	|	}
	|	case class Organization(self: UriResource, name: String) extends Agent
	|	case class Person(self: UriResource, firstName: String, lastName: String) extends Agent


	|	case class Station(
	|		org: Organization,
	|		id: String,
	|		name: String,
	|		coverage: Option[GeoFeature]
	|	)

	|	case class DataTheme(self: UriResource, icon: URI, markerIcon: Option[URI])

	|	case class DataObjectSpec(
	|		self: UriResource,
	|		project: UriResource,
	|		theme: DataTheme,
	|		format: UriResource,
	|		encoding: UriResource,
	|		dataLevel: Int,
	|		datasetSpec: Option[JsValue]
	|	)

	|	case class DataAcquisition(
	|		station: Station,
	|		interval: Option[TimeInterval],
	|		instrument: OptionalOneOrSeq[URI],
	|		samplingHeight: Option[Float]
	|	){
	|		def instruments: Seq[URI] = instrument.fold(Seq.empty[URI])(_.fold(Seq(_), identity))
	|	}

	|	case class DataProduction(
	|		creator: Agent,
	|		contributors: Seq[Agent],
	|		host: Option[Organization],
	|		comment: Option[String],
	|		sources: Seq[UriResource],
	|		dateTime: Instant
	|	)
	|
	|case class DataObject(
	|	hash: Sha256Sum,
	|	accessUrl: Option[URI],
	|	pid: Option[String],
	|	doi: Option[String],
	|	fileName: String,
	|	size: Option[Long],
	|	submission: DataSubmission,
	|	specification: DataObjectSpec,
	|	specificInfo: Either[L3SpecificMeta, L2OrLessSpecificMeta],
	|	previousVersion: OptionalOneOrSeq[URI],
	|	nextVersion: Option[URI],
	|	parentCollections: Seq[UriResource],
	|	citationString: Option[String]
	|)""".stripMargin

	ignore("workbench for manual testing"){
		val writer = new FileWriter("/home/oleg/tstests.ts")
		val transf = new NaiveTransformer(writer)
		try{
			transf.fromSource(example)
			writer.close()
			//println(writer.toString)
		}
		finally{
			writer.close()
		}
	}
}