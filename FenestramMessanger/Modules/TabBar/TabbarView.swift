//
//  TabbarView.swift
//  FenestramMessanger
//
//  Created by pluto on 17.10.2022.
//

import SwiftUI

struct TabbarView: View {
    
    @StateObject private var viewModel: ViewModel
    @State private var selection = 1
    
    init(socketManager: SocketIOManager?) {
        _viewModel = StateObject(wrappedValue: ViewModel(socketManager: socketManager))
        UITabBar.appearance().backgroundColor = UIColor(asset: Asset.dark1)
        UITabBar.appearance().unselectedItemTintColor = UIColor(asset: Asset.grey1)
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                ContactsView(socketManager: viewModel.socketManager)
                    .tabItem {
                        Asset.contacts.swiftUIImage
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(L10n.MainTabView.contacts)
                    }
                    .tag(0)
                
                ChatView(socketManager: viewModel.socketManager)
                    .tabItem {
                        Asset.chat.swiftUIImage
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(L10n.MainTabView.chat)
                    }
                    .tag(1)
                
                ProfileView()
                    .tabItem {
                        Asset.profile.swiftUIImage
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(L10n.MainTabView.profile)
                    }
                    .tag(2)
            }
            .accentColor(.white)
        }
    }
    
    @MainActor
    final class ViewModel: ObservableObject {
        
        private(set) var socketManager: SocketIOManager?
        
        init(socketManager: SocketIOManager?) {
            self.socketManager = socketManager
            socketManager?.checkConnect()
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView(socketManager: nil)
    }
}
