plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.batteryqk.batteryqk_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.batteryqk.batteryqk_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = 11
        versionName = "1.0.0"
        multiDexEnabled = true
    }


    signingConfigs {
        create("release") {
            // Hardcoded values
            storeFile = file("C:\\Users\\HP\\Flutter Projects\\Batteryqk-WebApp\\android\\batteryqk.jks")  // Full path to your .jks file
            storePassword = "mts@2025"   // Keystore password
            keyAlias = "battery"         // Key alias
            keyPassword = "mts@2025"     // Key password
        }
    }

//    signingConfigs {
//        create("release") {
//            // Load properties from key.properties file
//            val keyProperties = file("key.properties").apply { if (!exists()) throw GradleException("key.properties not found!") }.inputStream()
//                .use { Properties().apply { load(it) } }
//
//            val storeFilePath = keyProperties["storeFile"]?.toString()
//            val storePassword = keyProperties["storePassword"]?.toString()
//            val keyAlias = keyProperties["keyAlias"]?.toString()
//            val keyPassword = keyProperties["keyPassword"]?.toString()
//
//            // Check if properties are missing
//            if (storeFilePath == null || storePassword == null || keyAlias == null || keyPassword == null) {
//                throw GradleException("Missing signing configuration properties.")
//            }
//
//            // Set the keystore and properties
//            storeFile = file(storeFilePath)
//            storePassword = storePassword
//            keyAlias = keyAlias
//            keyPassword = keyPassword
//        }
//    }



    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
