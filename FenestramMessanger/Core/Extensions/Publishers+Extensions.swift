//
//  Publishers+Extensions.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 15.07.2022.
//

import Combine
import UIKit

extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
