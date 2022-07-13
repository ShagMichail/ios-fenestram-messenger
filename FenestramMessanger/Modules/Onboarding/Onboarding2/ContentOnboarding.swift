//
//  ContentOnboarding.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 13.07.2022.
//

import SwiftUI

struct ContentOnboarding: View {
    var body: some View {
        GeometryReader{ proxy in
            let size = proxy.size
            Home(screenSize: size)
        }
    }
}

struct ContentOnboarding_Previews: PreviewProvider {
    static var previews: some View {
        ContentOnboarding()
    }
}
