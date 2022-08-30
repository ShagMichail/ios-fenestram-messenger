//
//  NewChatViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 30.08.2022.
//

import Foundation

extension NewChatView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var allContacts: [UserEntity] = []
        @Published private var selectedContacts: Set<UserEntity> = []
        
        @Published var isLoading: Bool = false
        @Published var presentAlert = false
        @Published var textTitleAlert = ""
        @Published var textAlert = ""
        
        var isNextButtonVisible: Bool {
            !selectedContacts.isEmpty
        }
        
        init() {
            getContacts()
        }
        
        func selectContact(_ contact: UserEntity) {
            if isSelectedContact(contact) {
                selectedContacts.remove(contact)
            } else {
                selectedContacts.insert(contact)
            }
        }
        
        func isSelectedContact(_ contact: UserEntity) -> Bool {
            selectedContacts.contains(contact)
        }
        
        func getSelectedContacts() -> [UserEntity] {
            Array(selectedContacts)
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
    }
}
