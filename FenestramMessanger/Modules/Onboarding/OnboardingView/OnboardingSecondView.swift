//
//  OnboardingSecondView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct OnboardingSecondView: View {
    
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    let features =
    Feature(title: "next", subtitle: "Задача организации, в особенности же рамки и место обучения кадров способствует подготовки и реализации позиций, занимаемых участниками в отношении поставленных задач.", image: "onboardingSecond")
    //@State var showFavorited: TabType?
    var body: some View {
        ZStack {
            Color("thema").ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(features.image)
                    .resizable()
                    .scaledToFit()
                
                
                
                Spacer()
                
                getTitle()
                
                Spacer()
                
                getButton()
                
                Spacer()
                
            }
        }
        .edgesIgnoringSafeArea(.all)
        
        
    }
    private func getTitle() -> some View {
        VStack(spacing: 20) {
            
            Text(features.subtitle)
                .font(.system(size: 14))
                .foregroundColor(Color("photoBack"))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func getButton() -> some View {
        VStack {
            
            NavigationLink(destination: OnboardingThirdView().navigationBarHidden(true)){
                
                
                Text("Далее")
                
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                
                    .foregroundColor(.white)
                    .background(Color("blue"))
                    .cornerRadius(6)
                
            }
            
            //                        Button(action: {
            //                            NavigationLink(
            //                            OnboardingSecondView()
            //                        }, label: {
            //
            //                            Text("Далее")
            //
            //                                .frame(width: 355.0, height: 45.0)
            //
            //                                .foregroundColor(.white)
            //                                .background(Color.blue)
            //                                .cornerRadius(6)
            //                        })
            
            Button(action: { isOnboarding = false }, label: {
                
                Text("Пропустить")
                //.padding()
                    .foregroundColor(Color("next"))
            })
            
        }
    }
}
