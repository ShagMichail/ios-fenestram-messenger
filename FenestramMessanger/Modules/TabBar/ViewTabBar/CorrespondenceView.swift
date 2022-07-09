//
//  ChatView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct CorrespondenceView: View {
    
    @State var person: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.white)
            Text("\(person)")
                .foregroundColor(Color.white)
                .font(.system(size: 20))
        }
      }
    }
    
    var body: some View {
        ZStack {
            
            Color("thema").ignoresSafeArea()
            
            Text("Переписка!").foregroundColor(Color.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
