import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//    if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
//       let config = NSDictionary(contentsOfFile: path),
//       let apiKey = config["GOOGLE_MAPS_API_KEY"] as? String {
//
//    }
    GMSServices.provideAPIKey("AIzaSyAScDoRNbjGhpjOeBbxqr86lrAGzu1fv4w")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
