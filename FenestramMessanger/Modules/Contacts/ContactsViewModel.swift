//
//  ContactsModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI
import Network
import ContactsUI

extension ContactsView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        
        //MARK: - Properties
        
        @Published var searchText = ""
        @Published var registerContacts: [ContactEntity] = [] {
            didSet {
                filterContent()
            }
        }
        @Published var unregisterContacts: [ContactEntity] = [] {
            didSet {
                filterContent()
            }
        }
        @Published var filteredRegisterContacts: [ContactEntity] = []
        @Published var filteredUnregisterContacts: [ContactEntity] = []
        @Published var isLoading: Bool = false
        @Published var presentAlert = false
        @Published var textAlert = ""
        
        @Published var allFiles: [File] = [
            File(title: "FFFFF", data: "22.02.22", volume: "10 MB"),
            File(title: "fffff", data: "22.02.22", volume: "10 MB"),
            File(title: "aaaaa", data: "22.02.22", volume: "10 MB"),
            File(title: "ggggg", data: "22.02.22", volume: "10 MB"),
            File(title: "kkkkk", data: "22.02.22", volume: "10 MB"),
            File(title: "qqqqq", data: "22.02.22", volume: "10 MB")
        ]
        @Published var recentFile: [File] = []
        
        @Published var isShowMFMessageView: Bool = false
        var selectedContact: ContactEntity?
        
        @Published var selectedImage: Image?
        var selectedImageURL: URL?
        
        @Published var isAccessContactDenied: Bool = false
        
        private(set) var socketManager: SocketIOManager?
        
        private let phoneBookContacts: [PhoneBookEntity]
                                        
        init(socketManager: SocketIOManager?) {
            self.socketManager = socketManager
            socketManager?.checkConnect()
            self.phoneBookContacts = PhoneBookEntity.generateModelArray()
            
            postContacts { [weak self] in
                self?.getContacts()
            }
            
            chechAccessToContacts()
            
            fillterFile()
        }
        
        
        //MARK: - Query functions
        
        func openSettings() {
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            
            UIApplication.shared.open(settingsURL)
        }
        
        func chechAccessToContacts() {
            let contactStore = CNContactStore()
            
            contactStore.requestAccess(for: .contacts) { [weak self] isAccess, error in
                if let error = error {
                    print("access to contact failure with error: ", error)
                    self?.isAccessContactDenied = true
                    return
                }
                
                self?.isAccessContactDenied = !isAccess
            }
        }
        
        func getContacts() {
            isLoading = true
            
            ContactsService.getContacts { [weak self] result in
                switch result {
                case .success(let contacts):
                    print("get contacts success")
                    guard let currentUserId = Settings.currentUser?.id else {
                        print("get current user failure")
                        return
                    }
                    
                    var registerUsers: [ContactEntity] = []
                    var unregisterContacts: [ContactEntity] = []
                    
                    contacts.forEach { contact in
                        if let user = contact.user {
                            guard user.id != currentUserId else {
                                return
                            }
                            
                            registerUsers.append(contact)
                        } else {
                            unregisterContacts.append(contact)
                        }
                    }
                    
                    self?.registerContacts = registerUsers
                    self?.unregisterContacts = unregisterContacts
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
                var matchingRegisterContacts: [ContactEntity] = []
                var matchingUnregisterContacts: [ContactEntity] = []
                
                registerContacts.forEach { contact in
                    if contact.name.lowercased().range(of: lowercasedSearchText, options: .regularExpression) != nil || contact.phone.lowercased().range(of: lowercasedSearchText, options: .regularExpression) != nil {
                        matchingRegisterContacts.append(contact)
                    }
                }
                
                unregisterContacts.forEach { contact in
                    if contact.name.lowercased().range(of: lowercasedSearchText, options: .regularExpression) != nil || contact.phone.lowercased().range(of: lowercasedSearchText, options: .regularExpression) != nil {
                        matchingUnregisterContacts.append(contact)
                    }
                }
                
                self.filteredRegisterContacts = matchingRegisterContacts
                self.filteredUnregisterContacts = matchingUnregisterContacts
            } else {
                filteredRegisterContacts = registerContacts
                filteredUnregisterContacts = unregisterContacts
            }
        }
        
        func getUnregisterContactAvatar(contact: ContactEntity) -> UIImage {
            guard let phoneBookContact = phoneBookContacts.first(where: { $0.phoneNumbers.contains(contact.phone) }) else { return Asset.photo.image }
            
            return phoneBookContact.image
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
        
        private func fillterFile() {
            let files = allFiles
            var index = 0
            if files.count > 3  {
                for _ in 0...2  {
                    recentFile.append(files[index])
                    index += 1
                }
            }
        }
    }
}
