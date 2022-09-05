//
//  ContactsView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct ContactsView: View {
    
    
    //MARK: - Properties
    
    var chat: ChatEntity?
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @StateObject private var viewModel: ViewModel
    
    init(socketManager: SocketIOManager?) {
        _viewModel = StateObject(wrappedValue: ViewModel(socketManager: socketManager))
    }
    
    var border: some View {
        RoundedRectangle(cornerRadius: 6)
            .strokeBorder(
                LinearGradient(colors: [Asset.border.swiftUIColor],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing))
    }
    
    
    //MARK: - Body
    
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
                
                if viewModel.presentAlert {
                    AlertView(show: $viewModel.presentAlert, textTitle: $viewModel.textTitleAlert, text: $viewModel.textAlert)
                }
                
            }.onTapGesture {
                UIApplication.shared.endEditing()
            }
            .navigationBarHidden(true)
        }
    }
    
    
    //MARK: - Views
    
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
            VStack(alignment: .trailing) {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        if viewModel.filteredContacts.count > 0 {
                            ForEach(viewModel.filteredContacts) { contact in
                                getContactsRow(contact: contact)
                            }
                        } else {
                            HStack {
                                Text(L10n.ContactView.contactDontExist)
                                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 15))
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal)
                            }.frame(width: UIScreen.screenWidth)
                        }
                    }
                }
                .padding(.bottom, -85)
                getButtonNewContact()
            }
        }
    }
    
    private func getButtonNewContact() -> some View {
        NavigationLink() {
            NewContactView()
        } label: {
            ZStack {
                Asset.addButtonIcon.swiftUIImage
                    .padding(.bottom, 10)
                    .padding(.trailing, 10)
                    .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                Image(systemName: "plus")
                    .font(.title)
                    .padding(.bottom, 17)
                    .padding(.trailing, 10)
            }
        }
    }
    
    private func getContactsRow(contact: UserEntity) -> some View {
        NavigationLink() {
            CorrespondenceView(contacts: [contact], chat: nil, socketManager: viewModel.socketManager).navigationBarHidden(true)
        } label: {
            HStack() {
                Asset.photo.swiftUIImage
                    .resizable()
                    .frame(width: 40.0, height: 40.0)
                    .padding(.horizontal)
                
                Text(contact.name ?? L10n.General.unknown)
                    .foregroundColor(.white)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 20))
                
                Spacer()
            }.padding(.horizontal)
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
                    .background((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                    .cornerRadius(6)
            }
            .padding(.bottom, 50)
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(socketManager: nil)
    }
}


extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
