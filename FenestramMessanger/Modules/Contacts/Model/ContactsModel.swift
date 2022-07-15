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
        @Published var allContacts: [Contact] = [] {
            didSet {
                filterContent()
            }
        }
        @Published var filteredContacts: [Contact] = []
        
        func filterContent() {
            let lowercasedSearchText = searchText.lowercased()

            if searchText.count > 0 {
                var matchingCoffees: [Contact] = []

                allContacts.forEach { contact in
                    let searchContent = contact.name
                    if searchContent.lowercased().range(of: lowercasedSearchText, options: .regularExpression) != nil {
                        matchingCoffees.append(contact)
                    }
                }
                self.filteredContacts = matchingCoffees
            } else {
                filteredContacts = allContacts
            }
        }
    }
}
