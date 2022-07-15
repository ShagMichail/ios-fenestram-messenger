//
//  Feature.swift
//  OnboardingTutorial
//
//  Created by Logan Koshenka on 7/27/21.
//

import SwiftUI

struct Feature: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var image: Image
}

let features = [
    Feature(title: L10n.OnboardingView.firstDescription, subtitle: "next" , image: Asset.onboardingFirst.swiftUIImage),
    Feature(title: L10n.OnboardingView.secondDescription,subtitle: "next", image: Asset.onboardingSecond.swiftUIImage),
    Feature(title: L10n.OnboardingView.thirdDescription, subtitle: "out", image: Asset.onboardingThird.swiftUIImage)
]
