//
//  ProfileView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            
            Color("thema").ignoresSafeArea()
            Text("Profile").foregroundColor(Color.white)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
