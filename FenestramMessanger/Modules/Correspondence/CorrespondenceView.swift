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
import AlertToast
import Kingfisher

enum CorrespondenceBottomSheetPosition: CGFloat, CaseIterable {
    case bottom = 220, hidden = 0
}

struct CorrespondenceView: View {
    
    
    //MARK: - Properties
    
    @State var bottomSheetPosition: CorrespondenceBottomSheetPosition = .hidden
    @State private var keyboardHeight: CGFloat = 0
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var isShowingSend = false
    @State private var textEditorWidth: CGFloat = 35
    
    var message: String = ""
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var showTabBar: Bool
    
    @StateObject private var viewModel: ViewModel
    
    private let bottomSheetOptions: [BottomSheet.Options] = [.noDragIndicator,
                                                             .allowContentDrag,
                                                             .swipeToDismiss, .tapToDismiss,
                                                             .absolutePositionValue,
                                                             .background({ AnyView(Asset.dark1.swiftUIColor) }),
                                                             .cornerRadius(30)]
    
    init(contacts: [ContactEntity], chat: ChatEntity?, socketManager: SocketIOManager?, showTabBar: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ViewModel(chat: chat, contacts: contacts, socketManager: socketManager))
        _showTabBar = showTabBar
        UITextView.appearance().backgroundColor = .clear
    }
    
    
    //MARK: - Body
    
    var body: some View {
        
        ZStack {
            Asset.background.swiftUIColor
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    CorrespondenceNavigationView(contacts: viewModel.contacts, chat: viewModel.chat, showTabBar: $showTabBar)
                    
                    if viewModel.isLoading && viewModel.page == 1 {
                        LoadingView()
                    } else {
                        viewModel.messagesWithTime.isEmpty ? AnyView(getEmtyView()) : AnyView(getMessage())
                        
                        Spacer()
                        
                        if viewModel.allFoto.count != 0 {
                            getPhotoMessage()
                        }
                        
                        getMessageTextEditor()
                    }
                }
                
                Spacer().frame(height: 16)
            }
            
            if let selectedImage = viewModel.selectedImage {
                ZStack {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            self.viewModel.selectedImage = nil
                            self.viewModel.selectedImageURL = nil
                        }
                    
                    if let url = viewModel.selectedImageURL {
                        KFImage(url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                    } else {
                        selectedImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .cornerRadius(20)
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(image: $viewModel.chatImage,
                        isShown: $viewModel.showImagePicker,
                        sourceType: self.sourceType)}
        .navigationBarHidden(true)
        .onBackSwipe(perform: {
            showTabBar = true
            presentationMode.wrappedValue.dismiss()
        }, isEnabled: !viewModel.isLoading)
        .onTapGesture { UIApplication.shared.endEditing() }
        .onAppear {
            showTabBar = false
        }
        /// Bottom sheet for attachment
        .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: bottomSheetOptions,
                     headerContent: { getBottomSheet()}, mainContent: {})
        .toast(isPresenting: $viewModel.showUploadImageSuccessToast, duration: 1, tapToDismiss: true) {
            AlertToast(displayMode: .alert, type: .complete(isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor), title: viewModel.successUploadImageMessage)
        }
        .toast(isPresenting: $viewModel.showUploadImageErrorToast, duration: 2, tapToDismiss: true) {
            AlertToast(displayMode: .alert, type: .error(Asset.red.swiftUIColor), title: L10n.CorrespondenceView.Toast.UploadImage.error)
        }
        .toast(isPresenting: $viewModel.showUploadImageProgressToast, duration: 120, tapToDismiss: false) {
            AlertToast(displayMode: .alert, type: .loading, title: L10n.CorrespondenceView.Toast.UploadImage.progress)
        }
    }
    
    
    //MARK: - Views
    
    private func getMessage() -> some View {
        ScrollViewReader { proxy in
            ScrollView() {
                LazyVStack {
                    if viewModel.isLoading && viewModel.page > 1 {
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
                                MessageStyleView(chat: viewModel.chat,
                                                 contacts: viewModel.contacts,
                                                 message: message,
                                                 onClickImage: { url in
                                    viewModel.selectedImageURL = url
                                    viewModel.selectedImage = Asset.photo.swiftUIImage
                                })
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
    
    fileprivate func getTextEditor() -> some View {
        return TextEditor(text: $viewModel.textMessage)
            .padding(.leading, 40)
            .foregroundColor(Asset.text.swiftUIColor)
            .multilineTextAlignment(.leading)
            .frame(minHeight: 40, maxHeight: 150, alignment: .center)
            .fixedSize(horizontal: false, vertical: true)
            .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
            .onChange(of: viewModel.textMessage) { newValue in
                if !newValue.isEmpty {
                    withAnimation {
                        isShowingSend = true
                        textEditorWidth = 80
                    }
                } else {
                    withAnimation {
                        isShowingSend = false
                        textEditorWidth = 35
                    }
                }
            }
            .placeholder(when: viewModel.textMessage.isEmpty) {
                Text(L10n.CorrespondenceView.textMessage)
                    .foregroundColor(Asset.text.swiftUIColor)
                    .padding(.leading, 45)
            }
    }
    
    private func getMessageTextEditor() -> some View {
        ZStack {
            ZStack(alignment: .bottom) {
                
                HStack {
                    VStack(alignment: .leading) {
                        if #available(iOS 16.0, *) {
                            getTextEditor()
                                .scrollContentBackground(.hidden)
                        } else {
                            getTextEditor()
                        }
                    }
                    .frame(minHeight: 40, maxHeight: 150, alignment: .center)
                    .foregroundColor(Asset.text.swiftUIColor)
                    .accentColor(Asset.text.swiftUIColor)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                    .background(RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Asset.dark1.swiftUIColor)
                        .frame(width: UIScreen.screenWidth - textEditorWidth), alignment: .leading)
                    .padding(.leading , 15)
                    .padding(.trailing , 50)
                    .fixedSize(horizontal: false, vertical: true)
                }
                
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
                    
                    if isShowingSend {
                        Button {
                            if !viewModel.textMessage.isEmpty || !viewModel.allFoto.isEmpty {
                                if viewModel.chat == nil {
                                    viewModel.createChat(chatName: viewModel.contacts[0].name, usersId: viewModel.getUserEntityIds(contactId: viewModel.contacts[0].id))
                                } else {
                                    if !viewModel.textMessage.isEmpty {
                                        viewModel.postTextMessage()
                                    }
                                    viewModel.postImageMessage()
                                }
                            }
                        } label: {
                            (isColorThema == false ? Asset.sendMessageIc.swiftUIImage : Asset.sendMessageGreen.swiftUIImage)
                                .resizable()
                                .frame(width: 28.0, height: 28.0)
                        }
                        .padding(.trailing, 12.0)
                        .padding(.bottom, -5)
                    }
                   
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
            }
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
                .foregroundColor(Asset.background0.swiftUIColor)
            
            image.swiftUIImage
                .foregroundColor((isColorThema == false) ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor)
        }
    }
}
