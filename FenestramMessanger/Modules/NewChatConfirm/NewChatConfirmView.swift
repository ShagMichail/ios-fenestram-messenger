//
//  NewChatConfirmView.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 30.08.2022.
//

import SwiftUI
import Combine
import Kingfisher

struct NewChatConfirmView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel: ViewModel
    
    @Binding var isPopToChatListView: Bool
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    let onNeedUpdateChatList: () -> ()
    
    init(selectedContacts: [UserEntity], isPopToChatListView: Binding<Bool>, onNeedUpdateChatList: @escaping () -> ()) {
        _viewModel = StateObject(wrappedValue: ViewModel(selectedContacts: selectedContacts))
        _isPopToChatListView = isPopToChatListView
        self.onNeedUpdateChatList = onNeedUpdateChatList
    }
    
    var body: some View {
        ZStack {
            Asset.background.swiftUIColor
                .ignoresSafeArea()
            
            VStack {
                getNavigationBarView()
                
                getChatIconAndNameView()
                
                getContactsHeaderView()
                
                getContactsList()
            }
            
            if !viewModel.chatName.isEmpty {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            viewModel.createChat(success: {
                                onNeedUpdateChatList()
                                self.isPopToChatListView = false
                            })
                        } label: {
                            if isColorThema == false {
                                Asset.doneButtonBlueIcon.swiftUIImage
                            } else {
                                Asset.doneButtonGreenIcon.swiftUIImage
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onBackSwipe { presentationMode.wrappedValue.dismiss() }
        .navigationBarHidden(true)
    }
    
    private func getNavigationBarView() -> some View {
        ZStack {
            Asset.dark1.swiftUIColor
            
            HStack {
                Button {
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
    
    private func getChatIconAndNameView() -> some View {
        HStack {
            Button {
                viewModel.showSheet = true
            } label: {
                VStack {
                    if let selectedIcon = viewModel.selectedIcon {
                        Image(uiImage: selectedIcon)
                            .resizable()
                            .clipShape(Circle())
                    } else {
                        Asset.chatPlaceholderIcon.swiftUIImage
                            .resizable()
                    }
                }
                .frame(width: 50, height: 50)
            }
            .actionSheet(isPresented: $viewModel.showSheet) {
                ActionSheet(title: Text(L10n.ProfileView.SelectPhoto.title), message: Text(L10n.ProfileView.SelectPhoto.message), buttons: [
                    .default(Text(L10n.ProfileView.SelectPhoto.photoLibrary)) {
                        self.sourceType = .photoLibrary
                        viewModel.showImagePicker = true
                    },
                    .default(Text(L10n.ProfileView.SelectPhoto.camera)) {
                        self.sourceType = .camera
                        viewModel.showImagePicker = true
                    },
                    .cancel()
                ])
            }
            
            VStack {
                TextField("", text: $viewModel.chatName)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                    .placeholder(when: viewModel.chatName.isEmpty) {
                        Text(L10n.NewChatView.Confirm.namePlaceholder)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                            .foregroundColor(Asset.grey1.swiftUIColor)
                    }
                    .padding()
                    .onReceive(Just(viewModel.chatName)) { _ in
                        viewModel.limitText(20)
                    }
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(image: $viewModel.selectedIcon, isShown: $viewModel.showImagePicker, sourceType: self.sourceType)}
        .padding()
    }
    
    private func getContactsHeaderView() -> some View {
        ZStack {
            Asset.dark1.swiftUIColor
            
            HStack {
                Text(L10n.NewChatView.Confirm.contacts)
                    .font(FontFamily.Poppins.bold.swiftUIFont(size: 14))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 32)
        }
        .frame(height: 34)
    }
    
    private func getContactsList() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.selectedContacts) { contact in
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
                    }
                    .padding()
                }
            }
        }
    }
}

struct NewChatConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatConfirmView(selectedContacts: [], isPopToChatListView: .constant(true), onNeedUpdateChatList: {})
    }
}
