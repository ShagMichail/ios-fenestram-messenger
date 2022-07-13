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
        UITabBar.appearance().backgroundColor = UIColor(named: "tabBar")
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "photoBack")
    }
    
    var body: some View {
        TabView(selection: $selectionTabView) {
            ContactsView()
                .navigationBarHidden(true)
                .tabItem {
                if selectionTabView == 0 {
                    Image("contacts_selected").frame(width: 20, height: 20)
                } else {
                    Image("contacts").frame(width: 20, height: 20)
                }
                Text("Контакты")
            }
            .tag(0)
            
            ChatView()
                .navigationBarHidden(true)
                .tabItem {
                    if selectionTabView == 1 {
                        Image("chat_selected").frame(width: 20, height: 20)
                    } else {
                        Image("chat").frame(width: 20, height: 20)
                    }
                    Text("Чат")
                }
                .tag(1)
            
            ProfileView()
                .navigationBarHidden(true)
                .tabItem {
                    if selectionTabView == 2 {
                        Image("profile_selected").frame(width: 20, height: 20)
                    } else {
                        Image("profile").frame(width: 20, height: 20)
                    }
                    Text("Профиль")
                }
                .tag(2)
        }
        .accentColor(.white)
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
