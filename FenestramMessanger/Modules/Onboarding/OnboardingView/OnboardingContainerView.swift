//
//  OnboardingCCv.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 12.07.2022.
//

import SwiftUI

struct OnboardingContainerView: View {
    
    
    //MARK: - Properties
    
    @State private var selectedPage = 0
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    
    //MARK: - Body
    
    var body: some View {
        
        ZStack {
            Asset.thema.swiftUIColor
                .ignoresSafeArea()
            
            VStack{
                TabView(selection: $selectedPage){
                    ForEach(0..<features.count) { it in
                        VStack {
                            Spacer()
                            features[it].image
                                .resizable()
                                .scaledToFit()
                            Spacer().frame(height: 53)
                            
                            VStack(spacing: 20) {
                                Text(features[it].title)
                                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                                    .foregroundColor(Asset.photoBack.swiftUIColor)
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
                                .fill(Asset.page.swiftUIColor)
                                .frame(width: 38 , height: 7)
                        } else {
                            Capsule()
                                .fill(Asset.page.swiftUIColor)
                                .frame(width: 7 , height: 7)
                        }
                    }
                }
                
                Spacer().frame(height: 58)
                
                getButton()
            }
        }
    }
    
    
    //MARK: - Views
    
    private func getButton() -> some View {
        VStack {
            Button(action: {
                if selectedPage < features.count - 1 {
                    self.selectedPage += 1
                } else {
                    isOnboarding = false
                }
                
            }, label: {
                Text(selectedPage < features.count - 1 ? L10n.General.next : L10n.General.done)
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                    .background((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                    .cornerRadius(6)
            })
            
            Button(action: { isOnboarding = false }, label: {
                Text(L10n.General.skip)
                    .font(FontFamily.Poppins.medium.swiftUIFont(size: 16))
                    .foregroundColor(!(selectedPage < features.count - 1) ? Asset.thema.swiftUIColor : Asset.next.swiftUIColor)
            }).disabled(!(selectedPage < features.count - 1))
        }
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
    }
}
