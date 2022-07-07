//
//  Account.swift
//  TFN
//
//  Created by Михаил Шаговитов on 05.07.2022.
//

import SwiftUI
import Introspect
import Combine

struct Contact {
    let id = UUID()
    var name = ""
    var dob: Date? = nil
    var hiredDate: Date? = nil
}

struct AccountView: View {
    //@State var text = ""
    @State private var keyboardHeight: CGFloat = 0
    @State private var contact = Contact()
    @State private var image: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var border: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Color("border")] , startPoint: .topLeading, endPoint: .bottomTrailing))
    }
    
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        
        ZStack {
            Color("thema").ignoresSafeArea()
            
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
            }.padding()
               
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .padding(.bottom, keyboardHeight/4)
                        // 3.
                        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
                
                
                
        }
        
    }
    
    private func getHeader() -> some View {
        Text("Добро пожаловать в FENESTRAM!")
            .font(.title)
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
           // .padding(.top, 40.0)
    }
    
    private func getImage() -> some View {
        ZStack (alignment: .trailing){
            Image(uiImage: image ?? UIImage(named: "photo")!)
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
            ImagePicker(image: self.$image, isShown: $viewModel.showImagePicker, sourceType: self.sourceType)}
    }
    
    private func getName() -> some View {
        VStack(alignment: .leading){
            
            Text("Имя")
                .font(.headline)
                .foregroundColor(Color("text"))
            Spacer().frame(height: 3.0 )
            
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
                    
                    .foregroundColor(Color("text"))
                    .multilineTextAlignment(.leading)
                    
                    .accentColor(Color("text"))
                    .keyboardType(.default)
                    
                    if viewModel.isTappedName == false && viewModel.name.count != 0 {
                        Button(action: {
                            print("ddd")
                        }, label: {
                            Image(systemName: "checkmark").foregroundColor(Color("blue"))
                        })
                        
                        .padding(.trailing, 10.0)
                        .disabled(true)
                        
                        
                    } else {
                        
                    }
                }
            }.background(border)
                
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
                    
                    if viewModel.isTappedNicName == false && viewModel.nicName.count != 0 {
                        Button(action: {
                            print("ddd")
                        }, label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color("blue"))
                        })
                        //.frame(width: 40.0)
                        .padding(.trailing, 10.0)
                        .disabled(true)
                        
                    }
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
                    DatePickerTextField(placeholder: "", date: $contact.dob)
                    
                        .padding(.vertical, 12)
                        .padding(.leading, 10)
                        .padding(.trailing, 5)
                        .frame( height: 46.0)
                        .font(.system(size: 20))
                    
                    if contact.dob != nil {
                        Button(action: {
                            print("ddd")
                        }, label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color("blue"))
                        })
                        //.frame(width: 40.0)
                        .padding(.trailing, 10.0)
                        .disabled(true)
                        
                    }
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
                    .keyboardType(.default)
                    .ignoresSafeArea(.keyboard)
                    if viewModel.isEmailValid && !viewModel.isTappedEmail  {
                        Button(action: {
                            print("ddd")
                        }, label: {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color("blue"))
                        })
                        //.frame(width: 40.0)
                        .padding(.trailing, 10.0)
                        .disabled(true)
                        
                    }
                }
                
                
                
                
            }.background(border)
                
        }
    }
    
    
    private func getButton() -> some View {
        
        VStack {
            NavigationLink(isActive: $viewModel.flag) {
                CodeView()
            } label: {
                Button(action: {
                    print("cfcc")
                }) {
                    
                    Text("Готово")
                    
                        .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    
                        .foregroundColor(.white)
                        .background( (viewModel.name.count != 0 && viewModel.nicName.count != 0 && self.contact.dob != nil && viewModel.textEmailOk) ? Color("blue") : Color("buttonDis"))
                        .cornerRadius(6)
                }
            }.disabled((viewModel.name.count == 0 || viewModel.nicName.count == 0 || self.contact.dob == nil || viewModel.textEmailOk == false))
            NavigationLink(isActive: $viewModel.flag) {
                CodeView()
            } label: {
                Text("Пропустить")
                //.padding()
                    .foregroundColor(Color("next"))
            }
            
        }

    }

}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
