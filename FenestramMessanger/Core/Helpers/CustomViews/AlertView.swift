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
    
    //@AppStorage ("isColorThema") var isColorThema: Bool?
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            //            Asset.tabBar.swiftUIColor.ignoresSafeArea()
            ZStack {
                Asset.photoBack.swiftUIColor
                VStack {
                    Asset.alert.swiftUIImage
                        .resizable()
                        .frame(width: 300, height: 175)
                    //.frame(width: 120, height: 120)
                    VStack(alignment: .leading) {
                        Text("Произошла ошибка")
                            .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 18))
                            .foregroundColor(Color.red)
                        Spacer().frame(height: 10)
                        
                        Text(text)
                            .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                            .foregroundColor(Color.red)
                    }.padding(.leading, -50)
                    Spacer()
                    Button {
                        show.toggle()
                    } label: {
                        
                        Text("Закрыть")
                            .frame(width: 252, height: 35.0)
                            .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 14))
                            .foregroundColor(Asset.text.swiftUIColor)
                            .background(Asset.page.swiftUIColor)
                            .cornerRadius(6)
                    }.onTapGesture {
                        withAnimation {
                            show.toggle()
                        }
                    }
                    
                }
                .padding(.vertical, 25)
//                .padding(.horizontal, 15)
                
                //.frame(maxWidth: 300, maxHeight: 300)
                //.background(Asset.tabBar.swiftUIColor)
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

//struct AlertView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertView(show: true, textTitle: "dfdfdfdf", text: "dsdfsdfsdf")
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
