//
//  MessageStyleView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 26.07.2022.
//

import SwiftUI
import Kingfisher

struct MessageStyleView: View {
    var isCurrentUser: Bool
    var isGroupChat: Bool
    var message: MessageEntity
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    var body: some View {
        if isCurrentUser {
            VStack(alignment: .trailing) {
                Text(message.message)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    .foregroundColor(.white)
                    .padding(10)
                    .foregroundColor(Color.white)
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
        } else if isGroupChat {
            HStack {
                if let avatarString = message.fromUser?.avatar,
                   let url = URL(string: Constants.baseNetworkURLClear + avatarString) {
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                } else {
                    Asset.photo.swiftUIImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                }
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(message.fromUser?.name ?? L10n.General.unknown)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                            .foregroundColor(Asset.grey1.swiftUIColor)
                        
                        Text(message.message)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .foregroundColor(Color.white)
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
                Text(message.message)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    .foregroundColor(.white)
                    .padding(10)
                    .foregroundColor(Color.white)
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
    
    private func getMessageTime(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let time = formatter.string(from: date)
        return time
    }
}

