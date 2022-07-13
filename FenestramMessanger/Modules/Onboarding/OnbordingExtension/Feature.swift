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
    var image: String
}

let features = [
    Feature(title: "Разнообразный и богатый опыт рамки и место обучения кадров обеспечивает широкому кругу (специалистов) участие в формировании существенных финансовых и административных условий.", subtitle: "next" , image: "onboardingFirst"),
    Feature(title: "Задача организации, в особенности же рамки и место обучения кадров способствует подготовки и реализации позиций, занимаемых участниками в отношении поставленных задач.",subtitle: "next", image: "onboardingSecond"),
    Feature(title: "С другой стороны укрепление и развитие структуры играет важную роль в формировании существенных финансовых и административных условий.", subtitle: "out", image: "onboardingThird")
]
