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
    var body: some Scene {
        WindowGroup {
            NavigationView{
                if isOnboarding {
                    OnboardingContainerView().navigationBarHidden(true)
                } else {
                    MainView().navigationBarHidden(true)
                }
            }
        }
    }
}
