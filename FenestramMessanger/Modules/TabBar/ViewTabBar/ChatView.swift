//
//  ChatView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 09.07.2022.
//

import SwiftUI

struct ChatView: View {
    
    var body: some View {
        ZStack {
            
            Color("thema").ignoresSafeArea()
            Text("chat").foregroundColor(Color.white)
        }.navigationBarHidden(true)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

