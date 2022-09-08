//
//  NewContactView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 13.07.2022.
//

import SwiftUI
import iPhoneNumberField
//import AlertToast

struct NewContactView: View {
    
    
    //MARK: - Properties
    
    var borderName: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder((viewModel.isTappedGlobal == true && viewModel.name.count == 0) ?
                          LinearGradient(colors: [Asset.red.swiftUIColor], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Asset.border.swiftUIColor], startPoint: .topLeading, endPoint: .bottomTrailing))
        
    }
    
    var borderPhone: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder((viewModel.isTappedGlobal == true && (viewModel.textPhone.count == 0 || viewModel.textPhone.count != 16)) ?
                          LinearGradient(colors: [Asset.red.swiftUIColor], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Asset.border.swiftUIColor], startPoint: .topLeading, endPoint: .bottomTrailing))
        
    }
    
    var borderLastName: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Asset.border.swiftUIColor], startPoint: .topLeading, endPoint: .bottomTrailing))
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
        Text(L10n.NewContactView.title)
            .foregroundColor(Color.white)
            .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
    }
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @StateObject private var viewModel: ViewModel
    
    @State private var showSuccessToast: Bool = false
    @State private var showErrorToast: Bool = false
    
    let updateCompletion: (() -> ())?
    
    init(updateCompletion: (() -> ())?) {
        _viewModel = StateObject(wrappedValue: ViewModel())
        self.updateCompletion = updateCompletion
    }
    
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Asset.background.swiftUIColor
                .ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .foregroundColor(Asset.dark1.swiftUIColor)
                    .frame(height: 100.0)
                    .ignoresSafeArea()
                
                Spacer()
            }
            
            VStack {
                getName()
                    .padding(.bottom, 24)
                
                getLastName()
                    .padding(.bottom, 24)
                
                getPhone()
                    .padding(.bottom, 64)
                
                getButton()
                
                Spacer()
            }
            .padding()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: title)
        .navigationBarItems(leading: btnBack)
//        .toast(isPresenting: $showErrorToast, duration: 2, tapToDismiss: true) {
//            AlertToast(displayMode: .alert, type: .error(Asset.red.swiftUIColor), title: "")
//        }
    }
    
    
    //MARK: - Views
    
    private func getName() -> some View {
        VStack (alignment: .trailing){
            VStack(alignment: .leading){
                Text(L10n.NewContactView.Name.title)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    .foregroundColor((viewModel.name.count == 0 && viewModel.isTappedGlobal == true) ? Asset.red.swiftUIColor : Asset.text.swiftUIColor)
                
                Spacer().frame(height: 3.0 )
                
                ZStack {
                    HStack (spacing: 5){
                        TextField("", text: $viewModel.name) { (status) in
                            if status {
                                viewModel.isTappedName = true
                                viewModel.isTappedGlobal = true
                            } else {
                                viewModel.isTappedName = false
                            }
                        } onCommit: {
                            viewModel.isTappedName = false
                        }
                        .placeholder(when: viewModel.name.isEmpty && viewModel.isTappedName == false) {
                            Text(L10n.NewContactView.Name.placeholder)
                                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                                .foregroundColor(Asset.text.swiftUIColor.opacity(0.87))
                            
                        }
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 12)
                        .padding(.leading, 10)
                        .padding(.trailing, 5)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                        .foregroundColor(Asset.text.swiftUIColor)
                        .multilineTextAlignment(.leading)
                        .accentColor(Asset.text.swiftUIColor)
                        .keyboardType(.default)
                    }
                }.background(borderName)
            }
            if viewModel.name.count == 0 && viewModel.isTappedGlobal == true {
                HStack {
                    Text(L10n.NewContactView.Name.error)
                        .foregroundColor(Asset.red.swiftUIColor)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 15))
                }
            }
        }
    }
    
    private func getLastName() -> some View {
        VStack(alignment: .leading){
            Text(L10n.NewContactView.LastName.title)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                .foregroundColor(Asset.text.swiftUIColor)
            
            Spacer().frame(height: 3.0 )
            
            ZStack {
                HStack (spacing: 5) {
                    TextField("", text: $viewModel.lastName) { (status) in
                        if status {
                            viewModel.isTappedLastName = true
                        } else {
                            viewModel.isTappedLastName = false
                        }
                    } onCommit: {
                        viewModel.isTappedLastName = false
                    }
                    .placeholder(when: viewModel.lastName.isEmpty) {
                        Text(L10n.NewContactView.LastName.placeholder)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                            .foregroundColor(Asset.text.swiftUIColor.opacity(0.87))
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    .foregroundColor(Asset.text.swiftUIColor)
                    .multilineTextAlignment(.leading)
                    .accentColor(Asset.text.swiftUIColor)
                    .keyboardType(.default)
                }
            }.background(borderLastName)
        }
    }
    
    private func getPhone() -> some View {
        VStack (alignment: .trailing) {
            VStack(alignment: .leading) {
                Text(L10n.NewContactView.PhoneNumber.title)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    .foregroundColor(((viewModel.textPhone.count == 0 &&  viewModel.isTappedGlobal == true) || (viewModel.textPhone.count != 16 && viewModel.textPhone.count != 0)) ? Asset.red.swiftUIColor : Asset.text.swiftUIColor)
                
                Spacer().frame(height: 3.0 )
                
                iPhoneNumberField("", text: $viewModel.textPhone, configuration: { textField in
                    textField.keyboardType = .numberPad
                    textField.font = FontFamily.Poppins.regular.font(size: 14)
                })
                .flagHidden(false)
                .prefixHidden(false)
                .foregroundColor(((viewModel.textPhone.count == 0 &&  viewModel.isTappedGlobal == true) || (viewModel.textPhone.count != 16 && viewModel.textPhone.count != 0)) ? Asset.red.swiftUIColor : Asset.text.swiftUIColor.opacity(0.87))
                .accentColor(Asset.text.swiftUIColor)
                .multilineTextAlignment(.leading)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(borderPhone)
                .placeholder(when: viewModel.textPhone.isEmpty) {
                    Text(L10n.NewContactView.PhoneNumber.placeholder)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                        .foregroundColor(((viewModel.textPhone.count == 0 &&  viewModel.isTappedGlobal == true) || (viewModel.textPhone.count != 16 && viewModel.textPhone.count != 0)) ? Asset.red.swiftUIColor : Asset.text.swiftUIColor)
                        .padding(.leading, 48)
                    
                }
            }
            
            if viewModel.textPhone.count == 0 && viewModel.isTappedGlobal == true {
                HStack {
                    Text(L10n.NewContactView.PhoneNumber.emptyError)
                        .foregroundColor(Asset.red.swiftUIColor)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 15))
                }
            }
            
            if viewModel.textPhone.count != 16 && viewModel.textPhone.count != 0 && viewModel.isTappedGlobal == true {
                HStack {
                    Text(L10n.NewContactView.PhoneNumber.incorrectError)
                        .foregroundColor(Asset.red.swiftUIColor)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 15))
                }
            }
        }
    }
    
    private func getButton() -> some View {
        VStack {
            Button(action: {
                viewModel.addContact { success in
                    if success {
                        showSuccessToast = true
                    } else {
                        showErrorToast = true
                    }
                }
            }) {
                Text(L10n.General.done)
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                    .background( (viewModel.name.count != 0 && (viewModel.textPhone.count != 0 && viewModel.textPhone.count == 16 ) ? (isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor) : Asset.dark2.swiftUIColor))
                    .cornerRadius(6)
            }.disabled((viewModel.name.count == 0 || (viewModel.textPhone.count == 0 && viewModel.textPhone.count != 16 )))
        }
    }
}

struct NewContactView_Previews: PreviewProvider {
    static var previews: some View {
        NewContactView(updateCompletion: nil)
    }
}
