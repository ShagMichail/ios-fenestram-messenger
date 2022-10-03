//
//  SwiftUIView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI

extension SettingsView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        
        //MARK: - Properties
        
        
        @Published var showDeleteAccountAlert: Bool = false
        
        //MARK: - Query functions
        
        public func deleteAccount() {
            guard let userId = Settings.currentUser?.id else {
                print("get user id failure")
                return
            }
            
            showDeleteAccountAlert = false
            
            AuthService.deleteUser(userId: userId) { [weak self] result in
                switch result {
                case .success:
                    self?.out()
                case .failure(let error):
                    print("delete account failure with error: ", error)
                }
            }
        }
        
        public func out() {
            do {
                try AuthController.signOut()
                print("out success")
            }
            catch let error {
                print("out failure with error: ", error.localizedDescription)
            }
        }
    }
}
