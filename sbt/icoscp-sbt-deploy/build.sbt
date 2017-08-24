name := "icoscp-sbt-deploy"
organization := "se.lu.nateko.cp"
version := "0.1-SNAPSHOT"

sbtPlugin := true

publishTo := {
	val nexus = "https://repo.icos-cp.eu/content/repositories/"
	if (isSnapshot.value)
		Some("snapshots" at nexus + "snapshots")
	else
		Some("releases"  at nexus + "releases")
}

credentials += Credentials(Path.userHome / ".ivy2" / ".credentials")

libraryDependencies ++= {

	def pluginDependency(pluginModule: ModuleID): ModuleID =
		Defaults.sbtPluginExtra(pluginModule, sbtBinaryVersion.value, scalaBinaryVersion.value)

	Seq(
		pluginDependency("com.eed3si9n" % "sbt-assembly" % "0.14.5"),
		pluginDependency("com.eed3si9n" % "sbt-buildinfo" % "0.7.0")
	)
}

