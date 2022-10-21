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
    private let baseUrlString = Settings.isDebug ? Constants.devNetworkUrlClear : Constants.prodNetworkURLClear
    private var isCurrentUser: Bool {
        return Settings.currentUser?.id == message.fromUserId
    }
    
    var body: some View {
        guard message.messageType != .system else {
            return AnyView(Text(message.message)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                .foregroundColor(Asset.grey1.swiftUIColor))
        }
        
        if isCurrentUser {
            return AnyView(viewMyMessage())
        } else if chat?.isGroup ?? false {
            return AnyView(viewCorrespondMessage())
        } else {
            return AnyView(viewSingleImageOrMessageDate())
        }
    }
    
    
    // MARK: - view
    
    private func viewMyMessage() -> some View {
        VStack(alignment: .trailing) {
            VStack(alignment: .trailing) {
                switch message.messageType {
                case .text:
                    if #available(iOS 15.0, *) {
                        Text(message.message)
                            .textSelection(.disabled)
                    } else {
                        Text(message.message)
                    }
                case .image:
                    if let url = URL(string: baseUrlString + message.message) {
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
                case .system:
                    EmptyView()
                }
                
                if let isEdited = message.isEdited, isEdited {
                    Text(L10n.CorrespondenceView.edited)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 10))
                        .foregroundColor(Asset.grey1.swiftUIColor)
                        .padding(.leading)
                }
                
            }
            .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
            .foregroundColor(.white)
            .padding(10)
            .background(isColorThema == false ? Asset.blue3.swiftUIColor : Asset.green1.swiftUIColor)
            .cornerRadius(10)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer().frame(height: 5)
            
            HStack {
                Text(getMessageTime(message.createdAt))
                    .foregroundColor(Asset.message.swiftUIColor)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                
                checkMessageStatus(message: message)
                    .resizable()
                    .frame(width: 10.0, height: 10.0)
                    .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
            }
        }
    }
    
    private func viewCorrespondMessage() -> some View {
        HStack {
            if let avatarString = message.fromUser?.avatar,
               let url = URL(string: baseUrlString + avatarString) {
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
                            if let url = URL(string: baseUrlString + message.message) {
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
                        case .system:
                            EmptyView()
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
    }
    
    private func viewSingleImageOrMessageDate() -> some View {
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
                    if let url = URL(string: baseUrlString + message.message) {
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
                case .system:
                    EmptyView()
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
    
    // MARK: - some methods
    
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
    
    private func checkMessageStatus(message: MessageEntity) -> Image {
        switch message.messageStatus {
        case .sending:
            return Asset.messageSendingIc.swiftUIImage
        case .send:
            return Asset.messageSendIc.swiftUIImage
        case .error:
            return Asset.messageErrorSend.swiftUIImage
        }
    }
    
}

