//
//  Phone.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 05.07.2022.
//

import SwiftUI
import iPhoneNumberField
import Introspect

struct PhoneView: View {
    
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
                
                iPhoneNumberField("", text: $viewModel.textPhone)
                    .flagHidden(true)
                    .prefixHidden(false)
                    .placeholderColor(Color("text"))
                    .font(UIFont(size: 18))
                    .maximumDigits(10)
                    .foregroundColor(Color("text"))
                //.formatted(true)
                    .accentColor(Color("text"))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(border)
                    
                    .introspectTextField { (textField) in
                        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textField.frame.size.width, height: 44))
                        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(textField.doneButtonTapped(button:)))
                        doneButton.tintColor = .black
                        toolBar.items = [flexButton, doneButton]
                        toolBar.setItems([flexButton, doneButton], animated: true)
                        textField.inputAccessoryView = toolBar
                    }
                
                //не настраивается цвет
            }
            Spacer()
                .frame(height: 83.0)
            
            NavigationLink(destination: CodeView().navigationBarHidden(true)) {
                SendButtonView()
            }
        }
        .padding(.top, 100.0)
        .padding()
        .keyboardAdaptive()
    }
    
}

struct SendButtonView: View {
    var body: some View {
        Text("Отправить код")
            .frame(width: UIScreen.screenWidth - 30, height: 45.0)
        
            .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color.blue))
            .foregroundColor(Color.white)
        //.foregroundColor(Color.blue)
        
    }
}

struct PhoneView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneView()
    }
}
