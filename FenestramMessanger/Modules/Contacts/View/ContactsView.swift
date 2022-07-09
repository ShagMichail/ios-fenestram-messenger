//
//  ContactsView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct ContactsView: View {
    
    @State var searchText = ""
    @State var searching = false
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
        NavigationView {
            ZStack{
                Color("thema").ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text("Контакты").font(.system(size: 23)).foregroundColor(Color.white).padding(.horizontal)
                    //.padding()
                    
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
                    
                    ScrollView {
                        if viewModel.filteredContacts.count > 0 {
                            ForEach(viewModel.filteredContacts) { contact in
                                ContactsRow(name: contact.name, image: contact.imageName)
                                    .padding(.horizontal)
                            }
                        } else {
                            Text("Данного контака не существует").font(.system(size: 15)).foregroundColor(Color.white).padding(.horizontal)
                        }
                    }
                    //.padding(.horizontal)
                }
            }.onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationBarHidden(true)
        }
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
