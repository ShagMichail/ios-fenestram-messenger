//
//  ContactsRow.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI

struct ContactsRow: View {
    
    let contact: Contact
    
    var body: some View {
        
        HStack(){
            Image(contact.imageName)
                .resizable()
                .frame(width: 40.0, height: 40.0)
                .padding(.horizontal)
            Text(contact.name)
                .foregroundColor(.white)
                .font(.system(size: 20))
            Spacer()
            
            NavigationLink(destination: CorrespondenceView(contact: contact)) {
                Image("chat")
                    .padding(.horizontal)
            }
            
        }
    }
}
