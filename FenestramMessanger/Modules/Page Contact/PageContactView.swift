//
//  PageContactView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI
import Kingfisher

struct PageContactView: View {
    
    
    //MARK: - Properties
    
    @State var uiTabarController: UITabBarController?
    
    var contacts: [UserEntity]
    var chat: ChatEntity?
    
    @StateObject private var viewModel: ViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    init(contacts: [UserEntity], chat: ChatEntity?) {
        _viewModel = StateObject(wrappedValue: ViewModel())
        self.contacts = contacts
        self.chat = chat
    }
   
    
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
                    
                    if chat?.isGroup ?? false {
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
        }
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
            if let avatarString = (chat?.isGroup ?? false) ? chat?.avatar : contacts.first?.avatar,
               let url = URL(string: Constants.baseNetworkURLClear + avatarString),
               !avatarString.isEmpty {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80.0, height: 80.0)
                    .clipShape(Circle())
            } else {
                Asset.photo.swiftUIImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80.0, height: 80.0)
                    .clipShape(Circle())
            }
        }
        .padding(.trailing)
    }
    
    private func getNameAndPhoto() -> some View {
        HStack {
            getPhoto()
                
            VStack(alignment: .leading) {
                Text((chat?.isGroup ?? false) ? (chat?.name ?? L10n.General.unknown) : (contacts.first?.name ?? L10n.General.unknown))
                    .foregroundColor(.white)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
                if chat?.isGroup ?? false {
                    Text("\(L10n.PageContactView.chat) - \(contacts.count + 1) \(L10n.PageContactView.participants)")
                        .font(FontFamily.Poppins.medium.swiftUIFont(size: 14))
                        .foregroundColor(Asset.grey2.swiftUIColor)
                } else {
                    Text("@\(contacts.first?.nickname ?? " ")")
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
            
            ForEach(contacts) { contact in
                HStack {
                    VStack {
                        if let avatarString = contact.avatar,
                           let url = URL(string: Constants.baseNetworkURLClear + avatarString),
                           !avatarString.isEmpty {
                            KFImage(url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                        } else {
                            Asset.photo.swiftUIImage
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                    }
                    .padding(.trailing, 8)
 
                    Text(contact.name ?? L10n.General.unknown)
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
                    NavigationLink(destination: ImagesView(images: viewModel.allPhoto).navigationBarHidden(true)){
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
            
            HStack {
                ForEach(viewModel.recentPhotoFirst) { photo in
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Image(uiImage: photo.image)
                                .resizable()
                                .frame(width: 90, height: 90, alignment: .leading)
                                .cornerRadius(15)
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
                            } else {
                                Image(uiImage: photo.image)
                                    .resizable()
                                    .frame(width: 90, height: 90, alignment: .leading)
                                    .cornerRadius(15)
                            }
                        }
                    })
                    Spacer().frame(width: 10)
                }
            }
        }
        .padding(.bottom, 20)
    }
}
