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
                        ZStack {
                            Circle()
                                //.stroke(Color.white, lineWidth: 6)
                                .foregroundColor(Color.white)
                                .frame(width: 10.0, height: 10.0)
                                .scaleEffect(animationValues[4] ? -1 : 0)
                                .offset(x: animationValues[3] ? -120 : 0, y: animationValues[3] ? 370 : 0)
                            Circle()
                                //.stroke(Color.white, lineWidth: 6)
                                .foregroundColor(Color.white)
                                .frame(width: 20.0, height: 20.0)
                                .scaleEffect(animationValues[5] ? -1 : 0)
                                .offset(x: animationValues[3] ? -100 : 0, y: animationValues[3] ? 360 : 0)
                            Circle()
                                //.stroke(Color.white, lineWidth: 6)
                                .foregroundColor(Color.white)
                                .frame(width: 25.0, height: 25.0)
                                .scaleEffect(animationValues[6] ? -1 : 0)
                                .offset(x: animationValues[3] ? -60 : 0, y: animationValues[3] ? 350 : 0)
                        }
                        
                        ZStack {
                            Circle()
                                .stroke(Color.white, lineWidth: 6)
                                .frame(width: 200.0, height: 200.0)
                                .scaleEffect(animationValues[7] ? 1 : 10)
                                .offset(x: animationValues[7] ? 60 : 0, y: animationValues[7] ? 250 : 0)
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .frame(width: 180.0, height: 180.0)
                                .scaleEffect(animationValues[7] ? 1 : 10)
                                .offset(x: animationValues[7] ? 60 : 0, y: animationValues[7] ? 250 : 0)
                            CircleText(radius: 132, text: "ОБЩЕСТВО С ОГРАННИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ * МОСКВА * ")
                                .foregroundColor(Color.white)
                                .frame(width: 130.0, height: 130.0)
                                .scaleEffect(animationValues[7] ? 1 : 10)
                                .offset(x: animationValues[7] ? 60 : 0, y: animationValues[7] ? 250 : 0)
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .frame(width: 130.0, height: 130.0)
                                .scaleEffect(animationValues[7] ? 1 : 10)
                                .offset(x: animationValues[7] ? 60 : 0, y: animationValues[7] ? 250 : 0)

                            Text("TFN").foregroundColor(Color.white)
                                .frame(width: 150.0, height: 60.0)
                                .font(.system(size: 40))
                                .scaleEffect(animationValues[7] ? 1 : 0)
                                .offset(x: animationValues[7] ? 60 : 10, y: animationValues[7] ? 240 : 0)

                            Text("GROUP").foregroundColor(Color.white)
                                .frame(width: 150.0, height: 60.0)
                                .font(.system(size: 15))
                                .scaleEffect(animationValues[7] ? 1 : 0)
                                .offset(x: animationValues[7] ? 60 : 10, y: animationValues[7] ? 270 : 0)
                        }
                        
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.3).delay(0.45)){
                    animationValues[4] = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.4).delay(0.45)){
                        animationValues[5] = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeInOut(duration: 0.5).delay(0.45)){
                            animationValues[6] = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.easeInOut(duration: 0.6).delay(0.45)){
                                animationValues[7] = true
                                }
                            }
                        }
                    }
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
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


//MARK: - CircleLabel
struct CircleText: View {
    var radius: Double
    var text: String
    var kerning: CGFloat = 5.0
    
    private var texts: [(offset: Int, element:Character)] {
        return Array(text.enumerated())
    }
    
    @State var textSizes: [Int:Double] = [:]
    
    var body: some View {
        ZStack {
            ForEach(self.texts, id: \.self.offset) { (offset, element) in
                VStack {
                    Text(String(element))
                        .kerning(self.kerning)
                        .background(Sizeable())
                        .onPreferenceChange(WidthPreferenceKey.self, perform: { size in
                            self.textSizes[offset] = Double(size)
                        })
                    Spacer()
                }
                .rotationEffect(self.angle(at: offset))
                
            }
        }.rotationEffect(-self.angle(at: self.texts.count-1)/2.5)
        
            .frame(width: 175, height: 175, alignment: .center)
    }
    
    private func angle(at index: Int) -> Angle {
        guard let labelSize = textSizes[index] else {return .radians(0)}
        let percentOfLabelInCircle = labelSize / radius.perimeter
        let labelAngle = 2 * Double.pi * percentOfLabelInCircle
        
        
        let totalSizeOfPreChars = textSizes.filter{$0.key < index}.map{$0.value}.reduce(0,+)
        let percenOfPreCharInCircle = totalSizeOfPreChars / radius.perimeter
        let angleForPreChars = 2 * Double.pi * percenOfPreCharInCircle
        
        return .radians(angleForPreChars + labelAngle)
    }
    
}



extension Double {
    var perimeter: Double {
        return self * 2 * .pi
    }
}


//Get size for label helper
struct WidthPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat(0)
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
struct Sizeable: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}

