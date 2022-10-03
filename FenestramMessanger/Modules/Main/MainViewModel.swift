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
                DispatchQueue.main.async {
                    self?.isOnline = path.usesInterfaceType(.cellular) || path.usesInterfaceType(.wifi)
                }
            }
            
            let queue = DispatchQueue(label: "Monitor")
            monitor.start(queue: queue)
        }
        
        
        //MARK: - Query functions
        
        @objc
        private func handleAuthState() {
            if let token = try? AuthController.getToken(),
               AuthController.isSignedIn {
                if self.socketManager == nil {
                    self.socketManager = SocketIOManager(accessToken: token)
                } else {
                    self.socketManager?.changeAccessToken(accessToken: token)
                }
            }
            
            self.isSignIn = AuthController.isSignedIn
        }
    }
}
