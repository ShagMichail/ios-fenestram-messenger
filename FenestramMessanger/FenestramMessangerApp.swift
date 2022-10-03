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
    @AppStorage("isColorThema") var isColorThema: Bool?
    @AppStorage("isPhoneUser") var isPhoneUser = " "
    @AppStorage("isCodeUser") var isCodeUser = " "
    
    @State private var isRunApp: Bool = true

    var body: some Scene {
        WindowGroup {
            if isRunApp {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isRunApp = false
                        }
                    }
            } else {
                VStack {
                    if isOnboarding {
                        OnboardingContainerView()
                    } else {
                        MainView()
                    }
                }
                .onAppear {
                    if isColorThema == nil {
                        isColorThema = false
                    }
                }
            }
        }
    }
}
