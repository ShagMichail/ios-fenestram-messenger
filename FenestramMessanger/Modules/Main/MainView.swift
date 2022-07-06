//
//  MainView.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 04.07.2022.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        NavigationView {
            if viewModel.isSignIn {
                PhoneView().navigationBarHidden(true)
            } else {
                Text("Not implemented")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
