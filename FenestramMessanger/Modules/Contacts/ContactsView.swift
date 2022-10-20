//
//  ContactsView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI
import Kingfisher
import BottomSheet

struct ContactsView: View {
    
    
    //MARK: - Properties
    
    var chat: ChatEntity?
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var showTabBar: Bool
    
    @StateObject private var viewModel: ViewModel
    
    @State var correspondence = false
    @State var bottomSheetPosition: BookBottomSheetPosition = .hidden
    @State var selectedContact: ContactEntity?
    
    private let baseUrlString = Settings.isDebug ? Constants.devNetworkUrlClear : Constants.prodNetworkURLClear
    
    init(socketManager: SocketIOManager?, showTabBar: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ViewModel(socketManager: socketManager))
        _showTabBar = showTabBar
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
                Asset.background.swiftUIColor
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    getHeaderView()
                    
                    if viewModel.isLoading {
                        LoadingView()
                    } else {
                        if viewModel.isAccessContactDenied {
                            getAccessDeniedView()
                        } else if viewModel.registerContacts.count != 0 || viewModel.unregisterContacts.count != 0 {
                            getSearchView()
                            
                            Spacer().frame(height: 20.0)
                            
                            getContentView()
                        } else {
                            getEmptyView()
                        }
                    }
                }
                
                if let selectedImage = viewModel.selectedImage {
                    ZStack {
                        Color.black
                            .opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                self.viewModel.selectedImage = nil
                                self.viewModel.selectedImageURL = nil
                            }
                        
                        if let url = viewModel.selectedImageURL {
                            KFImage(url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .cornerRadius(20)
                        } else {
                            selectedImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .cornerRadius(20)
                        }
                    }
                }
                
                if viewModel.presentAlert {
                    AlertView(show: $viewModel.presentAlert, text: viewModel.textAlert)
                }
                
            }.onTapGesture {
                UIApplication.shared.endEditing()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    viewModel.checkAccessToContacts()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    
    //MARK: - Views
    
    private func getHeaderView() -> some View {
        Text(L10n.ContactView.title)
            .font(FontFamily.Poppins.bold.swiftUIFont(size: 18))
            .foregroundColor(Color.white)
            .padding(.horizontal, 24)
            .padding(.top, 16)
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
                .padding(16)
                .foregroundColor(Color.white)
            
                .multilineTextAlignment(.leading)
                .accentColor(Asset.text.swiftUIColor)
                .keyboardType(.default)
                .onChange(of: viewModel.searchText) { text in
                    viewModel.filterContent()
                }
        }
        .background(border)
        .padding(.horizontal, 24.0)
    }
    
    private func getContentView() -> some View {
        ZStack {
            VStack(alignment: .trailing) {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        if viewModel.filteredRegisterContacts.count > 0 || viewModel.filteredUnregisterContacts.count > 0 {
                            ForEach(viewModel.filteredRegisterContacts) { contact in
                                getContactRow(contact: contact, isRegister: true)
                            }
                            
                            Button {
                                viewModel.presentInviteSheet()
                            } label: {
                                ZStack {
                                    Asset.dark2.swiftUIColor
                                    
                                    Text(L10n.ContactView.invateToApp)
                                        .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 14))
                                        .foregroundColor(Asset.blue1.swiftUIColor)
                                }
                                .frame(height: 40)
                                .cornerRadius(5)
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 32)
                            .padding(.bottom, 16)
                            
                            if viewModel.filteredUnregisterContacts.count > 0 {
                                ZStack {
                                    Asset.dark1.swiftUIColor
                                        .ignoresSafeArea()
                                    
                                    Text(L10n.ContactView.unregisterContactsTitle)
                                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                                        .foregroundColor(Asset.grey1.swiftUIColor)
                                }
                                .frame(height: 34)
                                .padding(.bottom, 16)
                                
                                ForEach(viewModel.filteredUnregisterContacts) { contact in
                                    getContactRow(contact: contact, isRegister: false)
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
            .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: [.noDragIndicator, .allowContentDrag, .swipeToDismiss, .tapToDismiss, .absolutePositionValue, .background({ AnyView(Asset.buttonAlert.swiftUIColor) }), .cornerRadius(30)], headerContent: {
                
                getHeaderBottomSheet()
            }) {
                getBodyBottomSheet()
            }
        }
    }
    
    private func getButtonNewContact() -> some View {
        NavigationLink() {
            NewContactView(updateCompletion: {
                viewModel.getContacts()
            })
        } label: {
            ZStack {
                Asset.addButtonIcon.swiftUIImage
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
                    .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                
                Asset.plusIcon.swiftUIImage
                    .padding(.bottom, 17)
                    .padding(.trailing, 10)
            }
        }
    }
    
    private func getContactRow(contact: ContactEntity, isRegister: Bool) -> some View {
        let contentView = HStack {
            Button {
                bottomSheetPosition = .bottom
                selectedContact = contact
            } label: {
                VStack {
                    if let avatarURL = contact.user?.avatar,
                       let url = URL(string: baseUrlString + avatarURL) {
                        KFImage(url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40.0, height: 40.0)
                            .clipShape(Circle())
                    } else {
                        Image(uiImage: viewModel.getUnregisterContactAvatar(contact: contact))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40.0, height: 40.0)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
            }
            
            Text(contact.name.trimmingCharacters(in: .whitespaces).isEmpty ? contact.phone : contact.name)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                .foregroundColor(.white)
                
            
            Spacer()
            
            if !isRegister {
                Button {
                    viewModel.selectedContact = contact
                    viewModel.isShowMFMessageView = true
                } label: {
                    VStack {
                        Text(L10n.ContactView.invateContact)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                            .foregroundColor(Asset.grey1.swiftUIColor)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                    }
                    .background(Asset.dark1.swiftUIColor)
                    .cornerRadius(4)
                }
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $viewModel.isShowMFMessageView) {
            MFMessageComposeView(recipients: [viewModel.selectedContact?.phone ?? ""], isShown: $viewModel.isShowMFMessageView)
        }
        
        if isRegister {
            return AnyView(NavigationLink {
                CorrespondenceView(contacts: [contact], chat: nil, socketManager: viewModel.socketManager, showTabBar: $showTabBar).navigationBarHidden(true)
            } label: {
                contentView
            })
        } else {
            return AnyView(contentView)
        }
    }
    
    private func getAccessDeniedView() -> some View {
        VStack(alignment: .center) {
            Spacer()
            Asset.accessDeniedBanner.swiftUIImage
                .resizable()
                .frame(width: 300, height: 300)
            
            Text(L10n.ContactView.accessDeniedText)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                .foregroundColor(Asset.accessDeniedTextColor.swiftUIColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Button {
                viewModel.openSettings()
            } label: {
                Text(L10n.General.accept)
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                    .background((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                    .cornerRadius(6)
            }
            .padding(.bottom, 50)
        }
    }
    
    private func getEmptyView() -> some View {
        VStack(alignment: .center) {
            Spacer()
            Asset.newContact.swiftUIImage
                .resizable()
                .frame(width: 300, height: 300)
            
            Text(L10n.ContactView.emptyText)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                .foregroundColor(Asset.photoBack.swiftUIColor)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            NavigationLink() {
                NewContactView(updateCompletion: {
                    viewModel.getContacts()
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
    
    private func getHeaderBottomSheet() -> some View {
        VStack {
            HStack {
                VStack {
                    if let avatarString = selectedContact?.user?.avatar,
                       let url = URL(string: baseUrlString + avatarString),
                       !avatarString.isEmpty {
                        KFImage(url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80.0, height: 80.0)
                            .clipShape(Circle())
                            .onTapGesture {
                                viewModel.selectedImageURL = url
                                viewModel.selectedImage = Asset.photo.swiftUIImage
                            }
                    } else if let contact = selectedContact {
                        Image(uiImage: viewModel.getUnregisterContactAvatar(contact: contact))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80.0, height: 80.0)
                            .clipShape(Circle())
                            .onTapGesture {
                                viewModel.selectedImage = Image(uiImage: viewModel.getUnregisterContactAvatar(contact: contact))
                            }
                    } else {
                        Asset.photo.swiftUIImage
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                            .onTapGesture {
                                viewModel.selectedImage = Asset.photo.swiftUIImage
                            }
                    }
                }
                .padding(.horizontal)
                
                Text(selectedContact?.name ?? L10n.General.unknown)
                    .foregroundColor(.white)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
                
                Spacer()
            }
            Spacer().frame(height: 30.0)
            HStack {
                Button {
                } label: {
                    buttonsViewProperty(image: Asset.videoButton)
                }
                
                Spacer().frame(width: 54.0)
                
                Button {
                } label: {
                    buttonsViewProperty(image: Asset.phoneButton)
                }
                Spacer().frame(width: 54.0)
                
                NavigationLink(isActive: $correspondence) {
                    CorrespondenceView(contacts: selectedContact != nil ? [selectedContact!] : [], chat: nil, socketManager: viewModel.socketManager, showTabBar: $showTabBar)
                } label:{
                    Button {
                        bottomSheetPosition = .hidden
                        self.correspondence.toggle()
                    } label: {
                        buttonsViewProperty(image: Asset.messageButton)
                    }
                    
                }
                
            }
        }
    }
    
    private func getBodyBottomSheet() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(L10n.ChatView.recentFiles)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Text(L10n.ContactView.files(viewModel.allFiles.count))
                        .font(.system(size: 12))
                        .foregroundColor(Asset.fileText.swiftUIColor)
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .frame(width: 10, height: 10)
                    .foregroundColor(Asset.fileText.swiftUIColor)
            }.padding(.leading, 50.0)
                .padding(.trailing, 50.0)
            
            Spacer().frame(height: 25.0)
            
            ForEach(viewModel.recentFile) { files in
                Button(action: {
                    
                }, label: {
                    HStack {
                        Asset.file.swiftUIImage
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                            .padding(.horizontal)
                        Text(files.title)
                            .font(.system(size: 14))
                            .foregroundColor(Asset.fileText.swiftUIColor)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 2))
                                .foregroundColor(Asset.fileText.swiftUIColor)
                            Spacer()
                                .frame(width: 3.0)
                            Image(systemName: "circle.fill")
                                .font(.system(size: 2))
                                .foregroundColor(Asset.fileText.swiftUIColor)
                            Spacer()
                                .frame(width: 3.0)
                            Image(systemName: "circle.fill")
                                .font(.system(size: 2))
                                .foregroundColor(Asset.fileText.swiftUIColor)
                        }
                    }
                }).padding(.leading, 35.0)
                    .padding(.trailing, 50.0)
                Spacer().frame(height: 20)
            }
        }
    }
    
    private func buttonsViewProperty(image: ImageAsset) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 60, height: 60, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Asset.stroke.swiftUIColor, lineWidth: 1.5)
                )
                .foregroundColor(Asset.buttonAlert.swiftUIColor)
            image.swiftUIImage
                .foregroundColor((isColorThema == false) ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor)
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(socketManager: nil, showTabBar: .constant(true))
    }
}


extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
