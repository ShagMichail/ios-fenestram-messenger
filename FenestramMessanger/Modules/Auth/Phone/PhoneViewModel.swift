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
        
        
        //MARK: - Properties
        
        @Published var textPhone = ""
        
        @Published var text = ""
        
        @Published var isEditing: Bool = false
        @Published public var numberCount = false
        
        
        //MARK: - Query functions
        
        func checkCode() {
            if textPhone.count == 16 {
                AuthService.sendCode(phoneNumber: textPhone) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        self.numberCount = true
                    case .failure(let error):
                        print("error: ", error.localizedDescription)
                        self.numberCount = false
                    }
                }
            } else {
                numberCount = false
            }
        }
    }
}
