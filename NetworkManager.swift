import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private init(){}

    func requestActionApproval(action: String, details: [String:Any], completion: @escaping (Bool)->Void) {
        guard let url = URL(string: "\(AppConfig.serverBase)/requestApproval") else { completion(false); return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String:Any] = ["action": action, "details": details]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: req) { data, resp, err in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any],
                  let allowed = json["allowed"] as? Bool else {
                completion(false)
                return
            }
            completion(allowed)
        }.resume()
    }

    func notifyServerToSendEmail(payload: [String:Any], completion: @escaping (Bool)->Void) {
        guard let url = URL(string: "\(AppConfig.serverBase)/sendEmail") else { completion(false); return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        URLSession.shared.dataTask(with: req) { d,r,e in completion(e==nil); }.resume()
    }
}
