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
    @State private var keyboardHeight: CGFloat = 0
    let maskCode = "XXXXX"
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        
        ZStack {
            Color("thema").ignoresSafeArea()
            getBase()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Color("border")], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    var borderError: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Color.red], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    private func getBase() -> some View {
        VStack(alignment: .center) {
            Text("FENESTRAM")
                .font(.title)
                .foregroundColor(.white)
            Spacer()
                .frame(height: 100.0)
            VStack (alignment: .trailing){
                VStack(alignment: .leading){
                    Text("Введите код из СМС")
                        .font(.headline)
                        .foregroundColor(Color("text"))
                    Spacer().frame(height: 3.0 )
                    
                    if viewModel.errorCode {
                        TextField("", text: Binding<String>(get: {
                            format(with: self.maskCode, phone: viewModel.textCode)
                        }, set: {
                            viewModel.textCode = $0
                        }))
                        .placeholder(when: viewModel.textCode.isEmpty) {
                            Text("").foregroundColor(Color.red)
                        }
                        .onChange(of: viewModel.textCode) { newValue in viewModel.changeIncorrect() }
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .foregroundColor(Color.red)
                        .multilineTextAlignment(.center)
                        .background(borderError)
                        .multilineTextAlignment(.leading)
                        .accentColor(Color("text"))
                        .keyboardType(.numberPad)
//                        .introspectTextField { (textField) in
//                            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
//                            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//                            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
//                            doneButton.tintColor = .black
//                            toolBar.items = [flexButton, doneButton]
//                            toolBar.setItems([flexButton, doneButton], animated: true)
//                            textField.inputAccessoryView = toolBar
//                        }
                    } else {
                        TextField("", text: Binding<String>(get: {
                            format(with: self.maskCode, phone: viewModel.textCode)
                        }, set: {
                            viewModel.textCode = $0
                        }))
                        .placeholder(when: viewModel.textCode.isEmpty) {
                            Text("").foregroundColor(Color("text"))
                        }
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        
                        .foregroundColor(Color("text"))
                        .multilineTextAlignment(.center)
                        .background(border)
                        .multilineTextAlignment(.leading)
                        .accentColor(Color("text"))
                        .keyboardType(.numberPad)
//
//                        .introspectTextField { (textField) in
//                            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
//                            let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//                            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
//                            doneButton.tintColor = .black
//                            toolBar.items = [flexButton, doneButton]
//                            toolBar.setItems([flexButton, doneButton], animated: true)
//                            textField.inputAccessoryView = toolBar
//                        }
                    }
                }
                HStack {
                    if viewModel.errorCode {
                        Text("Неверный код")
                            .foregroundColor(Color.red)
                            .font(.system(size: 15))
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Отправить заново?")
                                .font(.system(size: 15))
                                .foregroundColor(Color.red)
                        }
                    } else {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Отправить заново?")
                                .font(.system(size: 15))
                                .foregroundColor(Color("blue"))
                        }
                    }
                }
            }

            Spacer()
                .frame(height: 50.0)
            
            NavigationLink(isActive: $viewModel.flag) {
                AccountView().navigationBarHidden(true)
            } label: {
                Button(action: {
                    viewModel.checkCode()
                }) {
                    Text("Готово")
                        .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                        .foregroundColor(.white)
                        .background((viewModel.textCode.count == 5 && viewModel.errorCode == false) ? Color("blue") : Color("buttonDis"))
                        .cornerRadius(6)
                }
            }
            .disabled(viewModel.textCode.count != 5 || viewModel.errorCode)
        }
        .padding()
        .ignoresSafeArea(.keyboard, edges: .bottom)
                .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
    }
}

struct CodeView_Previews: PreviewProvider {
    static var previews: some View {
        CodeView()
    }
}
