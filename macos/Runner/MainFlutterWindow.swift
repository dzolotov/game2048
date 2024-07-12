import Cocoa
import FlutterMacOS
import UserNotifications

class MainFlutterWindow: NSWindow {
    let notificationCenter = UNUserNotificationCenter.current()

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    let notificationChannel = FlutterMethodChannel(name: "notifications_plugin", binaryMessenger: flutterViewController.engine.binaryMessenger)
    notificationChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch call.method {
            case "requestPermission":
            self.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) {
              (granted, error) in
                if granted {
                  print("Permission granted")
                  result(true)
                } else {
                  print("Permission denied")
                  result(false)
                }
            }
            case "showNotification":
            let args = call.arguments as! Dictionary<String, Any?>
            let title = args["title"]
            let subtitle = args["subtitle"]
            let body = args["body"]
            self.notificationCenter.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else {
                    print("Notifications is disabled")
                    return
                }
                let content = UNMutableNotificationContent()
                content.title = title as! String
                content.subtitle = subtitle as! String
                content.body = body as! String
                content.sound = UNNotificationSound.default
                let request = UNNotificationRequest(identifier: "flutter.example.notification", content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))
                self.notificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        result(false)
                    } else {
                        print("Notification added")
                        result(true)
                    }
                }
            }
        default:
          result(FlutterMethodNotImplemented)
        }
      })

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
