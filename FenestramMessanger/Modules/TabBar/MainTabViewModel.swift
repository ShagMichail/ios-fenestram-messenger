//
//  MainTabViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 29.08.2022.
//

import Foundation

extension MainTabView {
    @MainActor
    final class ViewModel: ObservableObject {
        private(set) var socketManager: SocketIOManager?
        
        init(socketManager: SocketIOManager?) {
            self.socketManager = socketManager
            socketManager?.checkConnect()
        }
    }
}
