//
//  PageContactView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI
import Kingfisher
import BottomSheet

enum ContactBottomSheetPosition: CGFloat, CaseIterable {
    case bottom = 240, hidden = 0
}

struct PageContactView: View {
    
    
    //MARK: - Properties
    
    @State var uiTabarController: UITabBarController?
    @State var bottomSheetPosition: ContactBottomSheetPosition = .hidden
    @State var correspondence = false
    @State var chatUser: ChatEntity?
    @State var selectedUser: UserEntity?
    
    @StateObject private var viewModel: ViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    init(contacts: [ContactEntity], chat: ChatEntity?) {
        _viewModel = StateObject(wrappedValue: ViewModel(contacts: contacts, chat: chat))
    }
   
    fileprivate let baseUrlString = Settings.isDebug ? Constants.devNetworkUrlClear : Constants.prodNetworkURLClear
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Asset.dark1.swiftUIColor
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer()
                        .frame(height: 24)
                    
                    getNameAndPhoto()
                    
                    Spacer().frame(height: 30.0)
                    
                    getButtonPhoneVideo()
                    
                    if viewModel.chat?.isGroup ?? false {
                        Spacer().frame(height: 16.0)
                        
                        getParticipantsList()
                    }
                    
                    Spacer().frame(height: 16.0)
                    
                    getListFiles()
                    
                    Spacer().frame(height: 16.0)
                    
                    getPhotoFiles()
                }
                .padding(.horizontal, 32)
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
        }
        .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: [.noDragIndicator, .allowContentDrag, .swipeToDismiss, .tapToDismiss, .absolutePositionValue, .background({ AnyView(Asset.buttonAlert.swiftUIColor) }), .cornerRadius(30)],
                     headerContent: {
            getHeaderBottomSheet()
        }) { }
        .onBackSwipe {
            presentationMode.wrappedValue.dismiss()
        }
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }.onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
    }
    
    
    //MARK: - Views
    
    private func getPhoto() -> some View {
        VStack {
            if let avatarString = (viewModel.chat?.isGroup ?? false) ? viewModel.chat?.avatar : viewModel.getPersonalChatAvatar(),
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
            } else {
                Asset.photo.swiftUIImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80.0, height: 80.0)
                    .clipShape(Circle())
                    .onTapGesture {
                        viewModel.selectedImage = Asset.photo.swiftUIImage
                    }
            }
        }
        .padding(.trailing)
    }
    
    private func getNameAndPhoto() -> some View {
        HStack {
            getPhoto()
                
            VStack(alignment: .leading) {
                Text((viewModel.chat?.isGroup ?? false) ? (viewModel.chat?.name ?? L10n.General.unknown) : (viewModel.contacts.first?.name ?? viewModel.chat?.name ?? L10n.General.unknown))
                    .foregroundColor(.white)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
                if viewModel.chat?.isGroup ?? false {
                    Text("\(L10n.PageContactView.chat) - \(viewModel.participants.count) \(L10n.PageContactView.participants)")
                        .font(FontFamily.Poppins.medium.swiftUIFont(size: 14))
                        .foregroundColor(Asset.grey2.swiftUIColor)
                } else {
                    Text("@\(viewModel.getContactNick())")
                        .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
                }
            }
            Spacer()
        }
    }
    
    private func getButtonPhoneVideo() -> some View {
        HStack {
            Button {
                print("fff")
            } label: {
                buttonsViewProperty(image: Asset.videoButton)
            }
            
            Spacer().frame(width: 54.0)
            
            Button {
                print("fff")
            } label: {
                buttonsViewProperty(image: Asset.phoneButton)
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
    
    private func getParticipantsList() -> some View {
        VStack {
            ZStack {
                Asset.dark2.swiftUIColor
                
                HStack {
                    Text(L10n.PageContactView.participantsTitle)
                        .font(FontFamily.Poppins.extraBold.swiftUIFont(size: 14))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 32)
            }
            .frame(height: 45)
            .padding(.horizontal, -32)
            
            Spacer().frame(height: 16.0)
            
            ForEach(viewModel.participants) { participant in
                HStack {
                    VStack {
                        if let avatarString = participant.avatar,
                           let url = URL(string: baseUrlString + avatarString),
                           !avatarString.isEmpty {
                            KFImage(url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                                .onTapGesture {
                                    viewModel.getChatWithUser(id: participant.id)
                                    bottomSheetPosition = .bottom
                                    chatUser = viewModel.selectedChat
                                    selectedUser = participant
                                }
                        } else {
                            Asset.photo.swiftUIImage
                                .resizable()
                                .frame(width: 32, height: 32)
                                .onTapGesture {
                                    viewModel.getChatWithUser(id: participant.id)
                                    bottomSheetPosition = .bottom
                                    chatUser = viewModel.selectedChat
                                    selectedUser = participant
                                }
                        }
                    }
                    .padding(.trailing, 8)
                    Text(viewModel.getName(to: participant))
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
            }
        }
    }
    
    private func getListFiles() -> some View {
        VStack {
            ZStack {
                Asset.dark2.swiftUIColor
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(L10n.ChatView.recentFiles)
                            .font(FontFamily.Poppins.extraBold.swiftUIFont(size: 14))
                            .foregroundColor(.white)
                        Text("\(viewModel.allFiles.count) \(L10n.PageContactView.files)")
                            .font(FontFamily.Poppins.medium.swiftUIFont(size: 12))
                            .foregroundColor(Asset.fileText.swiftUIColor)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: FileView().navigationBarHidden(true)){
                        Image(systemName: "chevron.down")
                            .frame(width: 10, height: 10)
                            .foregroundColor(Asset.fileText.swiftUIColor)
                    }
                }
                .padding(.horizontal, 32)
            }
            .frame(height: 60)
            .padding(.horizontal, -32)
            
            Spacer().frame(height: 16.0)
            
            ForEach(viewModel.recentFile) { files in
                Button(action: {
                    
                }, label: {
                    HStack {
                        Asset.file.swiftUIImage
                            .padding(.trailing, 6)
                        
                        Text(files.title)
                            .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 14))
                            .foregroundColor(Asset.grey2.swiftUIColor)
                        
                        Spacer()
                        
                        Asset.dotsHorizontalIcon.swiftUIImage
                    }
                })
            }
        }
    }
    
    private func getPhotoFiles() -> some View {
        VStack {
            ZStack {
                Asset.dark2.swiftUIColor
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(L10n.ChatView.recentImage)
                            .font(FontFamily.Poppins.extraBold.swiftUIFont(size: 14))
                            .foregroundColor(.white)
                        Text("\(viewModel.allPhoto.count) \(L10n.PageContactView.images)")
                            .font(FontFamily.Poppins.medium.swiftUIFont(size: 12))
                            .foregroundColor(Asset.fileText.swiftUIColor)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 32)
            }
            .frame(height: 60)
            .padding(.horizontal, -32)
            
            Spacer().frame(height: 16.0)
            
            HStack {
                ForEach(viewModel.recentPhotoFirst) { photo in
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image(uiImage: photo.image)
                                .resizable()
                                .frame(width: 90, height: 90, alignment: .leading)
                                .cornerRadius(15)
                                .onTapGesture {
                                    viewModel.selectedImage = Image(uiImage: photo.image)
                                }
                        }
                    })
                    Spacer().frame(width: 10)
                }
            }
            HStack {
                ForEach(viewModel.recentPhotoSecond) { photo in
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            if photo.id == 5 && viewModel.allPhoto.count > 6 {
                                NavigationLink(destination: ImagesView(images: viewModel.allPhoto)){
                                    ZStack {
                                        Image(uiImage: photo.image)
                                            .resizable()
                                            .frame(width: 90, height: 90, alignment: .leading)
                                            .cornerRadius(15)
                                        
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: 90, height: 90)
                                                .foregroundColor(Color.primary.opacity(0.35))
                                            Text("\(viewModel.allPhoto.count - 6)+")
                                                .foregroundColor(Color.white)
                                                .font(FontFamily.Poppins.regular.swiftUIFont(size: 24))
                                        }
                                    }
                                }
                            } else {
                                Image(uiImage: photo.image)
                                    .resizable()
                                    .frame(width: 90, height: 90, alignment: .leading)
                                    .cornerRadius(15)
                                    .onTapGesture {
                                        viewModel.selectedImage = Image(uiImage: photo.image)
                                    }
                            }
                        }
                    })
                    Spacer().frame(width: 10)
                }
            }
        }
        .padding(.bottom, 20)
    }
    
    private func getHeaderBottomSheet() -> some View {
        VStack {
            HStack {
                VStack {
                    if let avatarString = selectedUser?.avatar,
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
                
                VStack(alignment: .leading) {
                    Text(viewModel.getName(to: selectedUser))
                        .foregroundColor(.white)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
                    Text(selectedUser?.nickname ?? "@")
                        .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
                }
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
                    // TODO: - доделать переход в личный чат с одним из участников группы
//                    if let selectedUser = selectedUser {
//                        let contact = ContactEntity(id: selectedUser.id, phone: selectedUser.phoneNumber, name: selectedUser.name ?? selectedUser.phoneNumber, user: selectedUser)
//                        let chat = viewModel.getChatWith(contact: contact)
//
//                        CorrespondenceView(contacts: [contact], chat: chat, socketManager: nil, showTabBar: )
//                    }
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
}
