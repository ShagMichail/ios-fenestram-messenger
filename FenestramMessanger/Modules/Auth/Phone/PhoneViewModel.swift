//
//  PhoneViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 06.07.2022.
//

import Foundation
import PhoneNumberKit

extension PhoneView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        
        //MARK: - Properties
        
        @Published var textPhone = "" {
            didSet {
                if textPhone.prefix(1) != "+" {
                    textPhone = "+" + textPhone
                }
                
                formattedPhone = textPhone
                    .replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: "(", with: "")
                    .replacingOccurrences(of: ")", with: "")
                    .replacingOccurrences(of: "-", with: "")
            }
        }
        
        private(set) var formattedPhone: String = ""
        
        @Published var isEditing: Bool = false
        @Published public var numberCount = false
        
        private let phoneNumberKit = PhoneNumberKit()
        
        
        //MARK: - Query functions
        
        func checkPhone() -> Bool {
            print("formatted phone: ", formattedPhone)
            
            return (try? phoneNumberKit.parse(formattedPhone)) != nil
        }
        
        func checkCode() {
            print("texphone:", formattedPhone, formattedPhone.count)
            if formattedPhone.count == 12 {
                
                numberCount = true
                
//                AuthService.sendCode(phoneNumber: textPhone) { [weak self] result in
//                    guard let self = self else { return }
//                    switch result {
//                    case .success(_):
//                        self.numberCount = true
//                    case .failure(let error):
//                        print("error: ", error.localizedDescription)
//                        self.numberCount = false
//                    }
//                }
            } else {
                numberCount = false
            }
        }
    }
}
