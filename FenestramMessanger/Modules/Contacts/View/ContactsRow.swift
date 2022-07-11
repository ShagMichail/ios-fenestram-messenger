//
//  ContactsRow.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI

struct ContactsRow: View {
    
    @State var name: String
    @State var image: String
    
    var body: some View {
        
        HStack(){
            Image("\(image)")
                .resizable()
                .frame(width: 40.0, height: 40.0)
                .padding(.horizontal)
            Text(name)
                .foregroundColor(.white)
                .font(.system(size: 20))
            Spacer()
            
            NavigationLink(destination: CorrespondenceView(person: name, personImage: "\(image)")) {
                Image("chat")
                    .padding(.horizontal)
            }
            
        }
    }
}

struct ContactsRow_Previews: PreviewProvider {
    static var previews: some View {
        ContactsRow(name: "dfddfddfdf", image: "photo")
    }
}
