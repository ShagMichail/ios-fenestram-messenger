//
//  PhoneViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 06.07.2022.
//

import Foundation

extension PhoneView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var textPhone = ""
        
        @Published var text = ""
        
        @Published var isEditing: Bool = false
        @Published public var numberCount = false
        
        func checkCode() {
            if textPhone.count == 16 {
                numberCount = true
            } else {
                numberCount = false
            }
        }
    }
}
