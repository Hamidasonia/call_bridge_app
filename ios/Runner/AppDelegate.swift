import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

    private let CHANNEL = "call_bridge"

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller : FlutterViewController =
            window?.rootViewController as! FlutterViewController

        let methodChannel = FlutterMethodChannel(
            name: CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )

        methodChannel.setMethodCallHandler {
            (call: FlutterMethodCall,
             result: @escaping FlutterResult) in

            if call.method == "makeCall" {

                guard let args =
                        call.arguments as? [String: Any],
                      let phoneNumber =
                        args["phoneNumber"] as? String
                else {
                    result(
                        FlutterError(
                            code: "INVALID_ARGUMENT",
                            message: "Phone number missing",
                            details: nil
                        )
                    )
                    return
                }

                if let url = URL(
                    string: "tel://\(phoneNumber)"
                ) {

                    UIApplication.shared.open(url)

                    result(nil)

                } else {

                    result(
                        FlutterError(
                            code: "INVALID_URL",
                            message: "Invalid phone number",
                            details: nil
                        )
                    )
                }

            } else {

                result(FlutterMethodNotImplemented)
            }
        }

        GeneratedPluginRegistrant.register(
            with: self
        )

        return super.application(
            application,
            didFinishLaunchingWithOptions:
            launchOptions
        )
    }
}