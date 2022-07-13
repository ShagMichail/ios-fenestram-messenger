//
//  OnboardingCCv.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 12.07.2022.
//

import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State private var selectedPage = 0
    
    var body: some View {
        
        ZStack {
            Color("thema").ignoresSafeArea()
            VStack{
                TabView(selection: $selectedPage){
                    ForEach(0..<features.count) { it in
                        VStack {
                            Spacer()
                            Image(features[it].image)
                                .resizable()
                                .scaledToFit()
                            Spacer().frame(height: 53)
                            
                            VStack(spacing: 20) {
                                Text(features[it].title)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color("photoBack"))
                                    .multilineTextAlignment(.center)
                            }.padding()
                            
                            
                        }.tag(it)
                        
                    }
                    
                }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Spacer().frame(height: 28)
                
                HStack(spacing: 15) {
                    ForEach(0..<features.count) { it in
                        if it == selectedPage {
                        Capsule()
                            .fill(Color("page"))
                            .frame(width: 38 , height: 7)
                        } else {
                            Capsule()
                                .fill(Color("page"))
                                .frame(width: 7 , height: 7)
                        }
                    }
                }
                
                Spacer().frame(height: 58)
                
                getButton()
            }
        }
    }
    
    private func getButton() -> some View {
        VStack {
            Button(action: {
                if selectedPage < features.count - 1 {
                    self.selectedPage += 1
                } else {
                    isOnboarding = false
                }
                
            }, label: {
                
                Text(selectedPage < features.count - 1 ? "Далее" : "Готово")
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .foregroundColor(.white)
                    .background(Color("blue"))
                    .cornerRadius(6)
            })
            
            Button(action: { isOnboarding = false }, label: {
                Text("Пропустить")
                    .foregroundColor(!(selectedPage < features.count - 1) ? Color("thema") : Color("next"))
            }).disabled(!(selectedPage < features.count - 1))
        }
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
    }
}
