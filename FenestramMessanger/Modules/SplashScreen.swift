//
//  SplashScreen.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 13.07.2022.
//

import SwiftUI

struct SplashScreen: View {
    @State var animationValues: [Bool] = Array(repeating: false, count: 10)
    @AppStorage("isActiv") var isActiv: Bool?
    var body: some View {
        ZStack{
            Color("thema").ignoresSafeArea()
            ZStack{
                if animationValues[1]{
                    Circle()
                        .stroke(Color.white, lineWidth: 6)
                        .frame(width: 40.0, height: 40.0)
                        .scaleEffect(animationValues[2] ? 1 : 0)
                        .offset(x: animationValues[2] ? -52 : 0)
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .trim(from: 0.5, to: 1)
                            .stroke(Color.white, lineWidth: 6)
                            .frame(width: 40.0, height: 40.0)
                            .padding(.bottom, 150)
                            .offset(x: animationValues[2] ? -75 : 0, y: animationValues[2] ? 1 : 0)
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 6.0, height: 58.0)
                            .padding(.bottom, 150)
                            .offset(x: animationValues[2] ? -55 : 0, y: animationValues[2] ? 29 : 0)
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 6.0, height: 58.0)
                            .padding(.bottom, 150)
                            .offset(x: animationValues[2] ? -95 : 0, y: animationValues[2] ? 29 : 0)
                        Text("H").foregroundColor(Color.white)
                            .frame(width: 50.0, height: 60.0)
                            .font(.system(size: 60))
                            .offset(x: animationValues[2] ? -145 : 0, y: animationValues[2] ? 1 : 0)
                        Text("LICHAT").foregroundColor(Color.white)
                            .frame(width: 200.0, height: 60.0)
                            .font(.system(size: 60))
                            .offset(x: animationValues[2] ? 70 : 0, y: animationValues[2] ? 1 : 0)
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 6)
                            .frame(width: 200.0, height: 200.0)
                            .scaleEffect(animationValues[3] ? 1 : 3)
                            .offset(x: animationValues[3] ? 1 : 0, y: animationValues[3] ? 250 : 0)
                        Text("TFN").foregroundColor(Color.white)
                            .frame(width: 150.0, height: 60.0)
                            .font(.system(size: 70))
                            .offset(x: animationValues[3] ? 1 : 0, y: animationValues[3] ? 240 : 0)
                        Text("GROUP").foregroundColor(Color.white)
                            .frame(width: 150.0, height: 60.0)
                            .font(.system(size: 25))
                            .offset(x: animationValues[3] ? 1 : 0, y: animationValues[3] ? 290 : 0)
                        
                    }.opacity(animationValues[3] ? 1 : 0)
                }
                Circle()
                    .stroke(Color.white, lineWidth: 6)
                    .frame(width: 40.0, height: 40.0)
                    .scaleEffect(animationValues[0] ? 1 : 0, anchor: .bottom)
                    .offset(x: animationValues[2] ? -100 : 0)
                
            }
            .environment(\.colorScheme, .light)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)){
                animationValues[0] = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animationValues[1] = true
                withAnimation(.easeInOut(duration: 0.7).delay(0.1)){
                    animationValues[2] = true
                }
                withAnimation(.easeInOut(duration: 0.4).delay(0.45)){
                    animationValues[3] = true
                }
                withAnimation(.easeInOut(duration: 2).delay(0.45)){
                    animationValues[4] = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isActiv = true
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
