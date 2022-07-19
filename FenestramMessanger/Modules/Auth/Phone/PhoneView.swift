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
    @AppStorage ("isColorThema") var isColorThema: Bool?
    @State private var keyboardHeight: CGFloat = 0
    let maskPhone = "+X XXX XXX-XX-XX"
    @StateObject private var viewModel: ViewModel
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Asset.thema.swiftUIColor
                    .ignoresSafeArea()
                
                getBase()
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationBarHidden(true)
        }
    }
    
    private func getBase() -> some View {
        VStack(alignment: .center) {
            Text("FENESTRAM")
                .font(FontFamily.Montserrat.semiBold.swiftUIFont(size: 18))
                .foregroundColor(.white)
            
            Spacer()
                .frame(height: 100.0)
            
            VStack(alignment: .leading){
                Text(L10n.PhoneView.phoneNumber)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    .foregroundColor(Asset.text.swiftUIColor)
                
                Spacer().frame(height: 3.0 )
                
                VStack {
                    TextField("", text: Binding<String>(get: {
                        format(with: self.maskPhone, phone: viewModel.textPhone)
                    }, set: {
                        viewModel.textPhone = $0
                    }))
                    .placeholder(when: viewModel.textPhone.isEmpty) {
                        Text("+7").foregroundColor(Asset.text.swiftUIColor)
                    }
                    .foregroundColor(Asset.text.swiftUIColor)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    .multilineTextAlignment(.leading)
                    .accentColor(Asset.text.swiftUIColor)
                    .keyboardType(.phonePad)
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
            
            Spacer()
                .frame(height: 83.0)
            
            NavigationLink(isActive: $viewModel.numberCount) {
                CodeView(phoneNumber: viewModel.textPhone).navigationBarHidden(true)
            } label: {
                Button(action: {
                    viewModel.checkCode()
                }) {
                    Text(L10n.PhoneView.sendCode)
                        .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                        .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                        .foregroundColor(.white)
                        .background((viewModel.textPhone.count == 16) ?
                                    (isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor) : Asset.buttonDis.swiftUIColor)
                        .cornerRadius(6)
                }
            }
            .disabled(viewModel.textPhone.count != 16)
        }
        .padding()
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
}

struct PhoneView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneView()
    }
}
