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
        @Published var searchText = ""
        @Published var chatList: [ChatEntity] = []
        @Published var allContacts: [UserEntity] = [] {
            didSet {
                filterContent()
            }
        }
        @Published var filteredContacts: [UserEntity] = []
        @Published var isLoading: Bool = false
        @Published var presentAlert = false
        @Published var textTitleAlert = ""
        @Published var textAlert = ""
        
        init() {
            getContacts()
            getChatList()
        }
        
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
        
        private func getContacts() {
            guard let currentUserId = Settings.currentUser?.id else {
                print("current user doesn't exist")
                self.textTitleAlert = " "
                self.textAlert = "current user doesn't exist"
                self.presentAlert = true
                return
            }
            
            isLoading = true
            
            ProfileService.getContacts { [weak self] result in
                switch result {
                case .success(let contacts):
                    print("get contacts success")
                    self?.allContacts = contacts.filter({ $0.id != currentUserId })
                case .failure(let error):
                    print("get contacts failure with error: ", error.localizedDescription)
                    self?.textTitleAlert = "get contacts failure with error"
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
                
                self?.isLoading = false
            }
        }
        
        private func getChatList() {
            isLoading = true
            
            ChatService.getChats { [weak self] result in
                switch result {
                case .success(let chatList):
                    print("get chat list success")
                    self?.chatList = chatList
                case .failure(let error):
                    print("get chat list failure with error:", error.localizedDescription)
                    self?.textTitleAlert = "get chat list failure with error"
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
                
                self?.isLoading = false
            }
        }
    }
}
