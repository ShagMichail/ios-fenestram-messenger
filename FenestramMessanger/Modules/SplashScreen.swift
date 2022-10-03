//
//  SplashScreen.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 13.07.2022.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        LottieView(name: Constants.Animations.splashscreen)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
