import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  // Dart variant name -> alternate icon set; `nil` is the primary AppIcon.
  private static let appIcons: [String: String?] = [
    "midnight": nil,
    "light": "AppIconLight",
    "green": "AppIconGreen",
  ]

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "AppIcon") else { return }
    FlutterMethodChannel(name: "holapp/app_icon", binaryMessenger: registrar.messenger())
      .setMethodCallHandler(Self.handleAppIconCall)
  }

  private static func handleAppIconCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getIcon":
      // A nil result tells Dart that icons can't be changed here.
      guard UIApplication.shared.supportsAlternateIcons else { return result(nil) }
      let current = UIApplication.shared.alternateIconName
      result(appIcons.first { $0.value == current }?.key)
    case "setIcon":
      guard let name = call.arguments as? String, let iconName = appIcons[name] else {
        return result(FlutterError(code: "unknown_icon", message: nil, details: call.arguments))
      }
      UIApplication.shared.setAlternateIconName(iconName) { error in
        // UIKit calls this on a queue of its own; Flutter wants results on main.
        DispatchQueue.main.async {
          result(error.map { FlutterError(code: "set_failed", message: $0.localizedDescription, details: nil) })
        }
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
