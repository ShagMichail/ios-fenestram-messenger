//
//  ChatView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        ZStack {
            
            Color("thema").ignoresSafeArea()
            Text("Chat").foregroundColor(Color.white)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
