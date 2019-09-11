package se.lu.nateko.cp.sbttsgen

import sbt._
import sbt.io.IO
import sbt.Keys._
import java.io.File
import java.io.FileWriter

object IcosCpSbtTsGenPlugin extends AutoPlugin{

	private val OutFileName = "metacore.d.ts"

	object autoImport{
		val cpTsGenSources = settingKey[Seq[File]]("List of files with Scala sources to produce Typescript declarations for")
		val cpTsGenTypeMap = settingKey[Map[String, String]]("A set of custom Scala-Typescript type name mappings")
		val cpTsGenRun = taskKey[Seq[File]]("(Over)write the Typescript output file(s)")
	}

	import autoImport._

	override lazy val projectSettings = Seq(
		cpTsGenSources := Nil,
		cpTsGenTypeMap := Map.empty,
		cpTsGenRun := {
			val log = streams.value.log
			val sources = cpTsGenSources.value

			log.info("Generating Typescript code to be packaged in Scala library jar")
			if(sources.isEmpty) log.warn(
				"List of Scala sources for Typescript generation was empty. Set cpTsGenSources setting."
			)

			val outDir = resourceManaged.value
			IO.createDirectory(outDir)
			val outFile = outDir / OutFileName
			val writer = new FileWriter(outFile)
			try{
				val transf = new NaiveTransformer(writer)
				transf.declareMappings(cpTsGenTypeMap.value)
				cpTsGenSources.value.foreach{srcFile =>
					val src = IO.read(srcFile)
					transf.fromSource(src)
				}
				Seq(outFile)
			}
			finally{
				writer.close()
			}
		},
		Compile / resourceGenerators += cpTsGenRun
	)
}
