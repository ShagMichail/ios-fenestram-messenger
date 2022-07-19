//
//  ChatViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 13.07.2022.
//

import SwiftUI

extension ChatView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var chatList: [ChatEntity] = []
        @Published var allContacts: [UserEntity] = []
        
        @Published var isLoading: Bool = false
        @Published var allFiles: [File] = [
            File(title: "fffff"),
            File(title: "aaaaa"),
            File(title: "ggggg"),
            File(title: "kkkkk"),
            File(title: "qqqqq")
        ]
        @Published var recentFile: [File] = []
        
        init() {
            getContacts()
            getChatList()
            fillterFile()
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
                }
                
                self?.isLoading = false
            }
        }
        
        private func getContacts() {
            guard let currentUserId = Settings.currentUser?.id else {
                print("current user doesn't exist")
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
                }
                
                self?.isLoading = false
            }
        }
        
        private func fillterFile() {
            let files = allFiles
            var index = files.endIndex - 3
            if files.count > 3  {
                for _ in 0...2  {
                    recentFile.append(files[index])
                    index += 1
                }
                
            }
            
        }
    }
}
