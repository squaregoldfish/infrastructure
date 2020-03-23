package se.lu.nateko.cp.sbtfrontend

import sbt._
import sbt.io.IO
import sbt.Keys._
import java.io.File
import java.io.FileWriter
import scala.sys.process.Process
import UnixProcessWithChildren.ExitHooksProcReplacementOpt

object IcosCpSbtFrontendPlugin extends AutoPlugin{

	case class JarResourceImport(fromModule: ModuleID, fromPath: String, toApp: String, toFilename: String)

	object autoImport{
		val cpFrontendCommonApp = settingKey[String]("Name of the common-code front end project ('common' by default)")
		val cpFrontendApps = settingKey[Seq[String]]("The list of front-end apps (except the 'common' one)")
		val cpFrontendBuildScript = settingKey[String]("Path to the build script, relative to front end projects' folders")
		val cpFrontendJarImports = settingKey[Seq[JarResourceImport]]("Resources to be copied from the backend jars to front end apps")
		val cpFrontendDoJarImports = taskKey[Unit]("Copies files from jars to front end apps. Configured by cpFrontendJarImports setting.")
		val cpFrontendPublish = taskKey[Unit]("Builds the front end apps from scratch")
	}

	import autoImport._

	override lazy val projectSettings = Seq(
		cpFrontendCommonApp := "common",
		cpFrontendApps := Nil,
		cpFrontendJarImports := Nil,

		commands += cpFrontend(
			mainSrc = (Compile / sourceDirectory).value,
			buildScript = cpFrontendBuildScript.value,
			jsApps = cpFrontendApps.value :+ cpFrontendCommonApp.value
		),

		(Compile / dependencyClasspath) := { //does jar resource copying
			val deps = (Compile / dependencyClasspath).value
			val imports = cpFrontendJarImports.value
			val mainSrc = (Compile / sourceDirectory).value
			val log = streams.value.log
			imports.foreach{i =>
				val toFile = projectDir(mainSrc, i.toApp) / i.toFilename
				log.info(s"Copying ${i.fromPath} from ${i.fromModule} to $toFile")
				JarResourceHelper.copyResource(deps, i.fromModule, i.fromPath, toFile).get
			}
			deps
		},
		cpFrontendDoJarImports := (Compile / dependencyClasspath).map(_ => ()).value,

		cpFrontendPublish := {
			cpFrontendDoJarImports.value //(re-)importing the jar resources
			val mainSrc = (Compile / sourceDirectory).value
			val log = streams.value.log

			stopFrontendBuildProc(state.value)

			log.info("Starting front-end publish for common")
			Process("npm install", projectDir(mainSrc, cpFrontendCommonApp.value)).!
			val allApps = cpFrontendApps.value

			val errors: List[String] = allApps.map(projectDir(mainSrc, _)).par.map{pwd =>
				val projName = pwd.getName
				log.info("Starting front-end publish for " + projName)
				val exitCode = (Process("npm install", pwd) #&& Process("npm run publish", pwd)).!

				if(exitCode == 0) {
					log.info("Finished front-end build for " + projName)
					None
				}else {
					log.error(s"Front-end build for $projName failed")
					Some(s"Front end building for $projName returned non-zero exit code $exitCode")
				}
			}.toList.flatten

			if(errors.isEmpty)
				log.info("Front end builds are complete!")
			else
				throw new Exception(errors.mkString("\n"))
		}
	)

	private def projectDir(mainSrc: File, app: String): File = mainSrc / "js" / app
	private val frontentBuildProcKey = AttributeKey[UnixProcessWithChildren]("frontendBuildProcess")


	def stopFrontendBuildProc(state: State): Unit = {
		val log = state.log
		state.get(frontentBuildProcKey).foreach{proc =>
			if(proc.isAlive) {
				log.info(s"Terminating the front end build process (PID ${proc.pid}) (with children) and waiting for it to finish")
				proc.killAndWaitFor()
			}
			else log.info(s"The resident front end build process (PID ${proc.pid}) has already stopped")
		}
	}

	private def cpFrontend(
		mainSrc: File, buildScript: String, jsApps: Seq[String]
	) = Command.args("cpFrontend", "install | build <app>"){(state, args) =>

		val log = state.log

		def stopAndStart(forApp: Option[String]) = {
			stopFrontendBuildProc(state)
			forApp.fold(state.remove(frontentBuildProcKey).copy(exitHooks = state.exitHooks.dropProcessKilling)){app =>
				val proc = UnixProcessWithChildren.run(projectDir(mainSrc, app), "bash", "-c", buildScript)

				state
					.put(frontentBuildProcKey, proc)
					.copy(
						exitHooks = state.exitHooks.replaceProcToKill(proc.exitHook)
					)
			}
		}

		args.toList match {
			case "install" :: app :: Nil if jsApps.contains(app) =>
				log.info(s"Install $app")
				val exitCode = Process("npm install", projectDir(mainSrc, app)).!
				if (exitCode == 0) {
					log.info("Finished npm install for " + app)
					state
				} else {
					log.error(s"npm install for $app failed")
					state.fail
				}

			case "build" :: app :: Nil if jsApps.contains(app) =>
				log.info(s"Start resident process building front-end app $app")
				stopAndStart(Some(app))

			case "stop" :: Nil =>
				log.info(s"Stopping resident front-end building process (if any)")
				stopAndStart(None)
			case _ =>
				log.error("Usage: frontend install <app> | build <app> | stop, where <app> is one of: " + jsApps.mkString(", "))
				state.fail
		}

	}

}
