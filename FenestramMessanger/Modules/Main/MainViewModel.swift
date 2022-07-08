//
//  MainViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 04.07.2022.
//

import SwiftUI

extension MainView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var isSignIn: Bool = false
    }
}
