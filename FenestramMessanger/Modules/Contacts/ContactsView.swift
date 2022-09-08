//
//  ContactsView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI
import Kingfisher

struct ContactsView: View {
    
    
    //MARK: - Properties
    
    var chat: ChatEntity?
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @StateObject private var viewModel: ViewModel
    
    init(socketManager: SocketIOManager?) {
        _viewModel = StateObject(wrappedValue: ViewModel(socketManager: socketManager))
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Asset.border.swiftUIColor],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing))
    }
    
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack{
                Asset.thema.swiftUIColor
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    getHeaderView()
                    
                    if viewModel.isLoading {
                        LoadingView()
                    } else {
                        if viewModel.registerUsers.count != 0 {
                            getSearchView()
                            
                            Spacer().frame(height: 20.0)
                            
                            getContentView()
                        } else {
                            getEmptyView()
                        }
                    }
                }
                
                if viewModel.presentAlert {
                    AlertView(show: $viewModel.presentAlert, text: viewModel.textAlert)
                }
                
            }.onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationBarHidden(true)
        }
    }
    
    
    //MARK: - Views
    
    private func getHeaderView() -> some View {
        Text(L10n.ContactView.title)
            .font(FontFamily.Poppins.bold.swiftUIFont(size: 18))
            .foregroundColor(Color.white)
            .padding(.horizontal)
            .padding(.top)
        
    }
    
    private func getSearchView() -> some View {
        VStack(alignment: .leading) {
            TextField("", text: $viewModel.searchText)
                .placeholder(when: viewModel.searchText.isEmpty) {
                    Text(L10n.ContactView.Search.placeholder)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                        .foregroundColor(Asset.text.swiftUIColor)
                }
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 12)
                .padding(.leading, 10)
                .padding(.trailing, 5)
                .foregroundColor(Color.white)
            
                .multilineTextAlignment(.leading)
                .accentColor(Asset.text.swiftUIColor)
                .keyboardType(.default)
                .onChange(of: viewModel.searchText) { text in
                    viewModel.filterContent()
                }
        }
        .background(border)
        .padding(.horizontal, 30.0)
    }
    
    private func getContentView() -> some View {
        ZStack {
            VStack(alignment: .trailing) {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        if viewModel.filteredUsers.count > 0 || viewModel.filteredContacts.count > 0 {
                            ForEach(viewModel.filteredUsers) { user in
                                getUserRow(user: user)
                            }
                            
                            if viewModel.filteredContacts.count > 0 {
                                ZStack {
                                    Asset.dark1.swiftUIColor
                                        .ignoresSafeArea()
                                    
                                    Text(L10n.ContactView.unregisterContactsTitle)
                                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                                        .foregroundColor(Asset.grey1.swiftUIColor)
                                }
                                .frame(height: 34)
                                .padding(.top, 32)
                                .padding(.bottom, 16)
                                
                                ForEach(viewModel.filteredContacts) { contact in
                                    getContactRow(contact: contact)
                                }
                            }
                        } else {
                            HStack {
                                Text(L10n.ContactView.contactDontExist)
                                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 15))
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal)
                            }.frame(width: UIScreen.screenWidth)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 96)
                }
                .padding(.bottom, -85)
                getButtonNewContact()
            }
        }
    }
    
    private func getButtonNewContact() -> some View {
        NavigationLink() {
            NewContactView(updateCompletion: {
                
            })
        } label: {
            ZStack {
                Asset.addButtonIcon.swiftUIImage
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
                    .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                Image(systemName: "plus")
                    .font(.title)
                    .padding(.bottom, 17)
                    .padding(.trailing, 10)
            }
        }
    }
    
    private func getUserRow(user: UserEntity) -> some View {
        NavigationLink() {
            CorrespondenceView(contacts: [user], chat: nil, socketManager: viewModel.socketManager).navigationBarHidden(true)
        } label: {
            HStack {
                VStack {
                    if let avatarString = user.avatar,
                       let url = URL(string: Constants.baseNetworkURLClear + avatarString),
                       !avatarString.isEmpty {
                        KFImage(url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40.0, height: 40.0)
                            .clipShape(Circle())
                    } else {
                        Asset.photo.swiftUIImage
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                    }
                }
                .padding(.horizontal)
                
                Text(user.name ?? L10n.General.unknown)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    private func getContactRow(contact: ContactEntity) -> some View {
        HStack {
            VStack {
                Image(uiImage: viewModel.getUnregisterContactAvatar(contact: contact))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40.0, height: 40.0)
                    .clipShape(Circle())
            }
            .padding(.horizontal)
            
            Text(contact.name)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                .foregroundColor(.white)
                
            
            Spacer()
            
            Button {
                viewModel.selectedContact = contact
                viewModel.isShowMFMessageView = true
            } label: {
                VStack {
                    Text(L10n.ContactView.invateContact)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                        .foregroundColor(Asset.grey1.swiftUIColor)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                }
                .background(Asset.dark1.swiftUIColor)
                .cornerRadius(4)
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $viewModel.isShowMFMessageView) {
            MFMessageComposeView(recipients: [viewModel.selectedContact?.phone ?? ""], isShown: $viewModel.isShowMFMessageView)
        }
    }
    
    private func getEmptyView() -> some View {
        VStack(alignment: .center) {
            Spacer()
            Asset.newContact.swiftUIImage
                .resizable()
                .frame(width: 300, height: 300)
            
            Text(L10n.ContactView.emptyText)
                .foregroundColor(Asset.photoBack.swiftUIColor)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            NavigationLink() {
                NewContactView(updateCompletion: {
                    
                })
            } label: {
                Text(L10n.ContactView.addContact)
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                    .background((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                    .cornerRadius(6)
            }
            .padding(.bottom, 50)
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(socketManager: nil)
    }
}


extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
