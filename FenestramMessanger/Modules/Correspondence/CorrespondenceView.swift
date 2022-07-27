//
//  ChatView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI
import Combine
import BottomSheet


enum CorrespondenceBottomSheetPosition: CGFloat, CaseIterable {
    case bottom = 220, hidden = 0
}

struct CorrespondenceView: View {
    @State var bottomSheetPosition: CorrespondenceBottomSheetPosition = .hidden
    @AppStorage ("isColorThema") var isColorThema: Bool?
    @State private var keyboardHeight: CGFloat = 0
    var contact: UserEntity?
    var chat: [ChatEntity] = []
    var contactId: Int = 0
    //@State var whoseMessage = false
    var message: String = ""
    var allMessage: [MessageEntity] = []
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel: ViewModel
    init(contact: UserEntity, chat: [ChatEntity]) {
        _viewModel = StateObject(wrappedValue: ViewModel())
        self.contact = contact
        self.chat = chat
        filterChat()
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Asset.thema.swiftUIColor
                    .ignoresSafeArea()
                
                VStack {
                    CorrespondenceNavigationView(contact: contact!)
                    if allMessage.count != 0 {
                        ScrollView {
                            //
                            ForEach(allMessage) { message in
                                
                                HStack(alignment: .bottom, spacing: 15) {
                                    MessageStyleView(contentMessage: message.message,
                                                     isCurrentUser: lastMessage(), message: message)
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
                                                }.padding(.bottom, 35)

                                            }
                                            
                                        
                                    }
                                        
                                
                            }
                        }.frame(width: UIScreen.screenWidth)
                      
                    }
                    VStack {
                        ZStack {
                            HStack{
                                Button {
                                    bottomSheetPosition = .bottom
                                } label: {
                                    Asset.severicons.swiftUIImage
                                        .resizable()
                                        .frame(width: 24.0, height: 24.0)
                                }.padding(.leading, 12.0)
                                
                                TextField("", text: $viewModel.textMessage)
                                    .placeholder(when: viewModel.textMessage.isEmpty) {
                                        Text(L10n.CorrespondenceView.textMessage).foregroundColor(Asset.text.swiftUIColor)
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
                            
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                            .background(RoundedRectangle(cornerRadius: 10)
                                        //.stroke(Asset.border.swiftUIColor, lineWidth: 1)
                                .foregroundColor(Asset.tabBar.swiftUIColor)
                                .frame(width: UIScreen.screenWidth - 24, height: 55))
                            
                        }
                        
                    }
                }
                
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(image: $viewModel.image, isShown: $viewModel.showImagePicker, sourceType: self.sourceType)}
            
            .navigationBarHidden(true)
            
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: [.noDragIndicator, .allowContentDrag, .swipeToDismiss, .tapToDismiss, .absolutePositionValue, .background({ AnyView(Asset.buttonAlert.swiftUIColor) }), .cornerRadius(30)], headerContent: {
                //The name of the book as the heading and the author as the subtitle with a divider.
                VStack {
                    
                    HStack {
                        VStack {
                            NavigationLink(destination: FileView().navigationBarHidden(true)) {
                                Asset.fileCor.swiftUIImage
                                    .resizable()
                                    .frame(width: 60.0, height: 60.0)
                                    .padding(.horizontal)
                            }
                            Text(L10n.CorrespondenceView.file)
                                .foregroundColor(Color.white)
                                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                        }
                        
                        
                        Spacer().frame(width: 35.0)
                        
                        VStack {
                            Button {
                                viewModel.showImagePicker = true
                                self.sourceType = .photoLibrary
                                bottomSheetPosition = .hidden
                            } label: {
                                Asset.imageCor.swiftUIImage
                                    .resizable()
                                    .frame(width: 60.0, height: 60.0)
                                    .padding(.horizontal)
                            }
                            Text(L10n.CorrespondenceView.image)
                                .foregroundColor(Color.white)
                                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                        }
                        Spacer().frame(width: 35.0)
                        VStack {
                            Button {
                                viewModel.showImagePicker = true
                                self.sourceType = .camera
                                bottomSheetPosition = .hidden
                            } label: {
                                Asset.fotoCor.swiftUIImage
                                    .resizable()
                                    .frame(width: 60.0, height: 60.0)
                                    .padding(.horizontal)
                            }
                            Text(L10n.CorrespondenceView.foto)
                                .foregroundColor(Color.white)
                                .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                        }
                        //                    NavigationLink(destination: CorrespondenceView(contact: contact!)) {
                        //                        Asset.messageIcon.swiftUIImage
                        //                            .resizable()
                        //                            .frame(width: 60.0, height: 60.0)
                        //                            .padding(.horizontal)
                        //                    }
                    }
                }
            }) {
                //A short introduction to the book, with a "Read More" button and a "Bookmark" button.
                
            }
            
        }
        
    }
    
    
    private mutating func filterChat() {
        guard chat[0] != nil else {return}
        let chat = chat[0]
        guard let allMessage = chat.messages else {return}
        self.allMessage = allMessage
    }
    
    private func lastMessage() -> Bool {
        //guard let message = chat[0].messages else { return "" }
        let message: MessageEntity
        for i in self.allMessage.startIndex ..< self.allMessage.count {
            if self.allMessage[i].fromUserId == Settings.currentUser?.id{
                return true
            }
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
