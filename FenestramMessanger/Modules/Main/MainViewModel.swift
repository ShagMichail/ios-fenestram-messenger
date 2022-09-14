//
//  MainViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 04.07.2022.
//

import SwiftUI
import Network

extension MainView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        
        //MARK: - Properties
        
        @Published var isSignIn: Bool
        @Published var isOnline: Bool = false
        
        private let monitor = NWPathMonitor()
        private(set) var socketManager: SocketIOManager?
        
        init() {
            self.isSignIn = AuthController.isSignedIn
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleAuthState), name: .loginStatusChanged, object: nil)
            
            if let token = try? AuthController.getToken(),
               self.isSignIn {
                self.socketManager = SocketIOManager(accessToken: token)
            }
            
            monitor.pathUpdateHandler = { [weak self] path in
                self?.isOnline = path.usesInterfaceType(.cellular) || path.usesInterfaceType(.wifi)
            }
            
            monitor.start(queue: .main)
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
