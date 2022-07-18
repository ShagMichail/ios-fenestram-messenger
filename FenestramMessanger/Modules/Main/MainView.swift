//
//  MainView.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 04.07.2022.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: ViewModel
    @AppStorage("isActiv") var isActiv: Bool?
    @AppStorage("isAlreadySetProfile") var isAlreadySetProfile: Bool?
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        if viewModel.isSignIn {
            if (isAlreadySetProfile ?? false) || !(Settings.currentUser?.isInfoEmpty ?? true) {
                MainTabView()
                    .navigationBarHidden(true)
            } else {
                AccountView()
                    .navigationBarHidden(true)
            }
        } else {
            PhoneView()
                .navigationBarHidden(true)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
