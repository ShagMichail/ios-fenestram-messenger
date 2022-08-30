//
//  NewChatView.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 30.08.2022.
//

import SwiftUI

struct NewChatView: View {
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        ZStack {
            
        }
        .navigationBarHidden(true)
    }
}

struct NewChatView_Previews: PreviewProvider {
    static var previews: some View {
        NewChatView()
    }
}
