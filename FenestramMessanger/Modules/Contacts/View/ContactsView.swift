//
//  ContactsView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct ContactsView: View {
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Asset.border.swiftUIColor],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing))
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                Asset.thema.swiftUIColor
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    getHeaderView()
                    
                    if viewModel.isLoading {
                        LoadingView()
                    } else {
                        if viewModel.allContacts.count != 0 {
                            getSearchView()
                            
                            Spacer().frame(height: 20.0)
                            
                            getContentView()
                        } else {
                            getEmptyView()
                        }
                    }
                }
            }.onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationBarHidden(true)
        }
    }
    
    private func getHeaderView() -> some View {
        Text(L10n.ContactView.title)
            .font(FontFamily.Poppins.bold.swiftUIFont(size: 18))
            .foregroundColor(Color.white)
            .padding(.horizontal)
            .padding(.top)
    }
    
    private func getSearchView() -> some View {
        VStack(alignment: .leading) {
            TextField("", text: $viewModel.searchText)
                .placeholder(when: viewModel.searchText.isEmpty) {
                    Text(L10n.ContactView.Search.placeholder)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                        .foregroundColor(Asset.text.swiftUIColor)
                }
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                .textFieldStyle(PlainTextFieldStyle())
                .padding(.vertical, 12)
                .padding(.leading, 10)
                .padding(.trailing, 5)
                .foregroundColor(Color.white)
            
                .multilineTextAlignment(.leading)
                .accentColor(Asset.text.swiftUIColor)
                .keyboardType(.default)
                .onChange(of: viewModel.searchText) { text in
                    viewModel.filterContent()
                }
        }
        .background(border)
        .padding(.horizontal, 30.0)
    }
    
    private func getContentView() -> some View {
        ZStack {
            VStack (alignment: .trailing) {
                ScrollView {
                    if viewModel.filteredContacts.count > 0 {
                        ForEach(viewModel.filteredContacts) { contact in
                            ContactsRow(contact: contact)
                                .padding(.horizontal)
                        }
                    } else {
                        Text(L10n.ContactView.contactDontExist)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 15))
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, -70)
                
                NavigationLink() {
                    NewContactView()
                        .navigationBarHidden(true)
                } label: {
                    Asset.addButtonIcon.swiftUIImage
                        .padding(.bottom, 10)
                        .padding(.trailing, 10)
                }
            }
        }
    }
    
    private func getEmptyView() -> some View {
        VStack(alignment: .center) {
            Spacer()
            Asset.newContact.swiftUIImage
                .resizable()
                .frame(width: 300, height: 300)
            
            Text(L10n.ContactView.emptyText)
                .foregroundColor(Asset.photoBack.swiftUIColor)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            NavigationLink() {
                NewContactView()
            } label: {
                Text(L10n.ContactView.addContact)
                    .frame(width: UIScreen.screenWidth - 30, height: 45.0)
                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 16))
                    .foregroundColor(.white)
                    .background(Asset.blue.swiftUIColor)
                    .cornerRadius(6)
            }
            .padding(.bottom, 50)
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
