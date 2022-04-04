//
//  ViewController.swift
//  LocalNotification
//
//  Created by kazunori.aoki on 2022/03/31.
//

import UIKit
import Intents

class ViewController: UIViewController {
    
    let categoryId = "category_select"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapLocalNotificationButton(_ sender: Any) {
        sendNotification()
    }
}

private extension ViewController {
    
    func sendNotification() {
        
        let sender = [Participants.demoParticipant, Participants.demoParticipant2].randomElement()!
        dump(sender)

        let intent = INSendMessageIntent(
            recipients: [Participants.currentUser], // nullable: メッセージを受信するユーザ
            outgoingMessageType: .outgoingMessageText, // メッセージの形式（plain, audio, unknown）
            content: "テスト、テスト、テスト", // nullable:メッセージの内容
            speakableGroupName: INSpeakableString(spokenPhrase: sender.displayName), // nullable: メッセージを受信するグループ名
            conversationIdentifier: "chat001", // nullable: message id
            serviceName: nil, // nullable:メッセージ送信のサービス（いろいろな方法で通知を行う場合入れる）
            sender: sender, // nullable: メッセージを送信しているアカウント
            attachments: nil // nullable: メッセージに含めるオーディオファイル
        )
        intent.setImage(sender.image, forParameterNamed: \.sender)

        let interaction = INInteraction(intent: intent, response: nil)
        interaction.direction = .incoming

        interaction.donate { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }

        let icon1 = UNNotificationActionIcon(systemImageName: "hand.thumbsup")
        let action1 = UNNotificationAction(identifier: ActionIdentifier.action1.rawValue,
                                           title: "アクション1",
                                           options: [],
                                           icon: icon1)

        let icon2 = UNNotificationActionIcon(templateImageName: "text.bubble")
        let action2 = UNTextInputNotificationAction(identifier: ActionIdentifier.action2.rawValue,
                                                    title: "アクション2",
                                                    options: [],
                                                    icon: icon2,
                                                    textInputButtonTitle: "Post",
                                                    textInputPlaceholder: "Type here…")

        let category = UNNotificationCategory(identifier: categoryId,
                                              actions: [action1, action2],
                                              intentIdentifiers: [],
                                              options: [])

        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = self

        let number: NSNumber = NSNumber(value: Int.random(in: 1...5))
        
        let content: UNMutableNotificationContent = {
            var content = UNMutableNotificationContent()
            content.title = "title"
            content.subtitle = "subtitle"
            content.body = "body"
            content.sound = UNNotificationSound.default
            content.badge = number
            content.interruptionLevel = .timeSensitive // 通知の優先レベル
            content.categoryIdentifier = categoryId
            content.relevanceScore = 0.5 // 通知の表示優先順位
            
            // 画像等の添付（local urlのみ）
            //            content.attachments = [
            //                try! .init(identifier: "Image", url: URL(string: "https://jp.techcrunch.com/wp-content/uploads/2021/11/twitter-2021-10-d-2.jpg?w=738")!)
            //            ]
            
            content = try! content.updating(from: intent) as! UNMutableNotificationContent
            
            return content
        }()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

extension ViewController: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: () -> Swift.Void) {
        
        switch response.actionIdentifier {
        case ActionIdentifier.action1.rawValue:
            print("tap action 1")
            
        case ActionIdentifier.action2.rawValue:
            print("tap action 2")

        default:
            break
        }

        completionHandler()
    }
}

enum ActionIdentifier: String {
    case action1
    case action2
}
