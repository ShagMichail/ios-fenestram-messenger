//
//  Code.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 05.07.2022.
//

import SwiftUI
import Introspect
import Combine

struct CodeView: View {
    
    
    //MARK: - Properties
    
    @State private var keyboardHeight: CGFloat = 0
    
    let maskCode = "XXXX"
    
    @AppStorage("isCodeUser") var isCodeUser: String?
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel: ViewModel
    
    init(phoneNumber: String) {
        _viewModel = StateObject(wrappedValue: ViewModel(phoneNumber: phoneNumber))
    }
   
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Asset.thema.swiftUIColor
                .ignoresSafeArea()
            
            getBase()
            
            if viewModel.presentAlert {
                AlertView(show: $viewModel.presentAlert, text: viewModel.textAlert)
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    
    //MARK: - Views
    
    private func getBase() -> some View {
        VStack(alignment: .center) {
            Text("FENESTRAM")
                .font(FontFamily.Montserrat.semiBold.swiftUIFont(size: 18))
                .foregroundColor(.white)
            
            Spacer()
                .frame(height: 100.0)
            
            VStack (alignment: .trailing){
                VStack(alignment: .leading){
                    Text(L10n.CodeView.enterCode)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                        .foregroundColor(Asset.text.swiftUIColor)
                    
                    Spacer().frame(height: 3.0 )
                    
                    getTextField()
                    
                }
                getErrorMessage()
            }
            
            Spacer()
                .frame(height: 50.0)
            
            getButton()
           
        }
        .padding()
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
 
    private func getButton() -> some View {
        NavigationLink(isActive: $viewModel.showAccountView) {
            AccountView().navigationBarHidden(true)
        } label: {
            Button(action: {
                viewModel.login()
                if viewModel.textCode.count == 4 {
                    isCodeUser = viewModel.textCode
                }
            }) {
                Text(L10n.General.done)
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                    .background((viewModel.textCode.count == 4 && viewModel.errorCode == false) ? (isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor) : Asset.buttonDis.swiftUIColor)
                    .cornerRadius(6)
            }
        }
        .disabled(viewModel.textCode.count != 4 || viewModel.errorCode)
    }
    
    private func getErrorMessage() -> some View {
        HStack {
            if viewModel.errorCode {
                Text(L10n.CodeView.incorrectPassword)
                    .foregroundColor(Asset.red.swiftUIColor)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                
                Button(action: {
                    self.viewModel.sendAgain()
                }) {
                    Text(L10n.CodeView.sendAgain)
                        .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 12))
                        .foregroundColor(Color.red)
                }
            } else {
                if viewModel.showSendAgainButton {
                    Button(action: {
                        self.viewModel.sendAgain()
                    }) {
                        Text(L10n.CodeView.sendAgain)
                            .font(FontFamily.Poppins.medium.swiftUIFont(size: 12))
                            .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                    }
                } else {
                    Text(L10n.CodeView.sendAgainAfter(viewModel.timer))
                        .font(FontFamily.Poppins.medium.swiftUIFont(size: 12))
                        .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                }
            }
        }
    }
    
    private func getTextField() -> some View {
        VStack {
            if viewModel.errorCode {
                TextField("", text: $viewModel.textCode)
                .placeholder(when: viewModel.textCode.isEmpty) {
                    Text("").foregroundColor(Asset.red.swiftUIColor)
                }
                .onChange(of: viewModel.textCode) {
                    newValue in viewModel.changeIncorrect()
                }
                .foregroundColor(Asset.red.swiftUIColor)
            } else {
                TextField("", text: $viewModel.textCode)
                .placeholder(when: viewModel.textCode.isEmpty) {
                    Text("").foregroundColor(Asset.text.swiftUIColor)
                }
                .foregroundColor(Asset.text.swiftUIColor)
            }
        }
        .frame(height: 48)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(viewModel.errorCode ? Asset.red.swiftUIColor : Asset.border.swiftUIColor, lineWidth: 1)
        )
        .font(FontFamily.Poppins.regular.swiftUIFont(size: 20))
        .padding(.vertical, 12)
        .multilineTextAlignment(.center)
        .accentColor(Asset.text.swiftUIColor)
        .keyboardType(.numberPad)
        .textContentType(.oneTimeCode)
        .onReceive(Just(viewModel.textCode)) { _ in
            viewModel.limitText(4)
        }
    }
}

struct CodeView_Previews: PreviewProvider {
    static var previews: some View {
        CodeView(phoneNumber: "+79999999999")
    }
}
