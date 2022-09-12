//
//  NewContactViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 13.07.2022.
//
import SwiftUI

extension NewContactView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        
        //MARK: - Properties
        
        @Published var image: UIImage?
        
        @Published var name = ""
        @Published var lastName = ""
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
        
        @Published var isTappedName = false
        @Published var isTappedLastName = false
        @Published var isTappedPhoneNumber = false

        @Published var contact: UserEntity? = nil
        
        @Published var isTappedGlobal = false
        
        private(set) var formattedPhone: String = ""
        
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
    }
}
