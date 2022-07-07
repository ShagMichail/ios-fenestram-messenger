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
    let maskPhone = "+X (XXX) XXX-XX-XX"
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        
        ZStack {
            
            Color("thema").ignoresSafeArea()
            
            getBase()
            
        }
        
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Color("border")] , startPoint: .topLeading, endPoint: .bottomTrailing))
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
                    .foregroundColor(Color("text"))
                
                Spacer().frame(height: 3.0 )
                
                TextField("", text: Binding<String>(get: {
                    format(with: self.maskPhone, phone: viewModel.textPhone)
                }, set: {
                    viewModel.textPhone = $0
                }))
                .placeholder(when: viewModel.textPhone.isEmpty) {
                    Text("+7").foregroundColor(Color("text"))
                    
                }
                //.onChange(of: viewModel.textCode) { newValue in viewModel.changeIncorrect() }
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                
                .foregroundColor(Color("text"))
                .background(border)
                .multilineTextAlignment(.leading)
                .accentColor(Color("text"))
                .keyboardType(.phonePad)
                .introspectTextField { (textField) in
                    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                    let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
                    doneButton.tintColor = .black
                    toolBar.items = [flexButton, doneButton]
                    toolBar.setItems([flexButton, doneButton], animated: true)
                    textField.inputAccessoryView = toolBar
                }
                
                //                iPhoneNumberField(nil, text: $viewModel.textPhone)
                //                    .flagHidden(true)
                //                    .prefixHidden(false)
                //                    .placeholderColor(Color("thema"))
                //                    .font(UIFont(size: 18))
                //                    .maximumDigits(10)
                //                    .foregroundColor(Color("text"))
                //                //.formatted(true)
                //                    .accentColor(Color("text"))
                //                    .padding(.vertical, 12)
                //                    .padding(.horizontal, 16)
                //                    .background(border)
                
                //                    .introspectTextField { (textField) in
                //                        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                //                        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                //                        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
                //                        doneButton.tintColor = .black
                //                        toolBar.items = [flexButton, doneButton]
                //                        toolBar.setItems([flexButton, doneButton], animated: true)
                //                        textField.inputAccessoryView = toolBar
                //                    }
                
                //не настраивается цвет
            }
            Spacer()
                .frame(height: 83.0)
            
            //            NavigationLink(destination: CodeView().navigationBarHidden(true)) {
            //                SendButtonView()
            //            }
            
            NavigationLink(isActive: $viewModel.flag) {
                CodeView().navigationBarHidden(true)
            } label: {
                Button(action: {
                    viewModel.checkCode()
                }) {
                    
                    Text("Отправить код")
                    
                        .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    
                        .foregroundColor(.white)
                        .background((viewModel.textPhone.count == 18 ) ? Color("blue") : Color("buttonDis"))
                        .cornerRadius(6)
                    
                }
            }
            
            .disabled(viewModel.textPhone.count != 18)
            
        }
        .padding()
        .ignoresSafeArea(.keyboard, edges: .bottom)
        //.padding(.bottom, -100)
        // 3.
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
    
}

//struct SendButtonView: View {
//    var body: some View {
//        Text("Отправить код")
//            .frame(width: UIScreen.screenWidth - 30, height: 45.0)
//
//            .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color.blue))
//            .foregroundColor(Color.white)
//        //.foregroundColor(Color.blue)
//
//    }
//}

struct PhoneView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneView()
    }
}
