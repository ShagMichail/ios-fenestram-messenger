//
//  ChatView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI
import Combine

struct CorrespondenceView: View {
    @AppStorage ("isColorThema") var isColorThema: Bool?
    @State private var keyboardHeight: CGFloat = 0
    var contact: UserEntity?
    var contactId: Int = 0
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel: ViewModel
    init(contact: UserEntity) {
        _viewModel = StateObject(wrappedValue: ViewModel())
        self.contact = contact
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
        HStack {
            Asset.photo.swiftUIImage
                .resizable()
                .frame(width: 40.0, height: 40.0)
            
            VStack(alignment: .leading) {
                Text(contact?.name ?? L10n.General.unknown)
                    .foregroundColor(Color.white)
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                
                Text("В сети")
                    .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                
            }
        }
    }
    
    var btnBell : some View {
        HStack {
            Button(action: {
                
            }) {
                HStack {
                    Asset.video.swiftUIImage
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                }
            }
            
            Button(action: {
                
            }) {
                HStack {
                    Asset.phone.swiftUIImage
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            Asset.thema.swiftUIColor
                .ignoresSafeArea()
            
            VStack {
                RoundedRectangle(cornerRadius: 0)
                    .foregroundColor(Asset.buttonDis.swiftUIColor)
                    .frame(width: UIScreen.screenWidth, height: 100.0)
                    .ignoresSafeArea()
                Spacer()
            }
            
            VStack {
                VStack {
                    Asset.helloMessage.swiftUIImage
                        .resizable()
                        .scaledToFit()
                    Text(L10n.CorrespondenceView.message)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                        .foregroundColor(Asset.photoBack.swiftUIColor)
                        .multilineTextAlignment(.center)
                }.padding()
                
                
                Spacer()
                
                VStack {
                    ZStack {
//                        RoundedRectangle(cornerRadius: 10)
//                        //.stroke(Asset.border.swiftUIColor, lineWidth: 1)
//                            .background(Asset.tabBar.swiftUIColor)
//                            .frame(width: UIScreen.screenWidth - 24, height: 55)
                        HStack{
                            Button {
                                print("")
                            } label: {
                                Asset.severicons.swiftUIImage
                                    .resizable()
                                    .frame(width: 24.0, height: 24.0)
                            }.padding(.leading, 12.0)
                            
                            TextField("", text: $viewModel.textMessage)
                                .placeholder(when: viewModel.textMessage.isEmpty) {
                                    Text("Ваше сообщение").foregroundColor(Asset.text.swiftUIColor)
                                }
                                .foregroundColor(Asset.text.swiftUIColor)
                                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                                .multilineTextAlignment(.leading)
                                .accentColor(Asset.text.swiftUIColor)
                                .keyboardType(.default)
                            //.textContentType(.telephoneNumber)
                                .padding(.horizontal, 4)
                            
                            Button {
                                print("")
                            } label: {
                                Asset.send.swiftUIImage
                                    .resizable()
                                    .frame(width: 24.0, height: 24.0)
                                    .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                            }.padding(.trailing, 12.0)
                        }
                        .frame(height: 48)
                        //                        .overlay(
                        //                            RoundedRectangle(cornerRadius: 5)
                        //                                //.stroke(Asset.border.swiftUIColor, lineWidth: 1)
                        //                                //.background(Asset.tabBar.swiftUIColor)
                        //                        )
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 10)
                                        //.stroke(Asset.border.swiftUIColor, lineWidth: 1)
                                            .foregroundColor(Asset.tabBar.swiftUIColor)
                                            .frame(width: UIScreen.screenWidth - 24, height: 55))
                    }
                    
                }
            }
            
            //Text("Переписка!").foregroundColor(Color.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: title)
        .navigationBarItems(leading: btnBack)
        .navigationBarItems(trailing: btnBell)
        //.onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
    
}
