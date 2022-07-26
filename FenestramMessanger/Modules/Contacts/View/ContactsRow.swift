//
//  ContactsRow.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI

struct ContactsRow: View {
    
    let contact: UserEntity
    var chat: [ChatEntity] = []
    let haveChat: Bool
    
    var body: some View {
        HStack() {
            Asset.photo.swiftUIImage
                .resizable()
                .frame(width: 40.0, height: 40.0)
                .padding(.horizontal)
            
            Text(contact.name ?? L10n.General.unknown)
                .foregroundColor(.white)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 20))
            
            Spacer()
            if haveChat {
                NavigationLink(destination: CorrespondenceView(contact: contact, chat: chat)) {
                    Asset.chat.swiftUIImage
                        .padding(.horizontal)
                }
            }
        }
    }
}
