//
//  Phone.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 05.07.2022.
//

import SwiftUI
import iPhoneNumberField
import Introspect
import Combine

struct PhoneView: View {
    
    
    //MARK: - Properties
    
    @State private var keyboardHeight: CGFloat = 0

    @AppStorage ("isColorThema") var isColorThema: Bool?
    @AppStorage("isPhoneUser") var isPhoneUser: String?
    
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                Asset.background.swiftUIColor
                    .ignoresSafeArea()
                
                getBase()
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationBarHidden(true)
        }
    }
    
    
    //MARK: - Views
    
    private func getBase() -> some View {
        VStack(alignment: .center) {
            Text("hoolichat")
                .font(FontFamily.Montserrat.bold.swiftUIFont(size: 32))
                .foregroundColor(.white)
            
            Spacer()
                .frame(height: 100.0)
            
            VStack(alignment: .leading){
                Text(L10n.PhoneView.phoneNumber)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    .foregroundColor(Asset.text.swiftUIColor)
                
                Spacer().frame(height: 3.0 )
                
                getTextField()
            }
            
            Spacer()
                .frame(height: 83.0)
            
            getButton()
        }
        .padding()
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
    
    private func getButton() -> some View {
        NavigationLink(isActive: $viewModel.numberCount) {
            CodeView(phoneNumber: viewModel.formattedPhone).navigationBarHidden(true)
        } label: {
            Button(action: {
                viewModel.checkCode()
                if viewModel.numberCount {
                    isPhoneUser = viewModel.formattedPhone
                }
            }) {
                Text(L10n.PhoneView.sendCode)
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                    .background(viewModel.checkPhone() ?
                                (isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor) : Asset.buttonDis.swiftUIColor)
                    .cornerRadius(6)
            }
        }
        .disabled(!viewModel.checkPhone())
    }
    
    private func getTextField() -> some View {
        VStack {
            iPhoneNumberField("", text: $viewModel.textPhone, configuration: { textField in
                textField.keyboardType = .numberPad
            })
                .flagHidden(false)
                .prefixHidden(false)
                .foregroundColor(Asset.text.swiftUIColor)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                .multilineTextAlignment(.leading)
                .accentColor(Asset.text.swiftUIColor)
                .textContentType(.telephoneNumber)
                .padding(.horizontal, 16)
        }
        .frame(height: 48)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Asset.border.swiftUIColor, lineWidth: 1)
        )
        .padding(.vertical, 12)
    }
}

struct PhoneView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneView()
    }
}
