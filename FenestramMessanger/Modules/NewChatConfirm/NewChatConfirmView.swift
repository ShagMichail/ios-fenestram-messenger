//
//  NewChatConfirmView.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 30.08.2022.
//

import SwiftUI

struct NewChatConfirmView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel: ViewModel
    
    @Binding var isPopToChatListView: Bool
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    init(selectedContacts: [UserEntity], isPopToChatListView: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ViewModel(selectedContacts: selectedContacts))
        _isPopToChatListView = isPopToChatListView
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
                            viewModel.createChat() {
                                self.isPopToChatListView = false
                            }
                        } label: {
                            Asset.doneButtonIcon.swiftUIImage
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
                        viewModel.showImagePicker = true
                        self.sourceType = .photoLibrary
                    },
                    .default(Text(L10n.ProfileView.SelectPhoto.camera)) {
                        viewModel.showImagePicker = true
                        self.sourceType = .camera
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
                        Asset.photo.swiftUIImage
                            .resizable()
                            .frame(width: 32, height: 32)
                        
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
        NewChatConfirmView(selectedContacts: [], isPopToChatListView: .constant(true))
    }
}
