//
//  AlertView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 21.07.2022.
//

import SwiftUI

struct AlertView: View {
    
    @Binding var show: Bool
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            ZStack {
                Asset.photoBack.swiftUIColor
                VStack {
                    Asset.alert.swiftUIImage
                        .resizable()
                        .frame(width: 300, height: 175)
                    VStack(alignment: .leading) {
                        Text(L10n.General.errorTitle)
                            .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 18))
                            .foregroundColor(Asset.red.swiftUIColor)
                        Spacer().frame(height: 10)
                        
                        Text(text)
                            .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                            .foregroundColor(Asset.red.swiftUIColor)
                    }.padding(.leading, -50)
                    Spacer()
                    Button {
                        show.toggle()
                    } label: {
                        
                        Text(L10n.General.close)
                            .frame(width: 252, height: 35.0)
                            .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 14))
                            .foregroundColor(Asset.text.swiftUIColor)
                            .background(Asset.buttonAlert.swiftUIColor)
                            .cornerRadius(6)
                    }.onTapGesture {
                        withAnimation {
                            show.toggle()
                        }
                    }
                }
                .padding(.vertical, 25)
            }
            .frame(maxWidth: 300, maxHeight: 452)
            .cornerRadius(25)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .background(
            Color.primary.opacity(0.35) )
    }
    
}

struct BlurView : UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        return view
        
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}
