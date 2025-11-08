import Foundation
import Contacts
import UserNotifications
import AVFoundation
import Photos

final class PermissionManager {
    static let shared = PermissionManager()

    func requestAll(completion: @escaping ()->Void) {
        let group = DispatchGroup()

        group.enter()
        CNContactStore().requestAccess(for: .contacts) { _, _ in group.leave() }

        group.enter()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in group.leave() }

        group.enter()
        AVAudioSession.sharedInstance().requestRecordPermission { _ in group.leave() }

        group.enter()
        PHPhotoLibrary.requestAuthorization { _ in group.leave() }

        group.notify(queue: .main) { completion() }
    }
}
