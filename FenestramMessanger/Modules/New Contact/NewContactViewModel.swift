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
        //@Published var contacts = [Contact(id: 0, name: "Natasha", imageName: "photo")]
        @Published var birthday: Date? = nil
        
        @Published var image: UIImage?
        
        @Published var name = ""
        @Published var lastName = ""
        @Published var textPhone = ""
        
        @Published var isTappedName = false
        @Published var isTappedLastName = false
        @Published var isTappedPhoneNumber = false
        
        @Published public var flag = false
        //@Published var isEditing: Bool = false
        
        @Published var isTappedGlobal = false
        
        func checkCode () {
            if textPhone.count == 16 {

                flag = true
            } else {
                flag = false

            }

        }
//        @Published var filteredContacts: [Contact] = []
////        @Published var filteredContacts: [Contact] = [Contact(id: 0, name: "Natasha", imageName: "photo"),
////                                                      Contact(id: 1, name: "Igoresha", imageName: "photo"),
////                                                      Contact(id: 2, name: "Ctepasha", imageName: "photo"),
////                                                      Contact(id: 3, name: "Irisha", imageName: "photo"),
////                                                      Contact(id: 4, name: "Natasha", imageName: "photo"),
////                                                      Contact(id: 5, name: "Igoresha", imageName: "photo"),
////                                                      Contact(id: 6, name: "Ctepasha", imageName: "photo"),
////                                                      Contact(id: 7, name: "Irisha", imageName: "photo"),
////                                                      Contact(id: 8, name: "Natasha", imageName: "photo"),
////                                                      Contact(id: 9, name: "Igoresha", imageName: "photo"),
////                                                      Contact(id: 10, name: "Ctepasha", imageName: "photo"),
////                                                      Contact(id: 11, name: "Irisha", imageName: "photo")]
//        @Published var values: [Contact] = [
//            Contact(id: 0, name: "Natasha", imageName: "photo"),
//            Contact(id: 1, name: "Igoresha", imageName: "photo"),
//            Contact(id: 2, name: "Ctepasha", imageName: "photo"),
//            Contact(id: 3, name: "Irisha", imageName: "photo"),
//            Contact(id: 4, name: "Natasha", imageName: "photo"),
//            Contact(id: 5, name: "Igoresha", imageName: "photo"),
//            Contact(id: 6, name: "Ctepasha", imageName: "photo"),
//            Contact(id: 7, name: "Irisha", imageName: "photo"),
//            Contact(id: 8, name: "Natasha", imageName: "photo"),
//            Contact(id: 9, name: "Igoresha", imageName: "photo"),
//            Contact(id: 10, name: "Ctepasha", imageName: "photo"),
//            Contact(id: 11, name: "Irisha", imageName: "photo")
//        ]
//        
//        func filterContent() {
//            let lowercasedSearchText = searchText.lowercased()
//
//            if searchText.count > 0 {
//                var matchingCoffees: [Contact] = []
//
//                values.forEach { contact in
//                    let searchContent = contact.name
//                    if searchContent.lowercased().range(of: lowercasedSearchText, options: .regularExpression) != nil {
//                        matchingCoffees.append(contact)
//                    }
//                }
//
//                self.filteredContacts = matchingCoffees
//
//            } else {
//                filteredContacts = values
//            }
//        }
    }
}
