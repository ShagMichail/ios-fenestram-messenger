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
    @State private var keyboardHeight: CGFloat = 0
    let maskPhone = "+X XXX XXX-XX-XX"
    @StateObject private var viewModel: ViewModel
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        
        ZStack {
            Asset.thema.swiftUIColor
                .ignoresSafeArea()
            
            getBase()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Asset.border.swiftUIColor] , startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    private func getBase() -> some View {
        VStack(alignment: .center) {
            Text("FENESTRAM")
                .font(.title)
                .foregroundColor(.white)
            Spacer()
                .frame(height: 100.0)
            VStack(alignment: .leading){
                Text("Номер телефона")
                    .font(.headline)
                    .foregroundColor(Asset.text.swiftUIColor)
                
                Spacer().frame(height: 3.0 )
                
                TextField("", text: Binding<String>(get: {
                    format(with: self.maskPhone, phone: viewModel.textPhone)
                }, set: {
                    viewModel.textPhone = $0
                }))
                .placeholder(when: viewModel.textPhone.isEmpty) {
                    Text("+7").foregroundColor(Asset.text.swiftUIColor)
                    
                }
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .foregroundColor(Asset.text.swiftUIColor)
                .background(border)
                .multilineTextAlignment(.leading)
                .accentColor(Asset.text.swiftUIColor)
                .keyboardType(.phonePad)

            }
            
            Spacer()
                .frame(height: 83.0)

            NavigationLink(isActive: $viewModel.flag) {
                CodeView().navigationBarHidden(true)
            } label: {
                Button(action: {
                    viewModel.checkCode()
                }) {
                    Text("Отправить код")
                        .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                        .foregroundColor(.white)
                        .background((viewModel.textPhone.count == 18 ) ? Asset.blue.swiftUIColor : Asset.buttonDis.swiftUIColor)
                        .cornerRadius(6)
                }
            }
            .disabled(viewModel.textPhone.count != 18)
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
