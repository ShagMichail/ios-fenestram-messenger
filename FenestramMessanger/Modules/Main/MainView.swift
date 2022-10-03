//
//  MainView.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 04.07.2022.
//

import SwiftUI

struct MainView: View {
    
    
    //MARK: - Properties
    @AppStorage("isAlreadySetProfile") var isAlreadySetProfile: Bool?
    
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Asset.background.swiftUIColor
                .ignoresSafeArea()
            
            VStack {
                if !viewModel.isOnline {
                    HStack {
                        Text(L10n.General.noInternetConnection)
                            .font(FontFamily.Poppins.medium.swiftUIFont(size: 16))
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(height: 40)
                    .background(Asset.red.swiftUIColor)
                    .cornerRadius(8)
                }
                
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
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
