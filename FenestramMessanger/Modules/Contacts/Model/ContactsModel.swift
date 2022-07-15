//
//  ContactsModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI

extension ContactsView {
    @MainActor
    final class ViewModel: ObservableObject {
        //@Published var contacts = [Contact(id: 0, name: "Natasha", imageName: "photo")]
        @Published var contact: Contact? = nil
        @Published var searchText = ""
        @Published var allContacts: [Contact] = []
        @Published var filteredContacts: [Contact] = [Contact(id: 0, name: "Natasha", image: Asset.photo.swiftUIImage),
                                                      Contact(id: 1, name: "Igoresha", image: Asset.photo.swiftUIImage),
                                                      Contact(id: 2, name: "Ctepasha", image: Asset.photo.swiftUIImage),
                                                      Contact(id: 3, name: "Irisha", image: Asset.photo.swiftUIImage),
                                                      Contact(id: 4, name: "Natasha", image: Asset.photo.swiftUIImage),
                                                      Contact(id: 5, name: "Igoresha", image: Asset.photo.swiftUIImage),
                                                      Contact(id: 6, name: "Ctepasha", image: Asset.photo.swiftUIImage),
                                                      Contact(id: 7, name: "Irisha", image: Asset.photo.swiftUIImage),
                                                      Contact(id: 8, name: "Natasha", image: Asset.photo.swiftUIImage),
                                                      Contact(id: 9, name: "Igoresha", image: Asset.photo.swiftUIImage),
                                                      Contact(id: 10, name: "Ctepasha", image: Asset.photo.swiftUIImage),
                                                      Contact(id: 11, name: "Irisha", image: Asset.photo.swiftUIImage)]
        @Published var values: [Contact] = [
            Contact(id: 0, name: "Natasha", image: Asset.photo.swiftUIImage),
            Contact(id: 1, name: "Igoresha", image: Asset.photo.swiftUIImage),
            Contact(id: 2, name: "Ctepasha", image: Asset.photo.swiftUIImage),
            Contact(id: 3, name: "Irisha", image: Asset.photo.swiftUIImage),
            Contact(id: 4, name: "Natasha", image: Asset.photo.swiftUIImage),
            Contact(id: 5, name: "Igoresha", image: Asset.photo.swiftUIImage),
            Contact(id: 6, name: "Ctepasha", image: Asset.photo.swiftUIImage),
            Contact(id: 7, name: "Irisha", image: Asset.photo.swiftUIImage),
            Contact(id: 8, name: "Natasha", image: Asset.photo.swiftUIImage),
            Contact(id: 9, name: "Igoresha", image: Asset.photo.swiftUIImage),
            Contact(id: 10, name: "Ctepasha", image: Asset.photo.swiftUIImage),
            Contact(id: 11, name: "Irisha", image: Asset.photo.swiftUIImage)
        ]
        
        func filterContent() {
            let lowercasedSearchText = searchText.lowercased()

            if searchText.count > 0 {
                var matchingCoffees: [Contact] = []

                values.forEach { contact in
                    let searchContent = contact.name
                    if searchContent.lowercased().range(of: lowercasedSearchText, options: .regularExpression) != nil {
                        matchingCoffees.append(contact)
                    }
                }
                self.filteredContacts = matchingCoffees
            } else {
                filteredContacts = values
            }
        }
    }
}
