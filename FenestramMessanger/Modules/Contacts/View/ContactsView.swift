//
//  ContactsView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct ContactsView: View {
    
    @State var searchText = ""
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
        //NavigationView {
        ZStack{
            Color("thema").ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Контакты").font(.system(size: 23)).foregroundColor(Color.white).padding(.horizontal)
                    .padding(.top)
                
                if viewModel.filteredContacts.count != 0 {
                    
                    VStack(alignment: .leading) {
                        TextField("", text: $viewModel.searchText)
                            .placeholder(when: viewModel.searchText.isEmpty) {
                                Text("Поиск контакта").foregroundColor(Color("text"))
                            }
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(.vertical, 12)
                            .padding(.leading, 10)
                            .padding(.trailing, 5)
                            .foregroundColor(Color("text"))
                        
                            .multilineTextAlignment(.leading)
                            .accentColor(Color("text"))
                            .keyboardType(.default)
                            .onChange(of: viewModel.searchText) { text in
                                viewModel.filterContent()
                            }
                    }
                    .background(border)
                    .padding(.horizontal, 30.0)
                    
                    Spacer().frame(height: 20.0)
                    
                    
                    ZStack () {
                        VStack (alignment: .trailing) {
                            
                            ScrollView {
                                if viewModel.filteredContacts.count > 0 {
                                    ForEach(viewModel.filteredContacts) { contact in
                                        ContactsRow(contact: contact)
                                            .padding(.horizontal)
                                    }
                                } else {
                                    Text("Данного контака не существует").font(.system(size: 15)).foregroundColor(Color.white).padding(.horizontal)
                                }
                            }
                            .padding(.bottom, -70)
                            
                            HStack (alignment: .bottom){
                                
                                Button(action: {
                                    print("dfs")
                                }) {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 40)
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(Color("blue"))
                                        Image(systemName: "plus")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 25))
                                    }
                                    
                                    .padding(.bottom, 10)
                                    .padding(.trailing, 10)
                                    
                                }
                            }
                        }
                    }
                    
                } else {
                    VStack(alignment: .center) {
                        Spacer()
                        Image("newContact")
                            .resizable()
                            .frame(width: 300, height: 300)
                        
                        Text("Телефонная книга пуста. Хотите добавить контакты?")
                            .foregroundColor(Color("photoBack"))
                            .multilineTextAlignment(.center)
                        Spacer()
                        NavigationLink() {
                            NewContactView()
                        } label: {
                            Text("Добавить контакт")
                                .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                                .foregroundColor(.white)
                                .background(Color("blue"))
                                .cornerRadius(6)
                        }
                        .padding(.bottom, 50)
                    }
                }
                
                
            }
            
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }
        .navigationBarHidden(true)
    }
    
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}


extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
