//
//  SettingsView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 08.07.2022.
//

import SwiftUI

struct SettingsView: View {
    
    
    //MARK: - Properties
    
    @State var uiTabarController: UITabBarController?
    @State var colorThema = false
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Asset.background.swiftUIColor
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                getHeaderView()
                
                Spacer().frame(height: 20)
                
                getColorThemaSettings()
                
                Spacer().frame(height: 40)

                getInfoSettings()
                
                Spacer().frame(height: 40)
                
                getDeleteAccountSettings()
                
                Spacer().frame(height: 40)
                
                getOutSettings()
                
                Spacer()
            }
            .padding(.horizontal, 24)
            
            if viewModel.showDeleteAccountAlert {
                getDeleteAccountAlertView()
            }
        }
        .navigationBarHidden(true)
    }
    
    
    //MARK: - Views
    
    private func getHeaderView() -> some View {
        ZStack(alignment: .leading) {
            Asset.dark1.swiftUIColor
                .ignoresSafeArea()
            
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.white)
                    }
                }
                .padding(.trailing, 16)
                
                Text(L10n.SettingsView.title)
                    .font(FontFamily.Poppins.bold.swiftUIFont(size: 18))
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal, 24)
        }
        .frame(height: 50)
        .padding(.horizontal, -24)
    }
    
    private func getColorThemaSettings() -> some View {
        HStack{
            Asset.color.swiftUIImage
                .resizable()
                .frame(width: 22.0, height: 22.0)
                .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
            Text(L10n.SettingsView.color)
                .font(FontFamily.Poppins.bold.swiftUIFont(size: 16))
                .foregroundColor(Color.white)
                .padding(.leading)
            Spacer()
            if isColorThema ?? true {
                Button {
                    isColorThema = false
                } label: {
                    RoundedRectangle(cornerRadius: 40)
                        .frame(width: 24, height: 24)
                        .foregroundColor(Asset.blue1.swiftUIColor)
                }
                
                Spacer().frame(width: 30)
                
                Button {
                    isColorThema = true
                } label: {
                    RoundedRectangle(cornerRadius: 40)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Asset.green1.swiftUIColor)
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
                        .foregroundColor(Asset.blue1.swiftUIColor)
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
                        .foregroundColor(Asset.green1.swiftUIColor)
                }.padding(.trailing)
            }
        }
    }
    
    private func getInfoSettings() -> some View {
        NavigationLink(destination: VersionAppView()) {
            HStack{
                Asset.info.swiftUIImage
                    .resizable()
                    .frame(width: 22.0, height: 22.0)
                    .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                Text(L10n.SettingsView.info)
                    .font(FontFamily.Poppins.bold.swiftUIFont(size: 16))
                    .foregroundColor(Color.white)
                    .padding(.leading)
            }
        }
    }
    
    private func getDeleteAccountSettings() -> some View {
        Button {
            viewModel.showDeleteAccountAlert = true
        } label: {
            HStack {
                Asset.deleteAccountIcon.swiftUIImage
                    .resizable()
                    .frame(width: 22.0, height: 22.0)
                
                Text(L10n.SettingsView.deleteAccount)
                    .font(FontFamily.Poppins.bold.swiftUIFont(size: 16))
                    .foregroundColor(Color.white)
                    .padding(.leading)
            }
        }
    }
    
    private func getDeleteAccountAlertView() -> some View {
        ZStack {
            Color.black
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.showDeleteAccountAlert = false
                }
            
            VStack {
                VStack {
                    Text(L10n.SettingsView.DeleteAccountAlert.title)
                        .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                        .foregroundColor(.white)
                        .padding(.top, 42)
                    
                    Text(L10n.SettingsView.DeleteAccountAlert.message)
                        .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 14))
                        .foregroundColor(Asset.red.swiftUIColor)
                        .padding(.top, 8)
                    
                    HStack {
                        Button {
                            viewModel.showDeleteAccountAlert = false
                        } label: {
                            ZStack {
                                Asset.background0.swiftUIColor
                                
                                Text(L10n.General.cancel)
                                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 14))
                                    .foregroundColor(Asset.grey1.swiftUIColor)
                            }
                            .frame(height: 48)
                            .cornerRadius(5)
                        }
                        
                        Button {
                            viewModel.deleteAccount()
                        } label: {
                            ZStack {
                                Asset.background0.swiftUIColor
                                
                                Text(L10n.General.delete)
                                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 14))
                                    .foregroundColor(Asset.red.swiftUIColor)
                            }
                            .frame(height: 48)
                            .cornerRadius(5)
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 24)
            }
            .background(Asset.dark1.swiftUIColor)
            .cornerRadius(20)
            .padding(.horizontal, 24)
        }
    }
    
    private func getOutSettings() -> some View {
        HStack{
            Button {
                viewModel.out()
            } label: {
                Asset.exit.swiftUIImage
                    .resizable()
                    .frame(width: 22.0, height: 22.0)
                    .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                Text(L10n.SettingsView.exit)
                    .font(FontFamily.Poppins.bold.swiftUIFont(size: 16))
                    .foregroundColor(Color.white)
                    .padding(.leading)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
