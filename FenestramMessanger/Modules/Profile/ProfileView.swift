//
//  ProfileView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI
import Combine

struct ProfileView: View {
    @State var flag = false
    @State private var selection: String? = nil
    @State private var keyboardHeight: CGFloat = 0
    
    //@State private var image: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Color("border")] , startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    var body: some View {
        ZStack {
            Color("thema").ignoresSafeArea()
            VStack {
                VStack {
                    getHeader()
                }.padding(.top, 10)
                VStack  {
                    
                    getImage()
                    Spacer()
                        .frame(height: 30.0)
                    getName()
                    Spacer()
                        .frame(height: 30.0)
                    getNicName()
                    getBirthday()
                    getEmail()
                    Spacer()
                        .frame(height: 40.0)
                    getButton()
                }
                .padding()
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .padding(.bottom, keyboardHeight/4)
                .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
                
                Spacer()
            }
            
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .navigationBarHidden(true)
        
    }
    
//    private func getHeader() -> some View {
//        Text("Добро пожаловать в FENESTRAM!")
//            .font(.title)
//            .foregroundColor(.white)
//            .multilineTextAlignment(.center)
//    }
    private func getHeader() -> some View {
        VStack(alignment: .trailing){
            NavigationLink() {
                SettingsView()
            } label: {
                Image(systemName: "gearshape").foregroundColor(Color("blue"))
            }
//            Button(action: {
//                selection = "A"
//            }) {
//                Image(systemName: "gearshape")
//
//            }
        }//.frame(width: UIScreen.screenWidth - 30)
            .padding(.leading, UIScreen.screenWidth - 60)
    }
    
    private func getImage() -> some View {
        ZStack (alignment: .trailing){
            Image(uiImage: viewModel.image ?? UIImage(named: "photo")!)
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
                .background(LinearGradient(gradient: Gradient(colors: [Color("blue")]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(40)
                .frame(width: 50.0, height: 100.0, alignment: .center)
                .actionSheet(isPresented: $viewModel.showSheet) {
                    ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [
                        .default(Text("Photo Library")) {
                            viewModel.showImagePicker = true
                            self.sourceType = .photoLibrary
                        },
                        .default(Text("Camera")) {
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
        VStack(alignment: .center) {
            Text(viewModel.name)
                .font(.system(size: 28))
                .foregroundColor(Color.white)
                .bold()
            Spacer().frame(height: 3.0 )
        }
    }
    
    private func getNicName() -> some View {
        VStack(alignment: .leading){
            Text("Никнейм")
                .font(.headline)
                .foregroundColor(Color("text"))
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
                    .foregroundColor(Color("text"))
                    .multilineTextAlignment(.leading)
                    .accentColor(Color("text"))
                    .keyboardType(.default)
                }
            }.background(border)
        }
    }
    
    private func getBirthday() -> some View {
        VStack(alignment: .leading){
            Text("Дата рождения")
                .font(.headline)
                .foregroundColor(Color("text"))
            Spacer().frame(height: 3.0 )
            ZStack {
                HStack (spacing: 5) {
                    DatePickerTextField(placeholder: "", date: $viewModel.birthday)
                        .padding(.vertical, 12)
                        .padding(.leading, 10)
                        .padding(.trailing, 5)
                        .frame( height: 46.0)
                        .font(.system(size: 20))
                }
            }.background(border)
        }
    }
    
    private func getEmail() -> some View {
        VStack(alignment: .leading){
            Text("Email")
                .font(.headline)
                .foregroundColor(Color("text"))
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
                    .foregroundColor(Color("text"))
                    .multilineTextAlignment(.leading)
                    .accentColor(Color("text"))
                    .keyboardType(.emailAddress)
                    .ignoresSafeArea(.keyboard)
                }
            }.background(border)
        }
    }
    
    private func getButton() -> some View {
        
        HStack {
            Button(action: {
                selection = "A"
            }) {
                Text("Отменить")
                    .frame(width: UIScreen.screenWidth/2 - 30, height: 45.0)
                    .foregroundColor(.white)
                    .background(Color("blue"))
                    .cornerRadius(6)
            }
            
            Spacer()

            Button(action: {
                selection = "A"
            }) {
                Text("Готово")
                .frame(width: UIScreen.screenWidth/2 - 30, height: 45.0)
                .foregroundColor(.white)
                .background(Color("blue") )
                .cornerRadius(6)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
