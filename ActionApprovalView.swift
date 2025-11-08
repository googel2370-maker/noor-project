import SwiftUI

struct ActionApprovalView: View {
    @Binding var isPresented: Bool
    var actionTitle: String
    var actionDesc: String
    var onConfirm: ()->Void

    var body: some View {
        VStack(spacing: 16) {
            Text(actionTitle).font(.headline)
            Text(actionDesc).font(.subheadline)
            HStack {
                Button("لغو") { isPresented = false }
                Button("اجازه بده") {
                    isPresented = false
                    onConfirm()
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 8)
    }
}
