# icoscp-sbt-deploy

An sbt plugin with ICOS Carbon Portal specific tasks for single-jar app deployment.

It depends on (and thereby adds to a build project) other two plugins: sbt-assembly and sbt-buildinfo.

## Usage

The plugin is recommended for use with sbt 0.13.15+

Your project that you want to use the plugin in must be in a folder next to the `infrastructure` project that contains Ansible configs.

You must have Ansible installed on your system.

Make sure you configured sbt to use CP's Nexus repo at `https://repo.icos-cp.eu/` for dependency resolution. This can be done with `.sbtopts` file in your project root and `repositories` file in your build's `project/` folder. See `cpauth`, `meta`, or `data` builds for example.

Add the following line to `plugins.sbt` in your build's `project/` folder:

`addSbtPlugin("se.lu.nateko.cp" % "icoscp-sbt-deploy" % "0.1-SNAPSHOT")`

The plugin is not triggered automatically, and must be enabled for every build project explicitly. Your build project must have values set for settings `cpDeployTarget` and `cpDeployBuildInfoPackage`. For example:

`lazy val myCpProject = (project in file("."))
	.enablePlugins(IcosCpSbtDeployPlugin)
	.settings(
		cpDeployTarget := "mycpproject",
		cpDeployBuildInfoPackage := "se.lu.nateko.cp.mycpproject",
	)`

This will add a task `cpDeploy` to sbt, which you can use as is to dry-run Ansible deploy, or run `cpDeploy to production` perform real deployment.

Finally, icoscp-sbt-deploy configures sbt-buildinfo to produce an appropriate `BuildInfo` object in the package that you specified with `cpDeployBuildInfoPackage`.

