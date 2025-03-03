import java.io.File
import java.io.FileInputStream
import java.util.*
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
val keyProperties = Properties().apply {
    load(FileInputStream(File("key.properties")))
}
android {
    namespace = "net.pericles.restaurantpos"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
    signingConfigs {
        create("release") {
            keyAlias = keyProperties.getProperty("keyAlias")
            keyPassword = keyProperties.getProperty("keyPassword")
            // 使用绝对路径解决相对路径问题
            storeFile = keyProperties.getProperty("storeFile")?.let {
                File(rootProject.projectDir, it)  // 确保路径从项目根目录开始
            }
            storePassword = keyProperties.getProperty("storePassword")
        }
    }
    defaultConfig {
        applicationId = "net.pericles.restaurantpos"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
        }
        debug {
            // TODO: Add your own signing config for the debug build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
