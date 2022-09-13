//
//  TabView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct MainTabView: View {
    
    
    //MARK: - Properties
    
    @State var selectionTabView = 0
    
    @StateObject private var viewModel: ViewModel
    
    init(socketManager: SocketIOManager?) {
        _viewModel = StateObject(wrappedValue: ViewModel(socketManager: socketManager))
        UITabBar.appearance().backgroundColor = Asset.dark1.color
        UITabBar.appearance().unselectedItemTintColor = Asset.grey1.color
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: FontFamily.Poppins.regular.font(size: 14)], for: .normal)
        UITabBar.appearance().heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    //MARK: - Body
    
    var body: some View {
        TabView(selection: $selectionTabView) {
            ContactsView(socketManager: viewModel.socketManager)
                .navigationBarHidden(true)
                .tabItem {
                    if selectionTabView == 0 {
                        Asset.contactsSelected.swiftUIImage
                            .resizable()
                            .frame(width: 24, height: 24)
                    } else {
                        Asset.contacts.swiftUIImage
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    
                    Text(L10n.MainTabView.contacts)
                }
                .tag(0)
            
            ChatView(socketManager: viewModel.socketManager)
                .navigationBarHidden(true)
                .tabItem {
                    if selectionTabView == 1 {
                        Asset.chatSelected.swiftUIImage
                            .resizable()
                            .frame(width: 24, height: 24)
                    } else {
                        Asset.chat.swiftUIImage
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    
                    Text(L10n.MainTabView.chat)
                }
                .tag(1)
            
            ProfileView()
                .navigationBarHidden(true)
                .tabItem {
                    if selectionTabView == 2 {
                        Asset.profileSelected.swiftUIImage
                            .resizable()
                            .frame(width: 24, height: 24)
                    } else {
                        Asset.profile.swiftUIImage
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    
                    Text(L10n.MainTabView.profile)
                }
                .tag(2)
        }
        .accentColor(.white)
        .ignoresSafeArea()
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(socketManager: nil)
    }
}
