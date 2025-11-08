import SwiftUI

struct ContentView: View {
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var showApproval = false
    @State private var pendingAction: (title: String, desc: String, handler: ()->Void)?

    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages) { m in
                    HStack {
                        if m.sender == .noor { Spacer() }
                        Text(m.text).padding().background(Color.gray.opacity(0.1)).cornerRadius(8)
                        if m.sender == .user { Spacer() }
                    }.padding(4)
                }
            }
            HStack {
                TextField("پیام...", text: $inputText)
                Button("ارسال") {
                    sendMessage(text: inputText)
                    inputText = ""
                }
            }.padding()
        }
        .overlay(
            Group {
                if showApproval, let p = pendingAction {
                    ActionApprovalView(isPresented: $showApproval, actionTitle: p.title, actionDesc: p.desc, onConfirm: p.handler)
                }
            }
        )
        .onAppear {
            PermissionManager.shared.requestAll { /* ready */ }
        }
    }

    func sendMessage(text: String) {
        messages.append(ChatMessage(sender: .user, text: text))
        // مثال: نور می‌خواد ایمیل بفرسته -> قبلش درخواست اجازه کن
        if text.contains("ایمیل بفرست") {
            pendingAction = (title: "ارسال ایمیل", desc: "نور می‌خواهد ایمیلی به xyz@example.com بفرستد. اجازه می‌دهی؟", handler: {
                let payload = ["to":"xyz@example.com","subject":"از طرف نور","body":"سلام از نور"]
                NetworkManager.shared.notifyServerToSendEmail(payload: payload) { ok in
                    DispatchQueue.main.async {
                        let reply = ok ? "ایمیل فرستاده شد." : "ارسال ایمیل با خطا مواجه شد."
                        messages.append(ChatMessage(sender: .noor, text: reply))
                    }
                }
            })
            showApproval = true
            return
        }

        messages.append(ChatMessage(sender: .noor, text: "در حال پردازش..."))
    }
}
