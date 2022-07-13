//
//  NewContactView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 13.07.2022.
//

import SwiftUI

struct NewContactView: View {
    
    //@State var contact: Contact
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel: ViewModel
    
    let maskPhone = "+X XXX XXX-XX-XX"
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }

    var borderName: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder((viewModel.isTappedGlobal == true && viewModel.name.count == 0) ?
                          LinearGradient(colors: [Color.red], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color("border")], startPoint: .topLeading, endPoint: .bottomTrailing))
                
    }
    
    var borderPhone: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder((viewModel.isTappedGlobal == true && (viewModel.textPhone.count == 0 || viewModel.textPhone.count != 16)) ?
                          LinearGradient(colors: [Color.red], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color("border")], startPoint: .topLeading, endPoint: .bottomTrailing))
                
    }
    
    var borderLastName: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Color("border")], startPoint: .topLeading, endPoint: .bottomTrailing))
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
        Text("Добавить контакт")
            .foregroundColor(Color.white)
            .font(.system(size: 18))
    }
    
    
    var body: some View {
        ZStack {
            
            Color("thema").ignoresSafeArea()
            VStack {
                getName()
                getLastName()
                getPhone()
                Spacer().frame(height: 40.0)
                getButton()
                Spacer()
            }
            .padding()
            
            //getNicName()
            
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: title)
        .navigationBarItems(leading: btnBack)
    }
    
    private func getName() -> some View {
        VStack (alignment: .trailing){
            VStack(alignment: .leading){
                Text("Имя")
                    .font(.headline)
                    .foregroundColor((viewModel.name.count == 0 && viewModel.isTappedGlobal == true) ? Color.red : Color("text"))
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
                        .placeholder(when: viewModel.name.isEmpty && viewModel.isTappedGlobal == false) {
                            Text("(обязательно)").foregroundColor(Color("text")).contrast(0)
                            
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
                }.background(borderName)
            }
            if viewModel.name.count == 0 && viewModel.isTappedGlobal == true {
            HStack {
                    Text("Не добавлено имя")
                        .foregroundColor(Color.red)
                        .font(.system(size: 15))
                    
                }
            }
        
        }
    }
    
    private func getLastName() -> some View {
        VStack(alignment: .leading){
            Text("Фамилия")
                .font(.headline)
                .foregroundColor(Color("text"))
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
                        Text("(необязательно)").foregroundColor(Color("text")).contrast(0)
                        
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
            }.background(borderLastName)
        }
    }
    
    private func getPhone() -> some View {
        VStack (alignment: .trailing){
            VStack(alignment: .leading){
                Text("Номер телефона")
                    .font(.headline)
                    .foregroundColor(((viewModel.textPhone.count == 0 &&  viewModel.isTappedGlobal == true) || (viewModel.textPhone.count != 16 && viewModel.textPhone.count != 0)) ? Color.red : Color("text"))
                
                Spacer().frame(height: 3.0 )
                
                TextField("", text: Binding<String>(get: {
                    format(with: self.maskPhone, phone: viewModel.textPhone)
                }, set: {
                    viewModel.textPhone = $0
                }))
                .placeholder(when: viewModel.textPhone.isEmpty) {
                    Text("+7 _ _ _  _ _ _ - _ _ - _ _").foregroundColor(((viewModel.textPhone.count == 0 &&  viewModel.isTappedGlobal == true) || (viewModel.textPhone.count != 16 && viewModel.textPhone.count != 0)) ? Color.red : Color("text"))
                    
                }
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .foregroundColor(((viewModel.textPhone.count == 0 &&  viewModel.isTappedGlobal == true) || (viewModel.textPhone.count != 16 && viewModel.textPhone.count != 0)) ? Color.red : Color("text"))
                .background(borderPhone)
                .multilineTextAlignment(.leading)
                .accentColor(Color("text"))
                .keyboardType(.phonePad)

            }
            if viewModel.textPhone.count == 0 && viewModel.isTappedGlobal == true {
            HStack {
                    Text("Нe добавлен номер телефона")
                        .foregroundColor(Color.red)
                        .font(.system(size: 15))
                    
                }
            }
            if viewModel.textPhone.count != 16 && viewModel.textPhone.count != 0 && viewModel.isTappedGlobal == true {
            HStack {
                    Text("Нeкорректный номер телефона")
                        .foregroundColor(Color.red)
                        .font(.system(size: 15))
                    
                }
            }
        }

    }
    
    private func getButton() -> some View {
        
        VStack {
            Button(action: {
                //selection = "A"
            }) {
                Text("Готово")
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .foregroundColor(.white)
                    .background( (viewModel.name.count != 0 && (viewModel.textPhone.count != 0 && viewModel.textPhone.count == 16 ) ? Color("blue") : Color("buttonDis")))
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
