//
//  NewChatConfirmViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 30.08.2022.
//

import Foundation
import UIKit

extension NewChatConfirmView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var selectedIcon: UIImage?
        @Published var chatName: String = ""
        
        @Published var showSheet: Bool = false
        @Published var showImagePicker: Bool = false
        
        let selectedContacts: [UserEntity]
        
        init(selectedContacts: [UserEntity]) {
            self.selectedContacts = selectedContacts
        }
        
        func createChat(success: @escaping () -> ()) {
            ChatService.createChat(chatName: chatName, usersId: selectedContacts.map({ $0.id }), isGroup: true) { result in
                switch result {
                case .success:
                    print("create chat success")
                    success()
                case .failure(let error):
                    print("create chat failure with error: ", error.localizedDescription)
                }
            }
        }
        
        func limitText(_ upper: Int) {
            if chatName.count > upper {
                chatName = String(chatName.prefix(upper))
            }
        }
    }
}
