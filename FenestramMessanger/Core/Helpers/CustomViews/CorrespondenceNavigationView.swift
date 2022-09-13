//
//  TitleView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 26.07.2022.
//

import SwiftUI
import Kingfisher

struct CorrespondenceNavigationView: View {
    
    @State var showSheet = false
    
    var contacts: [ContactEntity]
    var chat: ChatEntity?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
   
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    
    var body: some View {
        ZStack {
            Asset.buttonDis.swiftUIColor
                .ignoresSafeArea()
            
            HStack {
                getBackButton()
                
                getTitleView()
                
                Spacer()
                
                getBellButton()
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 60.0)
        
    }
    
    private func getBackButton() -> some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.white)
            }
        }
    }
    
    private func getTitleView() -> some View {
        NavigationLink {
            PageContactView(contacts: contacts, chat: chat).navigationBarHidden(true)
        } label: {
            HStack {
                if let avatarString = (chat?.isGroup ?? false) ? chat?.avatar : contacts.first?.user?.avatar,
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
                
                
                VStack(alignment: .leading) {
                    Text((chat?.isGroup ?? false) ? (chat?.name ?? L10n.General.unknown) : (contacts.first?.name ?? L10n.General.unknown))
                        .foregroundColor(Color.white)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                    
                    Text("В сети")
                        .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                }
            }
        }
    }
    
    private func getBellButton() -> some View {
        HStack {
            Button(action: {
                
            }) {
                HStack {
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 40, height: 40, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Asset.stroke.swiftUIColor, lineWidth: 1.5)
                            )
                            .foregroundColor(Asset.buttonAlert.swiftUIColor)
                        Asset.videoButtonSmall.swiftUIImage
                            .foregroundColor((isColorThema == false) ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor)
                    }
                }
            }
            
            Button(action: {
                
            }) {
                HStack {
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .frame(width: 40, height: 40, alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Asset.stroke.swiftUIColor, lineWidth: 1.5)
                            )
                            .foregroundColor(Asset.buttonAlert.swiftUIColor)
                        Asset.phoneButtonSmall.swiftUIImage
                            .foregroundColor((isColorThema == false) ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor)
                    }
                }
            }
        }
    }
}
