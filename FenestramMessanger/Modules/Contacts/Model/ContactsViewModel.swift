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
        
        private(set) var socketManager: SocketIOManager?
        
        init(socketManager: SocketIOManager?) {
            self.socketManager = socketManager
            getContacts()
            getChatList()
        }
        
        
        //MARK: - Query functions
        
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
            
            ChatService.getChats(page: 1) { [weak self] result in
                switch result {
                case .success(let chatList):
                    print("get chat list success")
                    self?.chatList = chatList.data ?? []
                case .failure(let error):
                    print("get chat list failure with error:", error.localizedDescription)
                    self?.textTitleAlert = "get chat list failure with error"
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
        
        func filterHaveChat(contact: UserEntity) -> Bool {
            let userId = Settings.currentUser?.id
            let usetChatId = contact.id
            if chatList.isEmpty {
                return false
            } else {
                for index in chatList.startIndex ... chatList.endIndex - 1 {
                    let ids = chatList[index].usersId
                    if ids.count == 2 {
                        if (ids[0] == userId && ids[1] == usetChatId) || (ids[1] == userId && ids[0] == usetChatId) {
                            return true
                        }
                    }
                }
            }
            return false
        }
        
        func filterChat(contact: UserEntity) -> ChatEntity? {
            var filterChatList: ChatEntity?
            let userId = Settings.currentUser?.id
            let usetChatId = contact.id
            for index in chatList.startIndex ... chatList.endIndex {
                if index < chatList.endIndex {
                    let ids = chatList[index].usersId
                    if ids.count == 2 {
                        if (ids[0] == userId && ids[1] == usetChatId) || (ids[1] == userId && ids[0] == usetChatId) {
                            filterChatList = chatList[index]
                        }
                    }
                }
            }
            return filterChatList
        }
    }
}
