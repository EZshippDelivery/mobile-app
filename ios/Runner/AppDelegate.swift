import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      GeneratedPluginRegistrant.register(with: self)
      GMSServices.provideAPIKey("AIzaSyCuvs8lj4MQgGWE26w3twaifCgxk_Vk8Yw")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
