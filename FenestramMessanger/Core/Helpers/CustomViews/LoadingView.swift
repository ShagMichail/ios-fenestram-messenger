//
//  LoadingView.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 15.07.2022.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            
            ProgressView()
            
            Spacer()
                .frame(height: 16)
            
            Text(L10n.General.loading)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                .foregroundColor(Asset.text.swiftUIColor)
            
            Spacer()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
