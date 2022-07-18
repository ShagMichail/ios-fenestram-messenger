//
//  UIApplication+Extensions.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 15.07.2022.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
