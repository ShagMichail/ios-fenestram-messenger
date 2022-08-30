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
        @Published private(set) var selectedIcon: UIImage?
        @Published var chatName: String = ""
        
        let selectedContacts: [UserEntity]
        
        init(selectedContacts: [UserEntity]) {
            self.selectedContacts = selectedContacts
        }
    }
}
