//
//  VersionAppView.swift
//  FenestramMessanger
//
//  Created by pluto on 17.10.2022.
//

import SwiftUI

struct VersionAppView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Asset.background.swiftUIColor
                .ignoresSafeArea()
            
            VStack(spacing: 60) {
                getHeaderView()
                getContentView()
                Spacer()
            }

        }
        .navigationBarHidden(true)
    }
    
    private func getHeaderView() -> some View {
        ZStack(alignment: .leading) {
            Asset.dark1.swiftUIColor
                .ignoresSafeArea()
            
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.white)
                    }
                    .padding(.leading, 12)
                }
                .padding(.trailing, 16)
                
                Text(L10n.SettingsView.info)
                    .font(FontFamily.Poppins.bold.swiftUIFont(size: 18))
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal, 24)
        }
        .frame(height: 50)
        .padding(.horizontal, -24)
    }
    
    private func getContentView() -> some View {
        ZStack {
            VStack {
                Asset.hcIcon.swiftUIImage
                    .resizable()
                    .frame(width: 150, height: 150)
                
                Text("hoolichat")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                Text("\(L10n.SettingsView.version) \(Bundle.main.releaseVersionNumber ?? "")")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
            
        }
    }
}

struct VersionAppView_Previews: PreviewProvider {
    static var previews: some View {
        VersionAppView()
    }
}
