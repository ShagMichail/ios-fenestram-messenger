//
//  ChatRow.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 18.07.2022.
//

import SwiftUI

struct ChatRow: View {
    
    let chat: ChatEntity
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    var body: some View {
        HStack() {
            Asset.photo.swiftUIImage
                .resizable()
                .frame(width: 40.0, height: 40.0)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text(chat.name)
                    .foregroundColor(.white)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                Text(lastMessage()) //?? L10n.General.unknown)
                    .foregroundColor(Asset.message.swiftUIColor)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                .lineLimit(1)
            }
            
            Spacer()
            
            VStack {
                Text(lastMessageTime())
                    .foregroundColor(Asset.message.swiftUIColor)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                
                Button(action: {
                    print("ddd")
                }, label: {
                    Image(systemName: "checkmark")
                        .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                })
                .padding(.trailing, 0.0)
                .disabled(true)
                
            }
        }
    }
    
    private func lastMessage() -> String {
        guard let lastIndex = chat.messages?.last else { return "" }
        return lastIndex.message 
    }
    
    private func lastMessageTime() -> String {
        guard let lastIndex = chat.messages?.last else { return "" }
        return  lastIndex.createdAt?.formatted(.dateTime.hour().minute() ) ?? "01:09"
    }
}

