//
//  MainTabViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 29.08.2022.
//

import SwiftUI

extension MainTabView {
    enum TabType: Int, Identifiable, CaseIterable {
        case contacts = 0, chats, profile
        
        var id: Int {
            return rawValue
        }
        
        func getTabItemView(isSelected: Bool) -> some View {
            HStack {
                Spacer()
                
                VStack {
                    switch self {
                    case .contacts:
                        if isSelected {
                            Asset.contactsSelected.swiftUIImage
                                .resizable()
                                .frame(width: 24, height: 24)
                        } else {
                            Asset.contacts.swiftUIImage
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        Text(L10n.MainTabView.contacts)
                    case .chats:
                        if isSelected {
                            Asset.chatSelected.swiftUIImage
                                .resizable()
                                .frame(width: 24, height: 24)
                        } else {
                            Asset.chat.swiftUIImage
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        Text(L10n.MainTabView.chat)
                    case .profile:
                        if isSelected {
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
                }
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                .foregroundColor(isSelected ? Color.white : Asset.grey1.swiftUIColor)
                
                Spacer()
            }
        }
        
        func getContentView(with socketManager: SocketIOManager?, showTabBar: Binding<Bool>) -> some View {
            VStack {
                switch self {
                case .contacts:
                    ContactsView(socketManager: socketManager, showTabBar: showTabBar)
                        .navigationBarHidden(true)
                case .chats:
                    ChatView(socketManager: socketManager, showTabBar: showTabBar)
                        .navigationBarHidden(true)
                case .profile:
                    ProfileView(showTabBar: showTabBar)
                        .navigationBarHidden(true)
                }
            }
        }
    }
    
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var selectedTab: TabType = .contacts
        @Published var showTabBar: Bool = true
        
        private(set) var socketManager: SocketIOManager?
        
        init(socketManager: SocketIOManager?) {
            self.socketManager = socketManager
            socketManager?.checkConnect()
        }
    }
}
