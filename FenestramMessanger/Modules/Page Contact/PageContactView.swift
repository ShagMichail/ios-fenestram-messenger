//
//  PageContactView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI

struct PageContactView: View {
    
    
    //MARK: - Properties
    
    @State var uiTabarController: UITabBarController?
    
    var contact: [UserEntity]
    var chat: ChatEntity?
    
    @StateObject private var viewModel: ViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    init(contact: [UserEntity], chat: ChatEntity?) {
        _viewModel = StateObject(wrappedValue: ViewModel())
        self.contact = contact
        self.chat = chat
    }
   
    
    //MARK: - Body
    
    var body: some View {
        
        VStack{
            ZStack{
                Asset.tabBar.swiftUIColor.ignoresSafeArea()
                VStack {
                    getNameAndPhoto()
                    
                    Spacer().frame(height: 30.0)
                    
                    getButtonPhoneVideo()
                }
            }
        }.onBackSwipe {
            presentationMode.wrappedValue.dismiss()
        }
        Spacer().frame(height: 0)
        ZStack {
            Asset.buttonAlert.swiftUIColor
            
            getListFiles()
            
        }.onBackSwipe {
            presentationMode.wrappedValue.dismiss()
        }
        
        Spacer().frame(height: 0)
        
        ZStack {
            Asset.buttonAlert.swiftUIColor.ignoresSafeArea()
            
            getPhotoFiles()
            
        }.onBackSwipe {
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
    
    private func getNameAndPhoto() -> some View {
        HStack {
            Asset.photo.swiftUIImage
                .resizable()
                .frame(width: 80.0, height: 80.0)
                .padding(.horizontal)
            VStack(alignment: .leading) {
                Text((contact.count > 2) ? chat?.name ?? "" : contact[0].name ?? " ")
                    .foregroundColor(.white)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
                Text("@\(contact[0].nickname ?? " ")")
                    .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
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
    
    private func getListFiles() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(L10n.ChatView.recentFiles)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Text("\(viewModel.allFiles.count) файлов")
                        .font(.system(size: 12))
                        .foregroundColor(Asset.fileText.swiftUIColor)
                }
                Spacer()
                
                NavigationLink(destination: FileView().navigationBarHidden(true)){
                    Image(systemName: "chevron.down")
                        .frame(width: 10, height: 10)
                        .foregroundColor(Asset.fileText.swiftUIColor)
                }
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
            }
        }
    }
    
    private func getPhotoFiles() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(L10n.ChatView.recentImage)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Text("\(viewModel.allPhoto.count) изображений")
                        .font(.system(size: 12))
                        .foregroundColor(Asset.fileText.swiftUIColor)
                }
                Spacer()
                NavigationLink(destination: ImagesView(images: viewModel.allPhoto).navigationBarHidden(true)){
                    Image(systemName: "chevron.down")
                        .frame(width: 10, height: 10)
                        .foregroundColor(Asset.fileText.swiftUIColor)
                }
            }.padding(.leading, 50.0)
                .padding(.trailing, 50.0)
            
            Spacer().frame(height: 15.0)
            
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
        }.padding(.bottom, 20)
    }
}
