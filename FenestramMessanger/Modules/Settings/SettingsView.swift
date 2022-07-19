//
//  SettingsView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage ("isColorThema") var isColorThema: Bool?
    @StateObject private var viewModel: ViewModel
    @State var colorThema = false
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
        Text(L10n.SettingsView.title)
            .foregroundColor(Color.white)
            .font(FontFamily.Poppins.regular.swiftUIFont(size: 20))
    }
    
    var body: some View {
        ZStack {
            Asset.thema.swiftUIColor
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Asset.buttonDis.swiftUIColor)
                    .frame(width: UIScreen.screenWidth, height: 100.0)
                    .ignoresSafeArea()
                Spacer()
            }
            VStack(alignment: .leading) {
                HStack{
                    Asset.color.swiftUIImage
                        .resizable()
                        .frame(width: 22.0, height: 22.0)
                        .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                    Text(L10n.SettingsView.color)
                        .font(FontFamily.Poppins.bold.swiftUIFont(size: 16))
                        .foregroundColor(Color.white)
                        .padding(.leading)
                    Spacer()
                    if isColorThema ?? false {
                        Button {
                            isColorThema = false
                        } label: {
                            RoundedRectangle(cornerRadius: 40)
                                .frame(width: 24, height: 24)
                                .foregroundColor(Asset.blue.swiftUIColor)
                        }
                        
                        Spacer().frame(width: 30)
                        
                        Button {
                            isColorThema = true
                        } label: {
                            RoundedRectangle(cornerRadius: 40)
                                .frame(width: 30, height: 30)
                                .foregroundColor(Asset.green.swiftUIColor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.white, lineWidth: 3)
                                )
                        }.padding(.trailing)
                    } else {
                        Button {
                            isColorThema = false
                        } label: {
                            RoundedRectangle(cornerRadius: 40)
                                .frame(width: 30, height: 30)
                                .foregroundColor(Asset.blue.swiftUIColor)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color.white, lineWidth: 3)
                                )
                        }
                        
                        Spacer().frame(width: 30)
                        
                        Button {
                            isColorThema = true
                        } label: {
                            RoundedRectangle(cornerRadius: 40)
                                .frame(width: 24, height: 24)
                                .foregroundColor(Asset.green.swiftUIColor)
                        }.padding(.trailing)
                    }
                }
                
                Spacer().frame(height: 40)
                HStack{
                    Asset.info.swiftUIImage
                        .resizable()
                        .frame(width: 22.0, height: 22.0)
                        .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                        .background((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                    Text(L10n.SettingsView.info)
                        .font(FontFamily.Poppins.bold.swiftUIFont(size: 16))
                        .foregroundColor(Color.white)
                        .padding(.leading)
                }
                Spacer().frame(height: 40)
                HStack{
                    Asset.exit.swiftUIImage
                        .resizable()
                        .frame(width: 22.0, height: 22.0)
                        .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                    Text(L10n.SettingsView.exit)
                        .font(FontFamily.Poppins.bold.swiftUIFont(size: 16))
                        .foregroundColor(Color.white)
                        .padding(.leading)
                }
                Spacer()
            }.padding()
            
            Spacer()
            //                RoundedRectangle(cornerRadius: 0)
            //                    .foregroundColor(Asset.buttonDis.swiftUIColor)
            //                    .frame(width: UIScreen.screenWidth, height: 100.0)
            //                    .ignoresSafeArea()
            //                Spacer()
            
            
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
