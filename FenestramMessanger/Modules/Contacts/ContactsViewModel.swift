//
//  ContactsModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI
import Network

extension ContactsView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        
        //MARK: - Properties
        
        @Published var searchText = ""
        @Published var registerUsers: [UserEntity] = [] {
            didSet {
                filterContent()
            }
        }
        @Published var unregisterContacts: [ContactEntity] = [] {
            didSet {
                filterContent()
            }
        }
        @Published var filteredUsers: [UserEntity] = []
        @Published var filteredContacts: [ContactEntity] = []
        @Published var isLoading: Bool = false
        @Published var presentAlert = false
        @Published var textAlert = ""
        
        @Published var isShowMFMessageView: Bool = false
        var selectedContact: ContactEntity?
        
        private(set) var socketManager: SocketIOManager?
        private let monitor = NWPathMonitor()
        
        private let phoneBookContacts: [PhoneBookEntity]
                                        
        init(socketManager: SocketIOManager?) {
            self.socketManager = socketManager
            socketManager?.checkConnect()
            self.phoneBookContacts = PhoneBookEntity.generateModelArray()
            
            postContacts { [weak self] in
                self?.getContacts()
            }
        }
        
        
        //MARK: - Query functions
        
        private func getContacts() {
            isLoading = true
            
            ContactsService.getContacts { [weak self] result in
                switch result {
                case .success(let contacts):
                    print("get contacts success")
                    var registerUsers: [UserEntity] = []
                    var unregisterContacts: [ContactEntity] = []
                    
                    contacts.forEach { contact in
                        if let user = contact.user {
                            registerUsers.append(user)
                        } else {
                            unregisterContacts.append(contact)
                        }
                    }
                    
                    self?.registerUsers = registerUsers
                    self?.unregisterContacts = unregisterContacts
                case .failure(let error):
                    print("get contacts failure with error: ", error.localizedDescription)
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
                
                self?.isLoading = false
            }
        }
        
        private func postContacts(completion: @escaping () -> ()) {
            ContactsService.postContacts(contacts: phoneBookContacts) { result in
                switch result {
                case .success:
                    print("post contact success")
                case .failure(let error):
                    print("post contact failure witj error: ", error.localizedDescription)
                }
                
                completion()
            }
        }
        
        //MARK: - Auxiliary functions
        
        func filterContent() {
            let lowercasedSearchText = searchText.lowercased()
            
            if searchText.count > 0 {
                var matchingUsers: [UserEntity] = []
                var matchingContacts: [ContactEntity] = []
                
                registerUsers.forEach { user in
                    guard let searchContent = user.name else { return }
                    
                    if searchContent.lowercased().range(of: lowercasedSearchText, options: .regularExpression) != nil {
                        matchingUsers.append(user)
                    }
                }
                
                unregisterContacts.forEach { contact in
                    if contact.name.lowercased().range(of: lowercasedSearchText, options: .regularExpression) != nil {
                        matchingContacts.append(contact)
                    }
                }
                
                self.filteredUsers = matchingUsers
                self.filteredContacts = matchingContacts
            } else {
                filteredUsers = registerUsers
                filteredContacts = unregisterContacts
            }
        }
        
        func getUnregisterContactAvatar(contact: ContactEntity) -> UIImage {
            guard let phoneBookContact = phoneBookContacts.first(where: { $0.phoneNumbers.contains(contact.phone) }) else { return Asset.photo.image }
            
            return phoneBookContact.image
        }
    }
}
