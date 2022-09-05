//
//  NewChatView.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 30.08.2022.
//

import SwiftUI

struct NewChatView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel: ViewModel
    
    @Binding var isPopToChatListView: Bool
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    init(isPopToChatListView: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ViewModel())
        _isPopToChatListView = isPopToChatListView
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
                            NewChatConfirmView(selectedContacts: viewModel.getSelectedContacts(), isPopToChatListView: $isPopToChatListView)
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
                                Asset.photo.swiftUIImage
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                
                                Text(contact.name ?? L10n.General.unknown)
                                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if viewModel.isSelectedContact(contact) {
                                    Asset.blueTick.swiftUIImage
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
        NewChatView(isPopToChatListView: .constant(true))
    }
}
