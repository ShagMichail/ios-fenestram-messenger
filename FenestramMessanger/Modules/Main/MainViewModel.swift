//
//  MainViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 04.07.2022.
//

import SwiftUI

extension MainView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        
        //MARK: - Properties
        
        @Published var isSignIn: Bool
        
        private(set) var socketManager: SocketIOManager?
        
        init() {
            self.isSignIn = AuthController.isSignedIn
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleAuthState), name: .loginStatusChanged, object: nil)
            
            if let token = try? AuthController.getToken(),
               self.isSignIn {
                self.socketManager = SocketIOManager(accessToken: token)
            }
        }
        
        
        //MARK: - Query functions
        
        @objc
        private func handleAuthState() {
            self.isSignIn = AuthController.isSignedIn
            
            if let token = try? AuthController.getToken(),
               self.isSignIn {
                self.socketManager = SocketIOManager(accessToken: token)
            }
        }
    }
}
