package se.lu.nateko.cp.sbtdeploy

import sbt._
import sbt.Keys._
import sbt.plugins.JvmPlugin
import sbtassembly.AssemblyPlugin
import sbtbuildinfo.BuildInfoPlugin

import scala.sys.process.Process


object IcosCpSbtDeployPlugin extends AutoPlugin {

	override def trigger = noTrigger
	override def requires = AssemblyPlugin && BuildInfoPlugin

	override lazy val buildSettings = Seq()

	override lazy val globalSettings = Seq()

	object autoImport {
		val cpDeploy = inputKey[Unit]("Deploys to production using Ansible (depends on 'infrastructure' project)")
		val cpDeployTarget = settingKey[String]("Ansible target role for cpDeploy")
		val cpDeployBuildInfoPackage = settingKey[String]("Java/Scala package to put BuildInfo object into")
		val cpDeployPlaybook = settingKey[String]("The ansible playbook")
	}

	import autoImport._
	import AssemblyPlugin.autoImport.assembly
	import BuildInfoPlugin.autoImport._

	lazy val gitChecksTask = Def.task {
		val log = streams.value.log

		log.info("Check git status")
		val gitStatus = Process("git status -s").lineStream.mkString("").trim
		if(!gitStatus.isEmpty) sys.error("Please clean your 'git status -s' before deploying!")

		log.info("Check infrastructure version")
		val infrastructureDir = new java.io.File("../infrastructure/").getCanonicalFile
		Process("git -C " + infrastructureDir + " fetch")
		if (Process("git -C " + infrastructureDir + " rev-list HEAD...origin/master --count").!!.trim.toInt > 0) {
			sys.error("Your infrastructure repo is not in sync with origin/master.")
		}
	}

	lazy val cpAnsible = Def.inputTask {
		val log = streams.value.log
		val args: Seq[String] = sbt.Def.spaceDelimited().parsed

		val (check, test) = args.toList match{
			case "to" :: "production" :: Nil =>
				log.info("Performing a REAL deployment to production environment")
				(false, false)
			case "to" :: "test" :: Nil =>
				log.info("Performing a REAL deployment to test environment")
				(false, true)
			case _ =>
				log.warn("""Performing a TEST deployment to production environment, use\
								cpDeploy to production' for a real one""")
				(true, false)
		}

		// The full path of the "fat" jarfile. The jarfile contains the
		// entire application and this is the file we will deploy.
		val jarPath = assembly.value.getCanonicalPath

		// The ansible inventory file. This file contains a list of servers
		// that we deploy to. Running "cpDeploy to production" will make
		// ansible use our production environment and "cpDeploy to test"
		// will make ansible use test servers (i.e virtual machines running
		// on the developer host)
		val inventory = if (test) "test.inventory" else "production.inventory"

		// The name of the target, i.e the name of the current project
		// ("cpauth", "data", "meta" etc).
		val target = cpDeployTarget.value
		val playbook = cpDeployPlaybook.value

		val ansibleArgs = Seq(
			// "--check" will make ansible simulate all its actions. It's
			// only useful when running against the production inventory.
			if (check && !test) "--check" else None,

			// Add an ansible tag, e.g '-tcpdata_only'. Each ansible role that we use
			// is required to have a 'project_only' tag that will only to
			// (re)deployment of the jarfile, i.e it'll skip its dependencies (linux,
			// nginx, docker etc)
			"-t" + target + "_only",

			// Add an extra ansible variable specifying which jarfile to deploy.
			"-e", s"""${target}_jar_file="$jarPath"""",

			// Specify which inventory to use
			"-i", (if (test) "test.inventory" else "production.inventory"),

			playbook

		) collect { case s:String => s }
		val ansibleCmd = "ansible-playbook" +: ansibleArgs

		val ansibleDir = new java.io.File("../infrastructure/devops/").getCanonicalFile
		val ansiblePath = ansibleDir.getAbsolutePath
		if(!ansibleDir.exists || !ansibleDir.isDirectory) sys.error("Folder not found: " + ansiblePath)

		log.info(ansibleCmd.mkString("RUNNING:\n", " ", "\nIN DIRECTORY " + ansiblePath))

		Process(ansibleCmd, ansibleDir).run(true).exitValue()
	}

	override lazy val projectSettings = Seq(
		cpDeployPlaybook := "icosprod.yml",
		cpDeploy := cpAnsible.dependsOn(gitChecksTask).evaluated,
		buildInfoKeys := Seq[BuildInfoKey](name, version),
		buildInfoPackage := cpDeployBuildInfoPackage.value,
		buildInfoKeys ++= Seq(
			BuildInfoKey.action("buildTime") {java.time.Instant.now()},
			BuildInfoKey.action("gitOriginRemote") {
				Process("git config --get remote.origin.url").lineStream.mkString("")
			},
			BuildInfoKey.action("gitHash") {
				Process("git rev-parse HEAD").lineStream.mkString("")
			}
		)
	)
}
