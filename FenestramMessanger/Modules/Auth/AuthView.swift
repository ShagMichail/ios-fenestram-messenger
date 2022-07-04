//
//  AuthView.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 04.07.2022.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        Text("This is AuthView")
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
