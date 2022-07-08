//
//  ContactsView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct ContactsView: View {
    var body: some View {
        ZStack {
            
            Color("thema").ignoresSafeArea()
            Text("Contact").foregroundColor(Color.white)
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
