//
//  MessageStyleView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 26.07.2022.
//

import SwiftUI
import Kingfisher

struct MessageStyleView: View {
    let chat: ChatEntity?
    let contacts: [ContactEntity]
    let message: MessageEntity
    let onClickImage: (URL) -> ()
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    private var isCurrentUser: Bool {
        return Settings.currentUser?.id == message.fromUserId
    }
    
    var body: some View {
        if isCurrentUser {
            VStack(alignment: .trailing) {
                VStack {
                    switch message.messageType {
                    case .text:
                        if #available(iOS 15.0, *) {
                            Text(message.message)
                                .textSelection(.enabled)
                            
                        } else {
                            Text(message.message)
                        }
                    case .image:
                        if let url = URL(string: Constants.baseNetworkURLClear + message.message) {
                            KFImage(url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                                .onTapGesture {
                                    onClickImage(url)
                                }
                        } else {
                            Text(L10n.CorrespondenceView.MessageView.failedGetImage)
                        }
                    }
                }
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                .foregroundColor(.white)
                .padding(10)
                .background(isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor)
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Spacer().frame(height: 5)
                
                HStack {
                    Text(getMessageTime(message.createdAt))
                        .foregroundColor(Asset.message.swiftUIColor)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                    
                    Asset.send.swiftUIImage
                        .resizable()
                        .frame(width: 13.0, height: 13.0)
                        .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                }
            }
        } else if chat?.isGroup ?? false {
            HStack {
                if let avatarString = message.fromUser?.avatar,
                   let url = URL(string: Constants.baseNetworkURLClear + avatarString) {
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .onTapGesture {
                            onClickImage(url)
                        }
                } else {
                    Asset.photo.swiftUIImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                }
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(getUserName(user: message.fromUser))
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                            .foregroundColor(Asset.grey1.swiftUIColor)
                        
                        VStack {
                            switch message.messageType {
                            case .text:
                                if #available(iOS 15.0, *) {
                                    Text(message.message)
                                        .textSelection(.enabled)
                                    
                                } else {
                                    Text(message.message)
                                }
                            case .image:
                                if let url = URL(string: Constants.baseNetworkURLClear + message.message) {
                                    KFImage(url)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            onClickImage(url)
                                        }
                                } else {
                                    Text(L10n.CorrespondenceView.MessageView.failedGetImage)
                                }
                            }
                        }
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                        .foregroundColor(.white)
                    }
                    .padding(10)
                    .background(Asset.tabBar.swiftUIColor)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(height: 5)
                    
                    HStack {
                        Text(getMessageTime(message.createdAt))
                            .foregroundColor(Asset.message.swiftUIColor)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                    }
                }
            }
        } else {
            VStack(alignment: .leading) {
                VStack {
                    switch message.messageType {
                    case .text:
                        if #available(iOS 15.0, *) {
                            Text(message.message)
                                .textSelection(.enabled)
                            
                        } else {
                            Text(message.message)
                        }
                    case .image:
                        if let url = URL(string: Constants.baseNetworkURLClear + message.message) {
                            KFImage(url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                                .onTapGesture {
                                    onClickImage(url)
                                }
                        } else {
                            Text(L10n.CorrespondenceView.MessageView.failedGetImage)
                        }
                    }
                }
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                .foregroundColor(.white)
                .padding(10)
                .background(Asset.tabBar.swiftUIColor)
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 5)
                
                HStack {
                    Text(getMessageTime(message.createdAt))
                        .foregroundColor(Asset.message.swiftUIColor)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                }
            }
        }
    }
    
    private func getUserName(user: UserEntity?) -> String {
        guard let user = user else {
            return L10n.General.unknown
        }

        let contact = contacts.first(where: { $0.user?.id == user.id })
        let name = contact?.name ?? user.name ?? L10n.General.unknown
        
        if Settings.currentUser?.id == user.id {
            return name + L10n.PageContactView.you
        } else {
            return name
        }
    }
    
    private func getMessageTime(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let time = formatter.string(from: date)
        return time
    }
}

