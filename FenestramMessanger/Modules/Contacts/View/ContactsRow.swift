//
//  ContactsRow.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI

struct ContactsRow: View {
    
    let contacts: [UserEntity] = []
    let haveChat: Bool
    var chat: ChatEntity?
    
    var body: some View {
        HStack() {
            Asset.photo.swiftUIImage
                .resizable()
                .frame(width: 40.0, height: 40.0)
                .padding(.horizontal)
            
            Text(contacts[0].name ?? L10n.General.unknown)
                .foregroundColor(.white)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 20))
            
            Spacer()
            if haveChat {
                NavigationLink(destination: CorrespondenceView(contacts: contacts, chat: chat)) {
                    Asset.chat.swiftUIImage
                        .padding(.horizontal)
                }
            }
        }
    }
}
