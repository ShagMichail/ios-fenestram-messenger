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
    
    init(selectedContacts: [UserEntity]) {
        _viewModel = StateObject(wrappedValue: ViewModel(selectedContacts: selectedContacts))
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
            } label: {
                if let selectedIcon = viewModel.selectedIcon {
                    Image(uiImage: selectedIcon)
                } else {
                    Asset.chatPlaceholderIcon.swiftUIImage
                }
            }
            
            Spacer()
                .frame(width: 16)
            
            VStack {
                TextField("", text: $viewModel.chatName)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                    .padding()
                    .placeholder(when: viewModel.chatName.isEmpty) {
                        Text(L10n.NewChatView.Confirm.namePlaceholder)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                            .foregroundColor(Asset.grey1.swiftUIColor)
                    }
            }
        }
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
        NewChatConfirmView(selectedContacts: [])
    }
}
