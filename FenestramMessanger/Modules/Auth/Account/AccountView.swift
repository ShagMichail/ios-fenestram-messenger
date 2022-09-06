//
//  Account.swift
//  TFN
//
//  Created by Михаил Шаговитов on 05.07.2022.
//

import SwiftUI
import Introspect
import Combine

struct AccountView: View {
    
    
    //MARK: - Properties
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var keyboardHeight: CGFloat = 0
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Asset.border.swiftUIColor] , startPoint: .topLeading, endPoint: .bottomTrailing))
    }
   
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Asset.thema.swiftUIColor
                .ignoresSafeArea()
            
            VStack  {
                getHeader()
                Spacer()
                    .frame(height: 40.0)
                getImage()
                Spacer()
                    .frame(height: 30.0)
                getName()
                getNicName()
                getBirthday()
                getEmail()
                Spacer()
                getButton()
            }
            .padding()
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .padding(.bottom, keyboardHeight/4)
            .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
            
            if viewModel.presentAlert {
                AlertView(show: $viewModel.presentAlert, textTitle: $viewModel.textTitleAlert, text: $viewModel.textAlert)
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        
    }
    
    
    //MARK: - Views
    
    private func getHeader() -> some View {
        Text(L10n.AccountView.title)
            .frame(width: UIScreen.screenWidth / 2)
            .font(FontFamily.Montserrat.semiBold.swiftUIFont(size: 18))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
    }
    
    private func getImage() -> some View {
        ZStack (alignment: .trailing){
            Image(uiImage: viewModel.image ?? Asset.photo.image)
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            Button(action: {
                viewModel.showSheet = true
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.title)
                }
                .padding(.all, 5.0)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [(isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(40)
                .frame(width: 50.0, height: 100.0, alignment: .center)
                .actionSheet(isPresented: $viewModel.showSheet) {
                    ActionSheet(title: Text(L10n.ProfileView.SelectPhoto.title), message: Text(L10n.ProfileView.SelectPhoto.message), buttons: [
                        .default(Text(L10n.ProfileView.SelectPhoto.photoLibrary)) {
                            viewModel.showImagePicker = true
                            self.sourceType = .photoLibrary
                        },
                        .default(Text(L10n.ProfileView.SelectPhoto.camera)) {
                            viewModel.showImagePicker = true
                            self.sourceType = .camera
                        },
                        .cancel()
                    ])
                }
            }
            .padding(.bottom, -84)
            .padding(.trailing, -7)
            
        }.sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(image: $viewModel.image, isShown: $viewModel.showImagePicker, sourceType: self.sourceType)}
    }
    
    private func getName() -> some View {
        VStack(alignment: .leading){
            Text(L10n.AccountView.name)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                .foregroundColor(Asset.text.swiftUIColor)
            Spacer().frame(height: 3.0)
            
            ZStack {
                HStack (spacing: 5){
                    TextField("", text: $viewModel.name) { (status) in
                        if status {
                            viewModel.isTappedName = true
                        } else {
                            viewModel.isTappedName = false
                        }
                    } onCommit: {
                        viewModel.isTappedName = false
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                    .foregroundColor(Asset.text.swiftUIColor)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    .multilineTextAlignment(.leading)
                    .accentColor(Asset.text.swiftUIColor)
                    .keyboardType(.default)
                    .textContentType(.name)
                    
                    if viewModel.isTappedName == false && viewModel.name.count != 0 {
                        Button(action: {
                            print("ddd")
                        }, label: {
                            Image(systemName: "checkmark").foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                        })
                        .padding(.trailing, 10.0)
                        .disabled(true)
                    }
                }
            }.background(border)
        }
    }
    
    private func getNicName() -> some View {
        VStack(alignment: .leading){
            Text(L10n.AccountView.nickname)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                .foregroundColor(Asset.text.swiftUIColor)
            Spacer().frame(height: 3.0 )
            ZStack {
                HStack (spacing: 5) {
                    TextField("", text: $viewModel.nicName) { (status) in
                        if status {
                            viewModel.isTappedNicName = true
                        } else {
                            viewModel.isTappedNicName = false
                        }
                    } onCommit: {
                        viewModel.isTappedNicName = false
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                    .foregroundColor(Asset.text.swiftUIColor)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    .multilineTextAlignment(.leading)
                    .accentColor(Asset.text.swiftUIColor)
                    .keyboardType(.default)
                    .textContentType(.nickname)
                    
                    if viewModel.isTappedNicName == false && viewModel.nicName.count != 0 {
                        Button(action: {
                            print("ddd")
                        }, label: {
                            Image(systemName: "checkmark")
                                .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                        })
                        .padding(.trailing, 10.0)
                        .disabled(true)
                    }
                }
            }.background(border)
        }
    }
    
    private func getBirthday() -> some View {
        VStack(alignment: .leading){
            Text(L10n.AccountView.birthday)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                .foregroundColor(Asset.text.swiftUIColor)
            Spacer().frame(height: 3.0 )
            ZStack {
                HStack (spacing: 5) {
                    DatePickerTextField(placeholder: "", date: $viewModel.birthday)
                        .padding(.vertical, 12)
                        .padding(.leading, 10)
                        .padding(.trailing, 5)
                        .frame(height: 46.0)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    
                    if viewModel.birthday != nil {
                        Button(action: {
                            print("ddd")
                        }, label: {
                            Image(systemName: "checkmark")
                                .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                        })
                        .padding(.trailing, 10.0)
                        .disabled(true)
                    }
                }
            }.background(border)
        }
    }
    
    private func getEmail() -> some View {
        VStack(alignment: .leading) {
            Text(L10n.AccountView.email)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                .foregroundColor(Asset.text.swiftUIColor)
            Spacer().frame(height: 3.0 )
            ZStack {
                HStack (spacing: 5) {
                    TextField("", text: $viewModel.textEmail) { (status) in
                        if status {
                            viewModel.isTappedEmail = true
                        } else {
                            viewModel.isTappedEmail = false
                        }; onCommit: do {
                            
                            if viewModel.textFieldValidatorEmail(viewModel.textEmail) {
                                viewModel.isEmailValid = true
                                viewModel.textEmailOk = true
                            } else {
                                viewModel.isEmailValid = false
                                viewModel.textEmailOk = false
                                
                            }
                        }
                    }
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 12)
                    .padding(.leading, 10)
                    .padding(.trailing, 5)
                    .foregroundColor(Asset.text.swiftUIColor)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    .multilineTextAlignment(.leading)
                    .accentColor(Asset.text.swiftUIColor)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .ignoresSafeArea(.keyboard)
                    
                    if viewModel.isEmailValid && !viewModel.isTappedEmail  {
                        Button(action: {
                            print("ddd")
                        }, label: {
                            Image(systemName: "checkmark")
                                .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                        })
                        .padding(.trailing, 10.0)
                        .disabled(true)
                    }
                }
            }.background(border)
        }
    }
    
    private func getButton() -> some View {
        VStack {
            Button(action: {
                viewModel.saveInfo()
            }) {
                Text(L10n.General.done)
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                    .background( (viewModel.name.count != 0 && viewModel.nicName.count != 0 && viewModel.birthday != nil && viewModel.textEmailOk) ? (isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor) : Asset.buttonDis.swiftUIColor)
                    .cornerRadius(6)
            }.disabled((viewModel.name.count == 0 || viewModel.nicName.count == 0 || viewModel.birthday == nil || viewModel.textEmailOk == false))
            
            Button(action: {
                viewModel.isAlreadySetProfile = true
            }) {
                Text(L10n.General.skip)
                    .font(FontFamily.Poppins.medium.swiftUIFont(size: 16))
                    .foregroundColor(Asset.next.swiftUIColor)
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
