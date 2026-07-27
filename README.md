# MedicAI 🩺🤖

**MedicAI** is a next-generation, privacy-first medical AI assistant built with Flutter. It features a unique **hybrid intelligence architecture**, allowing users to seamlessly toggle between a lightning-fast Cloud API (Gemini) and a **100% offline, private on-device AI engine** (LiteRTLM). 

Designed with clinical transparency, data security, and modern aesthetics in mind.

---

## ✨ Key Features

- **Hybrid AI Engine**: Switch between Cloud AI for expansive, complex queries, and Local AI for strict, offline privacy.
- **100% Private Local Inference**: Built-in model manager allows users to securely download and run a ~2.8GB medical language model entirely on-device. No internet connection required. Your medical data never leaves your phone.
- **Transparent Reasoning Traces**: Medical advice requires trust. MedicAI visually separates the model's "inner thoughts" (reasoning process) from the final clinical answer, allowing you to see exactly how the AI reached its conclusion.
- **Cost-Controlled Cloud API**: When using the Cloud API (`gemini-3.5-flash-lite`), the app implements smart token guards—automatically limiting context windows and restricting chats to a maximum of 2 queries per session to prevent token explosion.
- **Multimodal Chat Interface**: Supports attaching images and audio recordings (Cloud Mode) for natural, comprehensive diagnostic queries.
- **Full Multilingual Support**: Natively localized in **English**, **Russian**, and **Uzbek**.
- **Modern UI/UX**: Built with fluid animations, dynamic markdown rendering, and a premium glassmorphism aesthetic.

---

## 🏗️ Architecture

- **Framework**: Flutter (Dart)
- **Local Engine**: LiteRT (TensorFlow Lite) / Google ML Kit bindings for on-device generative AI.
- **Cloud Engine**: Google Gemini API (`gemini-3.5-flash-lite`) integrated via Dio.
- **Local Storage**: Drift (SQLite) for persistent, localized conversation history.
- **State Management**: `Provider` architecture for reactive UI updates across the chat, settings, and model management screens.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (stable channel)
- Android Studio / Android SDK (AGP 8.7.0, Kotlin 1.9.24)
- Physical Android device (Recommended for local model inference; emulators may struggle with the 2.8GB memory overhead).

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/medicai.git
   cd medicai
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Localization Files:**
   If you modify the `.arb` translation files, regenerate the Dart bindings:
   ```bash
   flutter gen-l10n
   ```

4. **Run the App:**
   ```bash
   flutter run
   ```
   *(Note: For the best performance with the local model, run the app in release mode: `flutter run --release`)*

---

## 🛠️ Building for Release

Due to the heavy C++ native libraries required for the local LLM inference engine, you must disable R8 code obfuscation in the Android release build to prevent the JNI bindings from breaking. This has already been configured in `app/build.gradle.kts`.

To generate a release APK:
```bash
flutter build apk --release
```
*(The resulting APK will be relatively large as it contains native binaries. You can use `--split-per-abi` to reduce size for specific device architectures).*

---

## 🔒 Privacy & Data

- **Cloud Mode**: Medical data is sent over a secure connection to the specified Gateway URL. Token limits are enforced client-side.
- **Local Mode**: The application sandbox securely stores the downloaded `.litertlm` binary file in `/data/user/0/...` ensuring other apps cannot access it. All inference happens strictly on the CPU/GPU of the local device.

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
