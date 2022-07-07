//
//  OnboardingThirdView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct OnboardingThirdView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    let features =
    Feature(title: "return", subtitle: "С другой стороны укрепление и развитие структуры играет важную роль в формировании существенных финансовых и административных условий.", image: "onboardingThird")
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
            
            
            
            Button(action: {
                isOnboarding = false
            }, label: {
                
                Text("Далее")
                
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                
                    .foregroundColor(.white)
                    .background(Color("blue"))
                    .cornerRadius(6)
            })
            
            
        }
    }
}

