//
//  ChatRow.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 18.07.2022.
//

import SwiftUI

struct ChatRow: View {
    @AppStorage ("isColorThema") var isColorThema: Bool?
    let chat: ChatEntity
    
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
        let messege = chat.messages
        guard let lastIndex = chat.messages?.last else { return "" }
        return lastIndex.message ?? ""
    }
    private func lastMessageTime() -> String {
        let messege = chat.messages
        guard let lastIndex = chat.messages?.last else { return "" }
        return  lastIndex.createdAt?.description ?? "01:09"// String(decoding: (lastIndex.createdAt)!, as: UTF8.self)
    }
}

//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRow()
//    }
//}
