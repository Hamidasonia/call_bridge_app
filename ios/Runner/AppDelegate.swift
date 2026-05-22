import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        GeneratedPluginRegistrant.register(with: self)

        guard let controller = self.window?.rootViewController as? FlutterViewController else {
            return super.application(
                application,
                didFinishLaunchingWithOptions: launchOptions
            )
        }

        let channel = FlutterMethodChannel(
            name: "call_bridge",
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler {
            (call: FlutterMethodCall, result: @escaping FlutterResult) in

            switch call.method {

            case "makeCall":

                guard let args = call.arguments as? [String: Any],
                      let phoneNumber = args["phoneNumber"] as? String else {

                    result(
                        FlutterError(
                            code: "INVALID_ARGS",
                            message: "Phone number missing",
                            details: nil
                        )
                    )
                    return
                }

                if let url = URL(string: "tel://\(phoneNumber)") {

                    UIApplication.shared.open(url)

                    result("success")

                } else {

                    result(
                        FlutterError(
                            code: "INVALID_PHONE",
                            message: "Invalid phone number",
                            details: nil
                        )
                    )
                }

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}