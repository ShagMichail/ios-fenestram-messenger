//
//  FenestramMessangerApp.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 04.07.2022.
//

import SwiftUI

@main
struct FenestramMessangerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage("isOnboarding") var isOnboarding = true
    @AppStorage("isActiv") var isActiv = false
    @AppStorage("isColorThema") var isColorThema = false
    @AppStorage("isPhoneUser") var isPhoneUser = " "
    @AppStorage("isCodeUser") var isCodeUser = " "

    var body: some Scene {
        WindowGroup {
            if isActiv {
                VStack {
                    if isOnboarding {
                        OnboardingContainerView()
                    } else {
                        MainView()
                    }
                }
                .onDisappear{
                    isActiv = false
                }
            } else {
                SplashScreen()
            }
        }
    }
}
