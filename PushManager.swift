import Foundation
import UIKit

final class PushManager {
    static let shared = PushManager()
    private init(){}

    func registerForPush() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    func sendDeviceTokenToServer(_ token: Data) {
        let tokenString = token.map { String(format: "%02.2hhx", $0) }.joined()
        guard let url = URL(string: "\(AppConfig.serverBase)/registerDevice") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["deviceToken": tokenString, "platform": "ios"]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: req).resume()
    }
}
