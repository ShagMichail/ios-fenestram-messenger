//
//  ChatView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI
import Combine
import BottomSheet
import Network

enum CorrespondenceBottomSheetPosition: CGFloat, CaseIterable {
    case bottom = 220, hidden = 0
}

struct CorrespondenceView: View {
    
    @State var bottomSheetPosition: CorrespondenceBottomSheetPosition = .hidden
    @State private var keyboardHeight: CGFloat = 0
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var contact: UserEntity?
    var chatFirst: ChatEntity?
    var contactId: Int = 0
    var message: String = ""
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel: ViewModel
    
    init(contact: UserEntity?, chat: ChatEntity?) {
        self.chatFirst = chat
        self.contact = contact
        _viewModel = StateObject(wrappedValue: ViewModel(chat: chat))
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Asset.thema.swiftUIColor
                    .ignoresSafeArea()
                VStack {
                    CorrespondenceNavigationView(contact: contact!)
                    if $viewModel.allMessage.count != 0 {
                        ScrollView {
                            ForEach(viewModel.allMessage) { message in
                                HStack(alignment: .bottom, spacing: 15) {
                                    MessageStyleView(contentMessage: message.message,
                                                     isCurrentUser: lastMessage(message: message), message: message)
                                }.padding(.all, 15)
                            }
                        }
                    } else {
                        VStack {
                            Asset.helloMessage.swiftUIImage
                                .resizable()
                                .scaledToFit()
                            Text(L10n.CorrespondenceView.message)
                                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                                .foregroundColor(Asset.photoBack.swiftUIColor)
                                .multilineTextAlignment(.center)
                        }.padding()
                    }
                    Spacer()
                    if $viewModel.allFoto.count != 0 {
                        HStack {
                            ForEach(viewModel.allFoto) { foto in
                                ZStack {
                                    Image(uiImage: foto.image)
                                        .resizable()
                                        .frame(width: 48, height: 48)
                                        .cornerRadius(12)
                                    Button {
                                        viewModel.allFoto = viewModel.allFoto.filter({ $0.id != foto.id })
                                    } label: {
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 30)
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(Color.white)
                                            Image(systemName: "xmark")
                                                .foregroundColor(Color.black)
                                        }.padding(.bottom, 45)
                                    }
                                }
                            }
                        }.padding(.bottom, -20)
                            .padding(.leading, 15)
                            .frame(width: UIScreen.screenWidth, alignment: .leading)
                    }
                    VStack {
                        ZStack(alignment: .bottom) {
                            HStack{
                                TextEditor(text: $viewModel.textMessage)
                                    .placeholder(when: viewModel.textMessage.isEmpty) {
                                        Text(L10n.CorrespondenceView.textMessage).foregroundColor(Asset.text.swiftUIColor)
                                            .padding(.leading, 5)
                                    }
                                    .frame(minHeight: 40, maxHeight: 150, alignment: .leading)
                                    .foregroundColor(Asset.text.swiftUIColor)
                                    .accentColor(Asset.text.swiftUIColor)
                                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Asset.tabBar.swiftUIColor)
                                        .frame(width: UIScreen.screenWidth - 24))
                                    .padding(.leading , 50)
                                    .padding(.trailing , 50)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Asset.tabBar.swiftUIColor)
                                .frame(width: UIScreen.screenWidth - 24, height: 55))
                            
                            HStack(alignment: .bottom){
                                Button {
                                    bottomSheetPosition = .bottom
                                } label: {
                                    Asset.severicons.swiftUIImage
                                        .resizable()
                                        .frame(width: 24.0, height: 24.0)
                                }.padding(.leading, 12.0)
                                    .padding(.bottom, -5)
                                
                                Spacer()
                                Button {
                                    if !viewModel.textMessage.isEmpty {
                                        viewModel.postMessage(chat: chatFirst)
                                    }
                                } label: {
                                    Asset.send.swiftUIImage
                                        .resizable()
                                        .frame(width: 24.0, height: 24.0)
                                        .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                                }.padding(.trailing, 12.0)
                                    .padding(.bottom, -5)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                        }
                    }
                    Spacer().frame(height: 16)
                }
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(image: $viewModel.image, isShown: $viewModel.showImagePicker, sourceType: self.sourceType)}
            
            .navigationBarHidden(true)
            
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: [.noDragIndicator, .allowContentDrag, .swipeToDismiss, .tapToDismiss, .absolutePositionValue, .background({ AnyView(Asset.buttonAlert.swiftUIColor) }), .cornerRadius(30)], headerContent: {
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        NavigationLink(destination: FileView().navigationBarHidden(true)) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Asset.stroke.swiftUIColor, lineWidth: 1.5)
                                    )
                                    .foregroundColor(Asset.buttonAlert.swiftUIColor)
                                Asset.fileButton.swiftUIImage
                                    .foregroundColor((isColorThema == false) ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor)
                                
                            }
                        }
                        Text(L10n.CorrespondenceView.file)
                            .foregroundColor(Color.white)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    }
                    
                    Spacer()
                    
                    VStack {
                        Button {
                            viewModel.showImagePicker = true
                            self.sourceType = .photoLibrary
                            bottomSheetPosition = .hidden
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Asset.stroke.swiftUIColor, lineWidth: 1.5)
                                    )
                                    .foregroundColor(Asset.buttonAlert.swiftUIColor)
                                Asset.imageButton.swiftUIImage
                                    .foregroundColor((isColorThema == false) ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor)
                            }
                        }
                        Text(L10n.CorrespondenceView.image)
                            .foregroundColor(Color.white)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    }
                    Spacer()
                    VStack {
                        Button {
                            viewModel.showImagePicker = true
                            self.sourceType = .camera
                            bottomSheetPosition = .hidden
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Asset.stroke.swiftUIColor, lineWidth: 1.5)
                                    )
                                    .foregroundColor(Asset.buttonAlert.swiftUIColor)
                                Asset.phoneButton.swiftUIImage
                                    .foregroundColor((isColorThema == false) ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor)
                            }
                        }
                        Text(L10n.CorrespondenceView.foto)
                            .foregroundColor(Color.white)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    }
                    Spacer()
                }
            }) {
            }
        }
    }
    
    private func lastMessage(message: MessageEntity) -> Bool {
        if message.fromUserId == Settings.currentUser?.id{
            return true
        }
        return false
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
