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
        
        var numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        var result = ""
        var i = 0
        var index = numbers.startIndex
        if numbers.count < mask.count  {
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
               
                result.append(numbers[index])
                index = numbers.index(after: index)
                
            } else {
                result.append(ch)
            }
        }
        } else {
            //numbers.remove(at: numbers.index(before: numbers.endIndex))
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
//        if mask.count == 5 {
//            if result.count == 5 {
//                self.buttonColor = .blue
//            }
//        }
        return result
    }
}
