//
//  OnboardingCCv.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 12.07.2022.
//

import SwiftUI

struct OnboardingContainerView: View {
    @State private var selectedPage = 0
    @State var offset: CGFloat = 0
    let arrayView : [OnboardingContentView] = [OnboardingContentView(feature: features[0]),OnboardingContentView(feature: features[1]),OnboardingContentView(feature: features[2])]
    let colors: [Color] = [.red, .blue, .green]
    //@AppStorage("isSelectedPage") var isSelectedPage = 0
    var body: some View {
        ZStack{
            Color("thema").ignoresSafeArea()
            TabView {
                ForEach(arrayView.indices, id: \.self) { index in
                    if index == 0 {
                        arrayView[index]
                            .overlay(
                                GeometryReader{ proxy -> Color in
                                    let minX = proxy.frame(in: .global).maxX
                                    print(minX)
                                    DispatchQueue.main.async {
                                        withAnimation(.default) {
                                            if minX != 0 {
                                                self.offset = -minX
                                            }
                                        }
                                    }
                                    
                                    return Color.clear
                                }
                                    .frame(width: 0, height: 0)
                                ,alignment: .leading
                                
                            )
                    }
//                    if index == 1 {
//                        arrayView[index]
//                            .overlay(
//                                GeometryReader{ proxy -> Color in
//                                    let minX = proxy.frame(in: .global).maxX
//                                    print(minX)
//                                    DispatchQueue.main.async {
//                                        withAnimation(.default) {
//                                            if minX != 0 {
//                                            self.offset = -(2 * minX)
//                                            }
//                                        }
//                                    }
//                                    
//                                    return Color.clear
//                                }
//                                    .frame(width: 0, height: 0)
//                                ,alignment: .leading
//                                
//                            )
//                    }
                    else {
                        arrayView[index]
                    }
                    
                    
                }
                //                OnboardingContentView(feature: features[0]).tag(0)
                //                OnboardingContentView(feature: features[1]).tag(1)
                //                OnboardingContentView(feature: features[2]).tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
            .overlay(
                HStack(spacing: 15) {
                    ForEach(arrayView.indices, id: \.self) { index in
                        Capsule()
                            .fill(Color("page"))
                            .frame(width: getIndex() == index ? 38 : 7, height: 7)
                        
                    }
                }
                    //.padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                    .padding(.bottom, UIScreen.screenHeight/7)
                ,alignment: .bottom
            )
        }
    }
    func getIndex() -> Int {
        let index = Int(round(Double(offset / UIScreen.screenWidth)))
        return index
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
    }
}
