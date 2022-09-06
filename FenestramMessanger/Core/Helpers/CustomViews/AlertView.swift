//
//  AlertView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 21.07.2022.
//

import SwiftUI

struct AlertView: View {
    
    @Binding var show: Bool
    let text: String
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            VStack {
                VStack {
                    Asset.alert.swiftUIImage
                        .resizable()
                        .frame(width: 300, height: 175)
                    
                    VStack(alignment: .center) {
                        Text(L10n.General.errorTitle)
                            .font(FontFamily.Poppins.bold.swiftUIFont(size: 18))
                            .foregroundColor(Asset.red.swiftUIColor)
                        Spacer().frame(height: 10)
                        
                        Text(text)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                            .foregroundColor(Asset.red.swiftUIColor)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 32)
                    
                    Button {
                        show.toggle()
                    } label: {
                        VStack {
                            Text(L10n.General.close)
                                .frame(width: 252, height: 35.0)
                                .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 14))
                                .foregroundColor(Asset.text.swiftUIColor)
                        }
                        .frame(height: 48)
                        .background(Asset.buttonAlert.swiftUIColor)
                        .cornerRadius(6)
                    }
                    .onTapGesture {
                        withAnimation {
                            show.toggle()
                        }
                    }
                }
                .padding(.vertical, 25)
                
                .padding(.horizontal, 24)
            }
            .background(Asset.photoBack.swiftUIColor)
            .cornerRadius(25)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.35) )
    }
    
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(show: .constant(true), text: L10n.Error.tokenEmpty)
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
