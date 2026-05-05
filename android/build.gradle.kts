allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    if (project.name == "isar_flutter_libs") {
        project.buildscript {
            repositories {
                google()
                mavenCentral()
            }
        }

        // Fix namespace issue for modern AGP
        project.plugins.withId("com.android.library") {
            val androidExt = project.extensions.findByName("android")
            if (androidExt != null) {
                try {
                    androidExt.javaClass.getMethod("setNamespace", String::class.java).invoke(androidExt, "dev.isar.isar_flutter_libs")
                } catch (e: Exception) {
                    // Ignore
                }
            }
        }
    }
}

gradle.projectsEvaluated {
    // Force compileSdkVersion to 36 for all modules to fix lStar resource missing error
    subprojects {
        if (project.hasProperty("android")) {
            val androidExt = project.extensions.findByName("android")
            if (androidExt != null) {
                try {
                    androidExt.javaClass.getMethod("setCompileSdkVersion", Int::class.java).invoke(androidExt, 36)
                } catch (e: Exception) {
                    try {
                         androidExt.javaClass.getMethod("setCompileSdkVersion", String::class.java).invoke(androidExt, "android-36")
                    } catch (e2: Exception) {}
                }
            }
        }
    }

    // Disable resource verification specifically for isar_flutter_libs
    findProject(":isar_flutter_libs")?.tasks?.all {
        if (name.startsWith("verify") && name.endsWith("Resources")) {
            enabled = false
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
