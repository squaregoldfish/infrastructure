package se.lu.nateko.cp.sbtdeploy

import sbt._
import sbt.Keys._
import sbt.plugins.JvmPlugin
import sbtassembly.AssemblyPlugin
import sbtbuildinfo.BuildInfoPlugin


object IcosCpSbtDeployPlugin extends AutoPlugin {

	override def trigger = noTrigger
	override def requires = AssemblyPlugin && BuildInfoPlugin

	override lazy val buildSettings = Seq()

	override lazy val globalSettings = Seq()

	object autoImport {
		val cpDeploy = inputKey[Unit]("Deploys to production using Ansible (depends on 'infrastructure' project)")
		val cpDeployTarget = settingKey[String]("Ansible target role for cpDeploy")
		val cpDeployBuildInfoPackage = settingKey[String]("Java/Scala package to put BuildInfo object into")
	}

	import autoImport._
	import AssemblyPlugin.autoImport.assembly
	import BuildInfoPlugin.autoImport._

	override lazy val projectSettings = Seq(
		cpDeploy := {
			val gitStatus = sbt.Process("git status -s").lines.mkString("").trim
			if(!gitStatus.isEmpty) sys.error("Please clean your 'git status -s' before deploying!")

			val log = streams.value.log
			val args: Seq[String] = sbt.Def.spaceDelimited().parsed

			val check = args.toList match{
				case "to" :: "production" :: Nil =>
					log.info("Performing a REAL deployment to production")
					false
				case _ =>
					log.warn("Performing a TEST deployment, use 'cpDeploy to production' for a real one")
					true
			}

			val jarPath = assembly.value.getCanonicalPath

			val target = cpDeployTarget.value

			val mandatoryArgs = Seq(
				"--ask-sudo", "-t" + target,
				"-e", s"""${target}_jar_file="$jarPath"""",
				"-i", "production.inventory", "icosprod.yml"
			)

			val cmd = "ansible-playbook" +: (
				if(check) "--check" +: mandatoryArgs else mandatoryArgs
			)

			val ansibleDir = new java.io.File("../infrastructure/devops/").getCanonicalFile
			val ansiblePath = ansibleDir.getAbsolutePath
			if(!ansibleDir.exists || !ansibleDir.isDirectory) sys.error("Folder not found: " + ansiblePath)

			log.info(cmd.mkString("RUNNING:\n", " ", "\nIN DIRECTORY " + ansiblePath))

			sbt.Process(cmd, ansibleDir).run(true).exitValue()
		},
		buildInfoKeys := Seq[BuildInfoKey](name, version),
		buildInfoPackage := cpDeployBuildInfoPackage.value,
		buildInfoKeys ++= Seq(
			BuildInfoKey.action("buildTime") {java.time.Instant.now()},
			BuildInfoKey.action("gitOriginRemote") {
				sbt.Process("git config --get remote.origin.url").lines.mkString("")
			},
			BuildInfoKey.action("gitHash") {
				sbt.Process("git rev-parse HEAD").lines.mkString("")
			}
		)
	)
}
