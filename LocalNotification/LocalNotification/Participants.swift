//
//  Participants.swift
//  LocalNotification
//
//  Created by kazunori.aoki on 2022/04/01.
//

import Foundation
import Intents
import UIKit

struct Participants {

    // personHandle, isMe, suggestionType以外は基本的にはnilでOK
    static let demoParticipant: INPerson = INPerson(
        personHandle: INPersonHandle(value: "John-Appleseed@mac.com", type: .emailAddress), // 連絡先と照合するemail
        nameComponents: try? PersonNameComponents("John Appleseed"), // フルネームを設定（できる場合）
        displayName: "@john", // 表示名
        image: INImage(imageData: UIImage(systemName: "applelogo")!.pngData()!), // 後にアイコンになる
        contactIdentifier: nil, // 連絡先のunique id?
        customIdentifier: "john", //
        isMe: false,
        suggestionType: .instantMessageAddress
    )

    static let demoParticipant2: INPerson = INPerson(
        personHandle: INPersonHandle(value: "(555) 610-6679", type: .phoneNumber),
        nameComponents: try? PersonNameComponents("David Taylor"),
        displayName: "@david",
        image: INImage(imageData: UIImage(systemName: "capslock")!.pngData()!),
        contactIdentifier: nil,
        customIdentifier: "david",
        isMe: false,
        suggestionType: .instantMessageAddress
    )

    static let currentUser: INPerson = INPerson(
        personHandle: INPersonHandle(value: "test@example.com", type: .emailAddress),
        nameComponents: try? PersonNameComponents("Current User"),
        displayName: "@current",
        image: INImage(imageData: UIImage(systemName: "sun.max.fill")!.pngData()!),
        contactIdentifier: nil,
        customIdentifier: "current",
        isMe: true,
        suggestionType: .instantMessageAddress
    )
}
