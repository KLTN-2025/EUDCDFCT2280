plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// 🟢 1. ĐOẠN CODE MỚI (Chuẩn Kotlin): Đọc file key.properties
val keystoreProperties = java.util.Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.ecolive.converter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.ecolive.converter"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    // 🟢 2. CẤU HÌNH CHỮ KÝ SỐ (Signing Config)
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = if (keystoreProperties["storeFile"] != null) {
                file(keystoreProperties["storeFile"] as String)
            } else {
                null
            }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        getByName("release") {
            // 🟢 3. ÁP DỤNG KEY CHO BẢN RELEASE
            signingConfig = signingConfigs.getByName("release")
            
            // Tối ưu hóa (Tắt tạm để tránh lỗi R8 nếu chưa config kỹ)
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation("com.tom-roush:pdfbox-android:2.0.25.0")
}

// Fix lỗi thư viện PDFBox (nếu có)
configurations.all {
    resolutionStrategy.eachDependency { 
        if (requested.group == "com.tom_roush" && requested.name == "pdfbox-android") {
            useTarget("com.tom-roush:pdfbox-android:2.0.25.0")
        }
    }
}