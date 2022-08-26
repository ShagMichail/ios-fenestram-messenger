//
//  MessageStyleView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 26.07.2022.
//

import SwiftUI

struct MessageStyleView: View {
    
    var isCurrentUser: Bool
    var message: MessageEntity
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    var body: some View {
        VStack(alignment: isCurrentUser ? .trailing : .leading) {
            Text(message.message)
                .padding(10)
                .foregroundColor(Color.white)
                .background(isCurrentUser ? Asset.blue.swiftUIColor : Asset.tabBar.swiftUIColor)
                .cornerRadius(10)
            .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
            Spacer().frame(height: 5)
            HStack {
                Text(getMessageTime(message.createdAt))
                    .foregroundColor(Asset.message.swiftUIColor)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                if isCurrentUser {
                    Asset.send.swiftUIImage
                        .resizable()
                        .frame(width: 13.0, height: 13.0)
                        .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
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

//struct MessageStyleView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageStyleView(isCurrentUser: <#T##Bool#>, message: <#T##MessageEntity#>)
//    }
//}

