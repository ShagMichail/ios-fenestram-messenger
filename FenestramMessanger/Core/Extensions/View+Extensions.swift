//
//  View.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 06.07.2022.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        aligment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            ZStack(alignment: aligment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var i = 0
        var index = numbers.startIndex
        if numbers.count < mask.count  {
            for ch in mask where index < numbers.endIndex {
                if ch == "X" {
                    if i == 0 && mask.count == 16 {
                        result.append("7")
                        if numbers[index] == "9" {
                            result.append(numbers[index])
                        }
                        index = numbers.index(after: index)
                        i = i + 1
                    } else {
                        result.append(numbers[index])
                        index = numbers.index(after: index)
                    }
                } else {
                    result.append(ch)
                }
            }
        } else {
            var i = 0
            for ch in mask where index < numbers.endIndex {
                if i < mask.count {
                    if ch == "X" {
                        result.append(numbers[index])
                        index = numbers.index(after: index)
                        
                    } else {
                        result.append(ch)
                    }
                    i = i + 1
                }
            }
        }
        return result
    }
    
    
    func onBackSwipe(perform action: @escaping () -> Void, isEnabled: Bool = true) -> some View {
        gesture(
            DragGesture()
                .onEnded({ value in
                    if value.startLocation.x < UIScreen.screenWidth && value.translation.width > 20 && isEnabled {
                        action()
                    }
                })
        )
    }
}
