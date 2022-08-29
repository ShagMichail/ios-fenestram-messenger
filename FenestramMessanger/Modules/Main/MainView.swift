//
//  MainView.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 04.07.2022.
//

import SwiftUI

struct MainView: View {
    
    
    //MARK: - Properties
    
    @AppStorage("isActiv") var isActiv: Bool?
    @AppStorage("isAlreadySetProfile") var isAlreadySetProfile: Bool?
    
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    
    //MARK: - Body
    
    var body: some View {
        if viewModel.isSignIn {
            if (isAlreadySetProfile ?? false) || !(Settings.currentUser?.isInfoEmpty ?? true) {
                MainTabView(socketManager: viewModel.socketManager)
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
