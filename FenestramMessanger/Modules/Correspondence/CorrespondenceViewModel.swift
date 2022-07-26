//
//  CorrespondenceViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 19.07.2022.
//

import SwiftUI


extension CorrespondenceView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var chatList: [ChatEntity] = []
        @Published var textMessage: String = ""
        @Published var isLoading: Bool = false
        
        @Published var presentAlert = false
        @Published var textTitleAlert = ""
        @Published var textAlert = ""
        init() {
            getChatList()
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
                    self?.textTitleAlert = "get contacts failure with error"
                    self?.textAlert = error.localizedDescription
                    self?.presentAlert = true
                }
                
                self?.isLoading = false
            }
        }
    
    }
}

