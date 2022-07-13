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
            Color("thema").ignoresSafeArea()
            
            VStack {
                VStack (alignment: .center){
                    getHeader()
                }
                VStack  {
 
                    Image("onboardingFirst")
                        .resizable()
                        .scaledToFit()
                    Spacer()
                        .frame(height: 22)
                    
                    VStack(spacing: 20) {
                        Text("Здесь будет отображаться список ваших чатов")
                            .font(.system(size: 16))
                            .foregroundColor(Color("photoBack"))
                            .multilineTextAlignment(.center)
                    }.padding()
                }
                .padding()
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                Spacer()
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
                Image(systemName: "gearshape").foregroundColor(Color("blue"))
            }
        }
            .padding()
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

