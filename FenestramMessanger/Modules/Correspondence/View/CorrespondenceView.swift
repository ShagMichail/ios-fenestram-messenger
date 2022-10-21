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

struct CorrespondenceView: View {
    
    
    //MARK: - Properties
    
    @State var bottomSheetPosition: CorrespondenceBottomSheetPosition = .hidden
    @State var editBottomSheetPosition: EditingMessageBottomSheetPosition = .hidden
    @State private var keyboardHeight: CGFloat = 0
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State var isShowingSend = false
    @State private var textEditorWidth: CGFloat = 35
    @State internal var isMessageEditing = false
    
    var message: String = ""
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject internal var viewModel: ViewModel
    
    private let bottomSheetOptions: [BottomSheet.Options] = [.noDragIndicator,
                                                             .allowContentDrag,
                                                             .swipeToDismiss, .tapToDismiss,
                                                             .absolutePositionValue,
                                                             .background({ AnyView(Asset.dark1.swiftUIColor) }),
                                                             .cornerRadius(30)]
    
    init(contacts: [ContactEntity], chat: ChatEntity?, socketManager: SocketIOManager?) {
        _viewModel = StateObject(wrappedValue: ViewModel(chat: chat, contacts: contacts, socketManager: socketManager))
        UITextView.appearance().backgroundColor = .clear
    }
    
    
    //MARK: - Body
    
    var body: some View {
        
        ZStack {
            Asset.background.swiftUIColor
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    CorrespondenceNavigationView(contacts: viewModel.contacts, chat: viewModel.chat)
                    
                    if viewModel.isLoading && viewModel.page == 1 {
                        LoadingView()
                    } else {
                        viewModel.messagesWithTime.isEmpty ? AnyView(getEmtyView()) : AnyView(getMessage())
                                   
                        Spacer()
                        
                        if viewModel.allFoto.count != 0 {
                            getPhotoMessage()
                        }
                        
                        // MARK: text editor
                        if isMessageEditing {
                            getEditMessageView()
                        } else {
                            getMessageTextEditor()
                        }
                        
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
            
            if viewModel.presentAlert {
                DeleteAlertView(show: $viewModel.presentAlert,
                                actionForAll: $viewModel.deleteMessageForMeOrEveryone)
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(image: $viewModel.chatImage,
                        isShown: $viewModel.showImagePicker,
                        sourceType: self.sourceType)}
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onTapGesture { UIApplication.shared.endEditing() }
        /// Bottom sheet for attachment
        .bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: bottomSheetOptions,
                     headerContent: { getBottomSheet()}, mainContent: {})
        .bottomSheet(bottomSheetPosition: self.$editBottomSheetPosition, options: bottomSheetOptions,
                     headerContent: { getEditSheet()}, mainContent: {})
        .toast(isPresenting: $viewModel.showUploadImageSuccessToast, duration: 1, tapToDismiss: true) {
            AlertToast(displayMode: .alert, type: .complete(isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor), title: viewModel.successUploadImageMessage)
        }
        .toast(isPresenting: $viewModel.showUploadImageErrorToast, duration: 2, tapToDismiss: true) {
            AlertToast(displayMode: .alert, type: .error(Asset.red.swiftUIColor), title: L10n.CorrespondenceView.Toast.UploadImage.error)
        }
        .toast(isPresenting: $viewModel.showUploadImageProgressToast, duration: 120, tapToDismiss: false) {
            AlertToast(displayMode: .alert, type: .loading, title: L10n.CorrespondenceView.Toast.UploadImage.progress)
        }
        /// Default Errors
        .toast(isPresenting: $viewModel.showAlertError, duration: 2, tapToDismiss: true) {
            AlertToast(displayMode: .alert, type: .error(Asset.red.swiftUIColor), title: viewModel.showAlertErrorText)
        }
    }
    
    
    //MARK: - Views
    
    
    // MARK: - Message
    
    private func getMessage() -> some View {
        ScrollViewReader { proxy in
            ScrollView() {
                LazyVStack(spacing: 15) {
                    ForEach(viewModel.messagesWithTime.sorted(by: { $0.key > $1.key }), id: \.key) { key, value in
                        
                        ForEach(value.sorted(by: { $0.id > $1.id }), id: \.id) { message in
                            HStack(alignment: .bottom, spacing: 15) {
                                MessageStyleView(chat: viewModel.chat,
                                                 contacts: viewModel.contacts,
                                                 message: message,
                                                 onClickImage: { url in
                                    viewModel.selectedImageURL = url
                                    viewModel.selectedImage = Asset.photo.swiftUIImage
                                })
                                .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded({ _ in
                                    /// light vibration on tap :)
                                    let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
                                    impactHeavy.impactOccurred()
                                    
                                    UIApplication.shared.endEditing()
                                    viewModel.selectedMessage = message
                                    self.editBottomSheetPosition = .bottom
                                }))
                            }
                            .rotationEffect(.radians(.pi))
                            .id(message.id)
                            .padding(.all, 15)
                            .onAppear {
                                viewModel.loadMoreContent(currentItem: message)
                            }
                            
                            if value.first == message {
                                Text(viewModel.getSectionHeader(with: key))
                                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 12))
                                    .foregroundColor(Asset.grey1.swiftUIColor)
                                    .padding()
                                    .rotationEffect(.radians(.pi))
                            }
                            
                        }
                        
                    }
                }
            }
            .rotationEffect(.radians(.pi))
            .onChange(of: viewModel.messagesWithTime, perform: { newValue in
                guard let key = newValue.keys.max(),
                      let lastMessageId = newValue[key]?.last?.id else { return }

                if lastMessageId != viewModel.lastMessageId {
                    viewModel.lastMessageId = lastMessageId
                    proxy.scrollTo(lastMessageId)
                } else if let currentMessageId = viewModel.currentMessageId {
                    proxy.scrollTo(currentMessageId)
                }
            })
            .onAppear {
                guard let key = viewModel.messagesWithTime.keys.max(),
                      let lastMessage = viewModel.messagesWithTime[key]?.last else { return }

                proxy.scrollTo(lastMessage.id)
            }
        }
    }
    
    
    // MARK: - Empty
    
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
    
    // MARK: - Text editor and send button
    
    fileprivate func checkEditorAndFotoCollection() {
        if !viewModel.textMessage.isEmpty || !viewModel.allFoto.isEmpty {
            withAnimation {
                isShowingSend = true
                textEditorWidth = 80
            }
        } else  {
            withAnimation {
                isShowingSend = false
                textEditorWidth = 35
            }
        }
    }
    
    internal func getTextEditor(_ isEditMode: Bool) -> some View {
        var leadPadding: CGFloat = 12
        isEditMode ? (leadPadding = 12) : (leadPadding = 40)
        return TextEditor(text: $viewModel.textMessage)
            .padding(.leading, leadPadding)
            .foregroundColor(Asset.text.swiftUIColor)
            .multilineTextAlignment(.leading)
            .frame(minHeight: 40, maxHeight: 150, alignment: .center)
            .fixedSize(horizontal: false, vertical: true)
            .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
            .onChange(of: viewModel.textMessage) { _ in
                checkEditorAndFotoCollection()
            }
            .onChange(of: viewModel.allFoto, perform: { _ in
                checkEditorAndFotoCollection()
            })
            .placeholder(when: viewModel.textMessage.isEmpty) {
                Text(L10n.CorrespondenceView.textMessage)
                    .foregroundColor(Asset.text.swiftUIColor)
                    .padding(.leading, leadPadding + 5)
            }
    }
    
    private func getMessageTextEditor() -> some View {
        ZStack {
            ZStack(alignment: .bottom) {
                
                HStack {
                    VStack(alignment: .leading) {
                        if #available(iOS 16.0, *) {
                            getTextEditor(false)
                                .scrollContentBackground(.hidden)
                        } else {
                            getTextEditor(false)
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
                        UIApplication.shared.endEditing()
                        bottomSheetPosition = .bottom
                    } label: {
                        Asset.severicons.swiftUIImage
                            .resizable()
                            .frame(width: 24.0, height: 24.0)
                    }.padding(.leading, 12.0)
                        .padding(.bottom, -4)
                    
                    Spacer()
                    
                    if isShowingSend || viewModel.allFoto.count != 0 {
                        // send message
                        Button {
                            viewModel.addNewTextMessage()
                        } label: {
                            ZStack {
                                (isColorThema == false ? Asset.sendMessageIc.swiftUIImage : Asset.sendMessageGreen.swiftUIImage)
                                    .resizable()
                                    .frame(width: 28.0, height: 28.0)
                                
                                if viewModel.presentSendActivityIndicator {
                                    ProgressView().foregroundColor(.black)
                                }
                            }
                        }
                        .disabled(viewModel.presentSendActivityIndicator)
                        .padding(.trailing, 12.0)
                        .padding(.bottom, -5)
                    }
                   
                }
                .padding(.vertical, 12)
                .padding(.horizontal)
            }
        }
        
    }
    
    // MARK: - Bottom sheets
    
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
    
    private func getEditSheet() -> some View {
        
        VStack(spacing: 10) {
            
            // copy message
            Button {
                viewModel.copyToClipBoard()
                editBottomSheetPosition = .hidden
            } label: {
                HStack(spacing: 14) {
                    Asset.copyIc.swiftUIImage
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(L10n.CorrespondenceView.copy)
                        .font(FontFamily.Poppins.bold.swiftUIFont(size: 14))
                }.frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding()
            .background(Asset.dark2.swiftUIColor)
            .foregroundColor(Asset.grey1.swiftUIColor)
            .cornerRadius(10)
            
            // tap my message
            if viewModel.checkSelectedMessageIsMine() {
                
                if viewModel.checkEditingMessage() {
                    // edit message
                    Button {
                        //edit
                        viewModel.textMessage = viewModel.selectedMessage?.message ?? ""
                        withAnimation {
                            editBottomSheetPosition = .hidden
                            isMessageEditing = true
                        }
                        
                    } label: {
                        HStack(spacing: 14) {
                            Asset.pencilIc.swiftUIImage
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(L10n.CorrespondenceView.editMessage)
                                .font(FontFamily.Poppins.bold.swiftUIFont(size: 14))
                        }.frame(minWidth: 0, maxWidth: .infinity)
                            
                    }
                    .padding()
                    .background(Asset.dark2.swiftUIColor)
                    .foregroundColor(Asset.grey1.swiftUIColor)
                    .cornerRadius(10)
                }
                
                // delete message
                Button {
                    viewModel.presentAlert = true
                    editBottomSheetPosition = .hidden
                } label: {
                    HStack(spacing: 14) {
                        Asset.trashIc.swiftUIImage
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(L10n.General.delete)
                            .font(FontFamily.Poppins.bold.swiftUIFont(size: 14))
                    }.frame(minWidth: 0, maxWidth: .infinity)
                        
                }
                .padding()
                .background(Asset.dark2.swiftUIColor)
                .foregroundColor(Asset.grey1.swiftUIColor)
                .cornerRadius(10)

            }

        }
    }
        
    // MARK: - Some methods
    
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
