//
//  ChatView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 09.07.2022.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject private var viewModel: ViewModel
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        ZStack {
            Asset.thema.swiftUIColor
                .ignoresSafeArea()
            
            VStack {
                getHeader()
                
                getEmptyView()
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .navigationBarHidden(true)
        
    }
    
    private func getHeader() -> some View {
        HStack(alignment: .center){
            Text("FENESTRAM")
                .foregroundColor(Color.white)
                .font(.system(size: 22))
            Spacer()
            NavigationLink() {
                SettingsView()
            } label: {
                Image(systemName: "gearshape").foregroundColor(Asset.blue.swiftUIColor)
            }
        }
            .padding()
    }
    
    private func getEmptyView() -> some View {
        VStack {
            Spacer()
            
            Asset.onboardingFirst.swiftUIImage
                .resizable()
                .scaledToFit()
            
            Spacer()
                .frame(height: 22)
            
            VStack(spacing: 20) {
                Text(L10n.ChatView.emptyText)
                    .font(.system(size: 16))
                    .foregroundColor(Asset.photoBack.swiftUIColor)
                    .multilineTextAlignment(.center)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

