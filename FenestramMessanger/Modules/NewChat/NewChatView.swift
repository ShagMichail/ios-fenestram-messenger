//
//  NewChatView.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 30.08.2022.
//

import SwiftUI
import Kingfisher

struct NewChatView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel: ViewModel
    
    @Binding var isPopToChatListView: Bool
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @Binding var showTabBar: Bool
    
    let onNeedUpdateChatList: () -> ()
    
    init(isPopToChatListView: Binding<Bool>, showTabBar: Binding<Bool>, onNeedUpdateChatList: @escaping () -> ()) {
        _viewModel = StateObject(wrappedValue: ViewModel())
        _isPopToChatListView = isPopToChatListView
        _showTabBar = showTabBar
        self.onNeedUpdateChatList = onNeedUpdateChatList
    }
    
    var body: some View {
        ZStack {
            Asset.background.swiftUIColor
                .ignoresSafeArea()
            
            VStack {
                getNavigationBarView()
                
                HStack {
                    Text(L10n.NewChatView.selectContacts)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                        .foregroundColor(Asset.grey1.swiftUIColor)
                    
                    Spacer()
                }
                .padding()
                
                if viewModel.isLoading {
                    LoadingView()
                } else {
                    getContactsList()
                }
            }
            
            if viewModel.isNextButtonVisible {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink {
                            NewChatConfirmView(selectedContacts: viewModel.getSelectedContacts(), showTabBar: $showTabBar, isPopToChatListView: $isPopToChatListView, onNeedUpdateChatList: onNeedUpdateChatList)
                        } label: {
                            if isColorThema == false {
                                Asset.nextButtonBlueIcon.swiftUIImage
                            } else {
                                Asset.nextButtonGreenIcon.swiftUIImage
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            showTabBar = false
        }
        .onBackSwipe {
            showTabBar = true
            presentationMode.wrappedValue.dismiss()
        }
        .navigationBarHidden(true)
    }
    
    private func getNavigationBarView() -> some View {
        ZStack {
            Asset.dark1.swiftUIColor
            
            HStack {
                Button {
                    showTabBar = true
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.white)
                    }
                }
                
                Spacer()
                    .frame(width: 16)
                
                Text(L10n.NewChatView.title)
                    .font(FontFamily.Montserrat.bold.swiftUIFont(size: 18))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
        }
        .frame(height: 52)
    }
    
    private func getContactsList() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.allContacts) { contact in
                    Button {
                        viewModel.selectContact(contact)
                    } label: {
                        ZStack {
                            if viewModel.isSelectedContact(contact) {
                                Asset.dark1.swiftUIColor
                            }
                            
                            HStack {
                                let baseUrlString = Settings.isDebug ? Constants.devNetworkUrlClear : Constants.prodNetworkURLClear
                                if let avatarString = contact.avatar,
                                   let url = URL(string: baseUrlString + avatarString) {
                                    KFImage(url)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                } else {
                                    Asset.photo.swiftUIImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                }
                                
                                Text(contact.name ?? L10n.General.unknown)
                                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if viewModel.isSelectedContact(contact) {
                                    if isColorThema == false {
                                        Asset.blueTick.swiftUIImage
                                    } else {
                                        Asset.greenTick.swiftUIImage
                                    }
                                    
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView(isPopToChatListView: .constant(true), showTabBar: .constant(false), onNeedUpdateChatList: {})
    }
}
