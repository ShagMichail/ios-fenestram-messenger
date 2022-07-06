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
        @Published public var flag = false
        
        func checkCode () {
            if textPhone.count == 18 {
                
                flag = true
            } else {
                flag = false
            
            }
            
        }
    }
}
