import Foundation

enum Sender: String, Codable { case user, noor }

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let sender: Sender
    let text: String
    let date: Date

    init(sender: Sender, text: String) {
        self.id = UUID()
        self.sender = sender
        self.text = text
        self.date = Date()
    }
}
