//
//  OnboardingCV.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 12.07.2022.
//

import SwiftUI

//let features = [
//    Feature(title: "Разнообразный и богатый опыт рамки и место обучения кадров обеспечивает широкому кругу (специалистов) участие в формировании существенных финансовых и административных условий.", subtitle: "next" , image: "onboardingFirst"),
//    Feature(title: "Задача организации, в особенности же рамки и место обучения кадров способствует подготовки и реализации позиций, занимаемых участниками в отношении поставленных задач.",subtitle: "next", image: "onboardingSecond"),
//    Feature(title: "С другой стороны укрепление и развитие структуры играет важную роль в формировании существенных финансовых и административных условий.", subtitle: "out", image: "onboardingThird")
//]

struct OnboardingContentView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    //@AppStorage("isSelectedPage") var isSelectedPage: Int?
    //@Binding private var selectedPage: Int
    var feature: Feature
    
    var body: some View {
        ZStack {
            
            VStack {
                Spacer()
                Image(feature.image)
                    .resizable()
                    .scaledToFit()
                Spacer()
                
                VStack(spacing: 20) {
                    Text(feature.title)
                        .font(.system(size: 14))
                        .foregroundColor(Color("photoBack"))
                        .multilineTextAlignment(.center)
                }.padding()
                Spacer()
                //getPage()
                //Spacer()
                if feature.subtitle == "next" {
                    getButtonNext()
                } else {
                    getButtonOut()
                }
                //getButtonOut()
                    //.padding()
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func getButtonNext() -> some View {
        VStack {
            Button(action: {

                
            }, label: {
                
                Text("Далее")
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .foregroundColor(.white)
                    .background(Color("blue"))
                    .cornerRadius(6)
            })
            
            Button(action: { isOnboarding = false }, label: {
                Text("Пропустить")
                    .foregroundColor(Color("next"))
            })
        }
    }
    
    private func getButtonOut() -> some View {
        VStack {
            Button(action: { isOnboarding = false }, label: {
                Text("Готово")
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .foregroundColor(.white)
                    .background(Color("blue"))
                    .cornerRadius(6)
            })
            //                NavigationLink(destination: PhoneView().navigationBarHidden(true)){
            //                    Text("Далее")
            //                        .frame(width: UIScreen.screenWidth - 30, height: 45.0)
            //                        .foregroundColor(.white)
            //                        .background(Color("blue"))
            //                        .cornerRadius(6)
            //                }
            Button(action: { isOnboarding = false }, label: {
                Text("Пропустить")
                    .foregroundColor(Color("thema"))
            }).disabled(true)
        }
    }
}

//struct OnboardingContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingContentView(feature: features[0])
//    }
//}
