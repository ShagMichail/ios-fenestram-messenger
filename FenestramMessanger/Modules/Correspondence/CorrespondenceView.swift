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
    
    
    //MARK: - Properties
    
    @State var bottomSheetPosition: CorrespondenceBottomSheetPosition = .hidden
    @State private var keyboardHeight: CGFloat = 0
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var message: String = ""
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject private var viewModel: ViewModel
    
    private let bottomSheetOptions: [BottomSheet.Options] = [.noDragIndicator,
                                                             .allowContentDrag,
                                                             .swipeToDismiss, .tapToDismiss,
                                                             .absolutePositionValue,
                                                             .background({ AnyView(Asset.buttonAlert.swiftUIColor) }),
                                                             .cornerRadius(30)]
    
    init(contacts: [UserEntity], chat: ChatEntity?, socketManager: SocketIOManager?) {
        _viewModel = StateObject(wrappedValue: ViewModel(chat: chat, contacts: contacts, socketManager: socketManager))
        UITextView.appearance().backgroundColor = .clear
    }

    
    //MARK: - Body
    
    var body: some View {
        
        ZStack {
            Asset.thema.swiftUIColor
                .ignoresSafeArea()
            VStack {
                VStack {
                    CorrespondenceNavigationView(contacts: viewModel.contacts, chat: viewModel.chat)
                    
                    viewModel.messagesWithTime.isEmpty ? AnyView(getEmtyView()) : AnyView(getMessage())

                    Spacer()
                    if $viewModel.allFoto.count != 0 {
                        getPhotoMessage()
                    }
                    getMessageTextEditor()
                }
                Spacer().frame(height: 16)
                
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(image: $viewModel.chatImage,
                        isShown: $viewModel.showImagePicker,
                        sourceType: self.sourceType)}
        .navigationBarHidden(true)
        .onBackSwipe { presentationMode.wrappedValue.dismiss() }
        .onTapGesture { UIApplication.shared.endEditing() }
            /// Bottom sheet for attachment
        .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: bottomSheetOptions,
                     headerContent: { getBottomSheet()}) {}
    }
    
    
    //MARK: - Views
    
    private func getMessage() -> some View {
        ScrollViewReader { proxy in
            ScrollView() {
                LazyVStack {
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            
                            ProgressView()
                            
                            Spacer()
                        }
                        .id(-2)
                    }
                    
                    ForEach(viewModel.messagesWithTime.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        Text(viewModel.getSectionHeader(with: key))
                            .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 12))
                            .foregroundColor(Asset.grey1.swiftUIColor)
                            .padding()
                        
                        ForEach(value, id: \.id) { message in
                            HStack(alignment: .bottom, spacing: 15) {
                                MessageStyleView(isCurrentUser: viewModel.lastMessage(message: message),
                                                 isGroupChat: viewModel.chat?.isGroup ?? false,
                                                 message: message)
                            }
                            .id(message.id)
                            .padding(.all, 15)
                            .onAppear {
                                viewModel.loadMoreContent(currentItem: message)
                            }
                        }
                    }
                }
            }
            .disabled(viewModel.isLoading)
            .onChange(of: viewModel.messagesWithTime, perform: { newValue in
                guard let key = newValue.keys.max(),
                      let lastMessageId = newValue[key]?.last?.id else { return }
                
                if lastMessageId != viewModel.lastMessageId {
                    viewModel.lastMessageId = lastMessageId
                    proxy.scrollTo(lastMessageId, anchor: .bottom)
                } else if let currentMessageId = viewModel.currentMessageId {
                    proxy.scrollTo(currentMessageId, anchor: .top)
                }
            })
            .onAppear {
                guard let key = viewModel.messagesWithTime.keys.max(),
                      let lastMessage = viewModel.messagesWithTime[key]?.last else { return }
                
                proxy.scrollTo(lastMessage.id)
            }
        }
    }
    
    private func getEmtyView() -> some View {
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
    
    private func getPhotoMessage() -> some View {
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
        }.padding(.bottom, -10)
            .padding(.leading, 15)
            .frame(width: UIScreen.screenWidth, alignment: .leading)
    }
    
    private func getMessageTextEditor() -> some View {
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
                        if viewModel.chat == nil {
                            viewModel.createChat(chatName: viewModel.contacts[0].name ?? "", usersId: viewModel.getUserEntityIds(contactId: viewModel.contacts[0].id))
                        } else {
                            viewModel.postMessage(chat: viewModel.chat)
                        }
                    }
                } label: {
                    Asset.send.swiftUIImage
                        .resizable()
                        .frame(width: 24.0, height: 24.0)
                        .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                }.padding(.trailing, 12.0)
                    .padding(.bottom, -5)
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
        }
    }
    
    private func getBottomSheet() -> some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                NavigationLink(destination: FileView().navigationBarHidden(true)) {
                    buttonsViewProperty(image: Asset.fileButton)
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
                    buttonsViewProperty(image: Asset.imageButton)
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
                    buttonsViewProperty(image: Asset.photoButton)
                }
                Text(L10n.CorrespondenceView.foto)
                    .foregroundColor(Color.white)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
            }
            Spacer()
        }
    }
    
    private func buttonsViewProperty(image: ImageAsset) -> some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 60, height: 60, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Asset.stroke.swiftUIColor, lineWidth: 1.5)
                )
                .foregroundColor(Asset.buttonAlert.swiftUIColor)
            image.swiftUIImage
                .foregroundColor((isColorThema == false) ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor)
        }
    }
}
