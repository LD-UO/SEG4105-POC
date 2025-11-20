**Personal Food Log App**

  Prerequisites

  - Flutter 3.29+ (flutter --version)
  - Xcode 15+ (for iOS builds), CocoaPods (sudo gem install cocoapods)
  - Node.js + npm (only if you want to run the local stub backend)
  - An AWS HTTP API endpoint (GET /ping, POST /analyze, POST /feedback) or use the provided stub.

  Project Layout

  - flutter_app/ – main Flutter project (all mobile code).
  - backend_stub/ – optional local Node/Express stub server returning fixed AI data.

  Flutter App Setup

  1. Install dependencies:

     cd flutter_app
     flutter pub get
  2. (iOS) Install pods:

     cd ios
     arch -x86_64 pod install   # on Apple Silicon
     cd ..
  3. Configure backend:
      - Edit lib/config.dart and set backendBaseUrl to your AWS endpoint, e.g.

        const String backendBaseUrl = 'https://<api-id>.execute-api.<region>.amazonaws.com';
      - For local testing, set it to 'mock' (no network) or point to the stub
  http://127.0.0.1:3000.
  4. Run:

     flutter run   # picks a connected device/simulator
     flutter run -d <device_id>   # explicit

  Local Stub Backend (optional)

  1. Start the stub:

     cd backend_stub
     npm install
     node server.js   # serves /analyze and /feedback
  2. Set backendBaseUrl = 'http://127.0.0.1:3000' for iOS simulator (use LAN IP for physical
  device).

  iOS Deployment

  - Always open ios/Runner.xcworkspace in Xcode.
  - Signing: Runner target → Signing & Capabilities → set your Team and a unique Bundle ID (e.g.,
  com.yourname.seg4105poc).
  - Permissions: ios/Runner/Info.plist must include NSCameraUsageDescription and
  NSPhotoLibraryUsageDescription.
  - Build/run from Xcode, or from CLI with flutter run -d <iphone_udid>.

  If you see pod install errors, rerun flutter pub get first, then pod install. Command
  PhaseScriptExecution failed usually means the workspace wasn’t opened or DART_DEFINES was
  blank; building once via flutter run or clearing DART_DEFINES in Xcode resolves it.

  Android Deployment

  - Ensure an emulator or device is connected.
  - Run flutter run -d android or use Android Studio.

  Verifying AWS Calls

  - When you pick a photo, logs show:

    [timestamp] POST https://<api>/analyze
    [timestamp] /analyze status=200
  - After thumbs up/down:

    [timestamp] POST https://<api>/feedback liked=true
    [timestamp] /feedback status=200
  - These logs appear in flutter run output, Xcode console, or Android Studio’s logcat.

  Troubleshooting

  - pod install complains Generated.xcconfig missing: run flutter pub get first.
  - Device build crashes immediately: check Info.plist permissions.
  - Xcode “Run Script” error: ensure you’re using the workspace, run flutter clean && flutter pub
  get, and clear DART_DEFINES in Build Settings if needed.

  ———
