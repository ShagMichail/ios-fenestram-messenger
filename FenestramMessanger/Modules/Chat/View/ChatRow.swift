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
                Text(chat.name ?? L10n.General.unknown)
                    .foregroundColor(.white)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                Text(L10n.General.unknown)
                    .foregroundColor(Asset.message.swiftUIColor)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
            }
            
            Spacer()
            
            VStack {
                Text(chat.createdAt?.ISO8601Format() ?? "00:00")
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
}

//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRow()
//    }
//}
