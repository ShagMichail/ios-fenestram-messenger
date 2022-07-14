//
//  SettingsView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.white)
            }
        }
    }
    
    var title : some View {
        Text("Настройки")
            .foregroundColor(Color.white)
            .font(.system(size: 20))
    }
    
    var body: some View {
        ZStack {
            Color("thema").ignoresSafeArea()
            VStack {
                RoundedRectangle(cornerRadius: 0)
                //.background(Color("buttonDis"))
                    .foregroundColor(Color("buttonDis"))
                    .frame(width: UIScreen.screenWidth, height: 100.0)
                    .ignoresSafeArea()
                Spacer()
            }
            Text("Settings!").foregroundColor(Color.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: title)
        .navigationBarItems(leading: btnBack)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
