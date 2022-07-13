//
//  Home.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 12.07.2022.
//

import SwiftUI

struct Home: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State var offset: CGFloat = 0
    var screenSize: CGSize
    
    var body: some View {
        ZStack {
            Color("thema").ignoresSafeArea()
            VStack {
                OffsetPageTabView(offset: $offset) {
                    
                    HStack (spacing: 0){
                        
                        ForEach(features){ feature in
                            
                            ZStack {
                                Color("thema").ignoresSafeArea()
                                VStack {
                                    Image(feature.image)
                                    .resizable()
                                    //.scaledToFit()
                                    .frame(width: screenSize.height/2, height: screenSize.height/2)
                                    .aspectRatio(contentMode: .fit)
                                    
                                    
                                    //Spacer().frame(height: 40)
                                    
                                    VStack(alignment: .leading ,spacing: 20) {
                                        Text(feature.title)
                                            .font(.system(size: 14))
                                            
                                            .foregroundColor(Color("photoBack"))
                                            .multilineTextAlignment(.center)
                                            //.lineLimit(5)
                                    }.padding(.top, 50)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    
                                }.padding()
                                    .frame(width: screenSize.width)
                                
                            }
                           
                            
                        }
                    }
                    
                }
                VStack(alignment: .center) {
                    //Spacer()
                    
                    HStack(spacing: 12) {
                        ForEach(features.indices,id: \.self){ index in
                            Capsule()
                                .fill(Color("page"))
                                .frame(width: getIndex() == index ? 38 : 7, height: 7)
                        }
                    }
                    .overlay(
                        Capsule()
                            .fill(Color("page"))
                            .frame(width: 38, height: 7)
                            .offset(x: detIndicatorOffset())
                        ,alignment: .leading
                    )
                    
                    Spacer().frame( height: 50)
                    if getIndex() != 2 {
                        Button {
                            let index = min(getIndex() + 1, features.count - 1)
                            offset = CGFloat(index) * screenSize.width
                        } label: {
                            Text("Далее")
                                .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                                .foregroundColor(.white)
                                .background(Color("blue"))
                                .cornerRadius(6)
                        }
                        
                        Button(action: { isOnboarding = false }, label: {
                            Text("Пропустить")
                                .foregroundColor(Color("next"))
                        })
                    } else {
                        Button(action: { isOnboarding = false }, label: {
                            Text("Готово")
                                .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                                .foregroundColor(.white)
                                .background(Color("blue"))
                                .cornerRadius(6)
                        })
                        Button(action: { isOnboarding = false }, label: {
                            Text("Пропустить")
                                .foregroundColor(Color("thema"))
                        }).disabled(true)
                    }

                }
                
                
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
           // .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight, alignment: .top)
            .onChange(of: offset) { _ in
                print(offset)
            }
        
    }
    
    func detIndicatorOffset()->CGFloat {
        let progress = offset / screenSize.width
        let maxWidth: CGFloat = 12 + 7
        return progress * maxWidth
    }
    
    func getIndex()-> Int {
        let progress = round(offset / screenSize.width)
        if progress.isNaN {
            let index = 0
            return index
        } else {
            let index = min(Int(progress), features.count - 1)
            return index
        }
        //return Int(progress)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentOnboarding()
    }
}
