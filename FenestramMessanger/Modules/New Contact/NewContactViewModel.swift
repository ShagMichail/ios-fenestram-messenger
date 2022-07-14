//
//  NewContactViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 13.07.2022.
//
import SwiftUI

extension NewContactView {
    @MainActor
    final class ViewModel: ObservableObject {

        @Published var image: UIImage?
        
        @Published var name = ""
        @Published var lastName = ""
        @Published var textPhone = ""
        
        @Published var isTappedName = false
        @Published var isTappedLastName = false
        @Published var isTappedPhoneNumber = false

        @Published var contact: Contact? = nil
        
        @Published var isTappedGlobal = false
        
    }
}
