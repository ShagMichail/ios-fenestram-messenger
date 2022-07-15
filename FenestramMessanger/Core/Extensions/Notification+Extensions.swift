//
//  Notification+Extensions.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 15.07.2022.
//

import UIKit

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension Notification.Name {
    public static let loginStatusChanged = Notification.Name("io.fasthome.FenestramMessanger.auth.changed")
}
