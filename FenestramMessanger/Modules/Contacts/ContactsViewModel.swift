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
        
        
        //MARK: - Properties
        
        @Published var searchText = ""
        @Published var allContacts: [UserEntity] = [] {
            didSet {
                filterContent()
            }
        }
        @Published var filteredContacts: [UserEntity] = []
        @Published var isLoading: Bool = false
        @Published var presentAlert = false
        @Published var textAlert = ""
        
        private(set) var socketManager: SocketIOManager?
        
        init(socketManager: SocketIOManager?) {
            self.socketManager = socketManager
            getContacts()
        }
        
        
        //MARK: - Query functions
        
        private func getContacts() {
            guard let currentUserId = Settings.currentUser?.id else {
                print("current user doesn't exist")
                self.textAlert = L10n.Error.userDoesNotExist
                self.presentAlert = true
                return
            }
            
            isLoading = true
            
            ContactsService.getContacts { [weak self] result in
                switch result {
                case .success(let contacts):
                    print("get contacts success")
                    self?.allContacts = contacts.compactMap({$0.user}).filter({ $0.id != currentUserId })
                case .failure(let error):
                    print("get contacts failure with error: ", error.localizedDescription)
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
                
                self?.isLoading = false
            }
        }
        
        //MARK: - Auxiliary functions
        
        func filterContent() {
            let lowercasedSearchText = searchText.lowercased()
            
            if searchText.count > 0 {
                var matchingCoffees: [UserEntity] = []
                
                allContacts.forEach { contact in
                    guard let searchContent = contact.name else { return }
                    
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
