//
//  FenestramMessangerApp.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 04.07.2022.
//

import SwiftUI

@main
struct FenestramMessangerApp: App {
    @AppStorage("isOnboarding") var isOnboarding = true
    @AppStorage("isActiv") var isActiv = false

    var body: some Scene {
        WindowGroup {
            if isActiv {
                NavigationView{
                    if isOnboarding {
                        OnboardingContainerView().navigationBarHidden(true)
                    } else {
                        MainView().navigationBarHidden(true)
                    }
                }.onDisappear{
                    isActiv = false
                }
            } else {
                SplashScreen()
            }
        }
    }
}
