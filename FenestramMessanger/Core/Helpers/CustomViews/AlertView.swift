//
//  AlertView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 21.07.2022.
//

import SwiftUI

struct AlertView: View {
    
    @Binding var show: Bool
    @Binding var textTitle: String
    @Binding var text: String
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            //            Asset.tabBar.swiftUIColor.ignoresSafeArea()
            ZStack {
                Asset.tabBar.swiftUIColor
                VStack(spacing: 25) {
                    Asset.onboardingSecond.swiftUIImage
                        .resizable()
                        .frame(width: 120, height: 120)
                    Text(textTitle)
                        .font(.system(size: 15))
                        .foregroundColor(Color.white)
                    Text(text)
                        .font(.system(size: 12))
                        .foregroundColor(Color.white)
                    Button {
                        show.toggle()
                    } label: {
                        
                        Text("Понятненько")
                            .frame(width: UIScreen.screenWidth/2 - 30, height: 35.0)
                            .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                            .foregroundColor(Asset.text.swiftUIColor)
                            .background(isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor)
                            .cornerRadius(16)
                    }.onTapGesture {
                        withAnimation {
                            show.toggle()
                        }
                    }
                    
                }
                .padding(.vertical, 25)
                .padding(.horizontal, 30)
                
                //.frame(maxWidth: 300, maxHeight: 300)
            //.background(Asset.tabBar.swiftUIColor)
            }
            .frame(maxWidth: 300, maxHeight: 300)
            .cornerRadius(25)
        }
        
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .background(
            Color.primary.opacity(0.35) )
    }
    
}
//
//struct AlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertView()
//    }
//}
struct BlurView : UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        return view
        
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}
