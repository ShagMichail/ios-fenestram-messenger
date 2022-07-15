//
//  CodeViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 06.07.2022.
//

import Foundation

extension CodeView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        
        @Published public var text = ""
        @Published public var textCode = ""
        @Published public var codeCount = false
        @Published public var errorCode = false
        
        let code = "12345"
        
        func checkCode () {
            if textCode == code {
                codeCount = true
            } else {
                codeCount = false
                errorCode = true
            }
        }
        
        func changeIncorrect()  {
            if textCode.count < 5 {
                errorCode = false
            }
            self.textCode = ""
        }
    }
}
