import UIKit
import Flutter
import SCSDKCreativeKit

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
  let snapAPI = SCSDKSnapAPI()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "snapkit", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      switch call.method {

      case "sharePhoto":
        guard let args = call.arguments as? [String: Any],
              let path = args["path"] as? String,
              let image = UIImage(contentsOfFile: path) else {
          result(FlutterError(code: "ARGS", message: "Invalid image path", details: nil))
          return
        }
        let snapPhoto = SCSDKSnapPhoto(image: image)
        let content = SCSDKPhotoSnapContent(snapPhoto: snapPhoto)
        if let cap = args["caption"] as? String { content.caption = cap }
        self.snapAPI.startSending(content) { error in
          if let error = error {
            result(FlutterError(code: "SNAP_SEND_ERR", message: error.localizedDescription, details: nil))
          } else { result(true) }
        }

      case "shareVideo":
        guard let args = call.arguments as? [String: Any],
              let path = args["path"] as? String else {
          result(FlutterError(code: "ARGS", message: "Invalid video path", details: nil))
          return
        }
        let url = URL(fileURLWithPath: path)
        let snapVideo = SCSDKSnapVideo(videoURL: url)
        let content = SCSDKVideoSnapContent(snapVideo: snapVideo)
        if let cap = args["caption"] as? String { content.caption = cap }
        self.snapAPI.startSending(content) { error in
          if let error = error {
            result(FlutterError(code: "SNAP_SEND_ERR", message: error.localizedDescription, details: nil))
          } else { result(true) }
        }

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
