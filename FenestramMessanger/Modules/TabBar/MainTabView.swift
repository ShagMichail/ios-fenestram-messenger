//
//  TabView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct MainTabView: View {
    @State var selectionTabView = 0
    
    init() {
        UITabBar.appearance().backgroundColor = Asset.tabBar.color
        UITabBar.appearance().unselectedItemTintColor = Asset.photoBack.color
    }
    
    var body: some View {
        TabView(selection: $selectionTabView) {
            ContactsView()
                .navigationBarHidden(true)
                .tabItem {
                    if selectionTabView == 0 {
                        Asset.contactsSelected.swiftUIImage
                            .frame(width: 20, height: 20)
                    } else {
                        Asset.contacts.swiftUIImage
                            .frame(width: 20, height: 20)
                    }
                    Text(L10n.MainTabView.contacts)
                }
                .tag(0)
            
            ChatView()
                .navigationBarHidden(true)
                .tabItem {
                    if selectionTabView == 1 {
                        Asset.chatSelected.swiftUIImage
                            .frame(width: 20, height: 20)
                    } else {
                        Asset.chat.swiftUIImage
                            .frame(width: 20, height: 20)
                    }
                    Text(L10n.MainTabView.chat)
                }
                .tag(1)
            
            ProfileView()
                .navigationBarHidden(true)
                .tabItem {
                    if selectionTabView == 2 {
                        Asset.profileSelected.swiftUIImage
                            .frame(width: 20, height: 20)
                    } else {
                        Asset.profile.swiftUIImage
                            .frame(width: 20, height: 20)
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
        MainTabView()
    }
}
