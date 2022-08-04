//
//  NewContactView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 13.07.2022.
//

import SwiftUI

struct NewContactView: View {
    //MARK: Проперти
    let maskPhone = "+X XXX XXX-XX-XX"
    
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
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    //MARK: Боди
    var body: some View {
        ZStack {
            Asset.thema.swiftUIColor
                .ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .foregroundColor(Asset.buttonDis.swiftUIColor)
                    .frame(width: UIScreen.screenWidth, height: 100.0)
                    .ignoresSafeArea()
                Spacer()
            }
            VStack {
                getName()
                getLastName()
                getPhone()
                Spacer().frame(height: 40.0)
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
    }
    //MARK: Получаем все вью
    
    private func getName() -> some View {
        VStack (alignment: .trailing){
            VStack(alignment: .leading){
                Text(L10n.NewContactView.Name.title)
                    .font(.headline)
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
                            Text(L10n.NewContactView.Name.placeholder).foregroundColor(Asset.text.swiftUIColor).contrast(0)
                            
                        }
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.vertical, 12)
                        .padding(.leading, 10)
                        .padding(.trailing, 5)
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
                .font(.headline)
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
                        Text(L10n.NewContactView.LastName.placeholder).foregroundColor(Asset.text.swiftUIColor).contrast(0)
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
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
                    .font(.headline)
                    .foregroundColor(((viewModel.textPhone.count == 0 &&  viewModel.isTappedGlobal == true) || (viewModel.textPhone.count != 16 && viewModel.textPhone.count != 0)) ? Asset.red.swiftUIColor : Asset.text.swiftUIColor)
                
                Spacer().frame(height: 3.0 )
                
                TextField("", text: Binding<String>(get: {
                    format(with: self.maskPhone, phone: viewModel.textPhone)
                }, set: {
                    viewModel.textPhone = $0
                })) { (status) in
                    if status {
                        viewModel.isTappedPhoneNumber = true
                        viewModel.isTappedGlobal = true
                    } else {
                        viewModel.isTappedPhoneNumber = false
                    }
                } onCommit: {
                    viewModel.isTappedPhoneNumber = false
                }
                .placeholder(when: viewModel.textPhone.isEmpty && viewModel.isTappedPhoneNumber == false) {
                    Text(L10n.NewContactView.PhoneNumber.placeholder).foregroundColor(((viewModel.textPhone.count == 0 &&  viewModel.isTappedGlobal == true) || (viewModel.textPhone.count != 16 && viewModel.textPhone.count != 0)) ? Asset.red.swiftUIColor : Asset.text.swiftUIColor)
                    
                }
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .foregroundColor(((viewModel.textPhone.count == 0 &&  viewModel.isTappedGlobal == true) || (viewModel.textPhone.count != 16 && viewModel.textPhone.count != 0)) ? Asset.red.swiftUIColor : Asset.text.swiftUIColor)
                .background(borderPhone)
                .multilineTextAlignment(.leading)
                .accentColor(Asset.text.swiftUIColor)
                .keyboardType(.phonePad)
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
                
            }) {
                Text(L10n.General.done)
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                    .background( (viewModel.name.count != 0 && (viewModel.textPhone.count != 0 && viewModel.textPhone.count == 16 ) ? (isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor) : Asset.buttonDis.swiftUIColor))
                    .cornerRadius(6)
            }.disabled((viewModel.name.count == 0 || viewModel.textPhone.count != 16))
        }
    }
}

struct NewContactView_Previews: PreviewProvider {
    static var previews: some View {
        NewContactView()
    }
}
