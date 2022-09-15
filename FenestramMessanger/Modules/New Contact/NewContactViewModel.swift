//
//  NewContactViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 13.07.2022.
//

import SwiftUI
import PhoneNumberKit

extension NewContactView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        
        //MARK: - Properties
        
        @Published var image: UIImage?
        
        @Published var name = ""
        @Published var lastName = ""
        @Published var textPhone = "" {
            didSet {
                guard textPhone.count > 0 else {
                    return
                }
                
                if textPhone == "8" {
                    textPhone = "+7"
                } else if textPhone.prefix(1) != "+" {
                    textPhone = "+" + textPhone
                }
                
                formattedPhone = textPhone
                    .replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: "(", with: "")
                    .replacingOccurrences(of: ")", with: "")
                    .replacingOccurrences(of: "-", with: "")
            }
        }
        
        @Published var isTappedName = false
        @Published var isTappedLastName = false
        @Published var isTappedPhoneNumber = false

        @Published var contact: UserEntity? = nil
        
        @Published var isTappedGlobal = false
        
        private(set) var formattedPhone: String = ""
        
        private let phoneNumberKit = PhoneNumberKit()
        
        func checkPhoneNumber() -> Bool {
            return (try? phoneNumberKit.parse(formattedPhone)) != nil
        }
        
        func addContact(completion: @escaping (Bool) -> ()) {
            ContactsService.postContacts(name: name + (lastName.isEmpty ? "" : " \(lastName)"), phoneNumber: formattedPhone) { result in
                switch result {
                case .success:
                    print("add contact success")
                    completion(true)
                case .failure(let error):
                    print("add contact failure with error: ", error)
                    completion(false)
                }
            }
        }
        
        func limitFirstNameText(_ upper: Int) {
            if name.count > upper {
                name = String(name.prefix(upper))
            }
        }
        
        func limitLastNameText(_ upper: Int) {
            if lastName.count > upper {
                lastName = String(lastName.prefix(upper))
            }
        }
    }
}
