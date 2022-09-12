//
//  ChatView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 09.07.2022.
//

import SwiftUI
import BottomSheet
import Kingfisher

enum BookBottomSheetPosition: CGFloat, CaseIterable {
    case middle = 450, bottom = 300, hidden = 0
}

struct ChatView: View {
    
    
    //MARK: - Properties
    
    @State var uiTabarController: UITabBarController?
    @State var bottomSheetPosition: BookBottomSheetPosition = .hidden
    @State var isShowingSheet = false
    @State var flag = false
    @State var chatUser: ChatEntity?
    @State var correspondence = false
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    @StateObject private var viewModel: ViewModel
    
    init(socketManager: SocketIOManager?) {
        _viewModel = StateObject(wrappedValue: ViewModel(socketManager: socketManager))
    }
    
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Asset.thema.swiftUIColor
                        .ignoresSafeArea()
                    
                    NavigationLink(isActive: $viewModel.isShowNewChatView) {
                        NewChatView(isPopToChatListView: $viewModel.isShowNewChatView)
                    } label: {
                        EmptyView()
                    }


                    VStack {
                        getHeader()
                        if viewModel.isLoading && viewModel.page == 1 {
                            LoadingView()
                        } else {
                            viewModel.chatList.isEmpty ? AnyView(getEmptyView()) : AnyView(getList())
                        }
                    }
                    
                    if viewModel.presentAlert {
                        AlertView(show: $viewModel.presentAlert, text: viewModel.textAlert)
                    }
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                .onChange(of: viewModel.isShowNewChatView, perform: { newValue in
                    if newValue == false {
                        viewModel.reset()
                    }
                })
                .navigationBarHidden(true)
            }
        }
    }
    
    
    //MARK: - Views
    
    private func getHeader() -> some View {
        HStack(alignment: .center){
            Text("FENESTRAM")
                .foregroundColor(Color.white)
                .font(FontFamily.Montserrat.semiBold.swiftUIFont(size: 22))
            Spacer()
            // TODO: Ждем реализации поиска чатов на бэке
//            NavigationLink() {
//                //Search chats
//            } label: {
//                Image(systemName: "magnifyingglass").foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
//                    .font(.system(size: 20))
//            }
        }
        .padding()
    }
    
    private func getEmptyView() -> some View {
        VStack {
            Spacer()
            Asset.onboardingFirst.swiftUIImage
                .resizable()
                .scaledToFit()
            
            Spacer()
                .frame(height: 22)
            
            VStack(spacing: 20) {
                Text(L10n.ChatView.emptyText)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                    .foregroundColor(Asset.photoBack.swiftUIColor)
                    .multilineTextAlignment(.center)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func getList() -> some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                if viewModel.chatList.count > 0 {
                    LazyVStack {
                        ForEach(viewModel.chatList) { chat in
                            getChatRow(chat: chat)
                                .onAppear() {
                                    viewModel.loadMoreContent(currentItem: chat)
                                }
                        }
                        
                        if viewModel.isLoading && viewModel.page > 1 {
                            ProgressView()
                        }
                    }
                } else {
                    HStack {
                        Text(L10n.ContactView.contactDontExist)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 15))
                            .foregroundColor(Color.white)
                            .padding(.horizontal)
                    }.frame(width: UIScreen.screenWidth)
                }
                
                Spacer()
                    .frame(height: 92)
            }
            .padding(.bottom, 1)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    getButtonNewChat()
                }
            }
        }.bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: [.noDragIndicator, .allowContentDrag, .swipeToDismiss, .tapToDismiss, .absolutePositionValue, .background({ AnyView(Asset.buttonAlert.swiftUIColor) }), .cornerRadius(30)], headerContent: {
            
            getHeaderBottomSheet()
        }) {
            getBodyBottomSheet()
        }
    }
    
    private func getChatRow(chat: ChatEntity) -> some View {
        HStack() {
            Button {
                bottomSheetPosition = .bottom
                chatUser = chat
            } label: {
                VStack {
                    if let avatarString = chat.isGroup ? chat.avatar : viewModel.getContact(with: chat)?.avatar,
                       let url = URL(string: Constants.baseNetworkURLClear + avatarString),
                       !avatarString.isEmpty {
                        KFImage(url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40.0, height: 40.0)
                            .clipShape(Circle())
                    } else {
                        Asset.photo.swiftUIImage
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                    }
                }
                .padding(.horizontal)
            }
            
            NavigationLink {
                CorrespondenceView(contacts: viewModel.getUserEntity(from: chat), chat: chat, socketManager: viewModel.socketManager)
                
            } label: {
                VStack(alignment: .leading) {
                    Text(chat.isGroup ? chat.name : viewModel.getContact(with: chat)?.name ?? L10n.General.unknown)
                        .foregroundColor(.white)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                    Text(lastMessage(chat: chat))
                        .foregroundColor(Asset.message.swiftUIColor)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack {
                    Text(lastMessageTime(chat: chat))
                        .foregroundColor(Asset.message.swiftUIColor)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                    
                    Button(action: {
                        print("ddd")
                    }, label: {
                        Image(systemName: "checkmark")
                            .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                    })
                    .padding(.trailing, 0.0)
                    .disabled(true)
                }
            }
        }.padding(.horizontal)
    }
    
    private func getHeaderBottomSheet() -> some View {
        VStack {
            HStack {
                VStack {
                    if let avatarString = (chatUser?.isGroup ?? false) ? chatUser?.avatar : viewModel.getContact(with: chatUser)?.avatar,
                       let url = URL(string: Constants.baseNetworkURLClear + avatarString),
                       !avatarString.isEmpty {
                        KFImage(url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80.0, height: 80.0)
                            .clipShape(Circle())
                    } else {
                        Asset.photo.swiftUIImage
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text(((chatUser?.usersId.count ?? 2 > 2) ? chatUser?.name : viewModel.getUserEntity(from: chatUser).first?.name) ?? "")
                        .foregroundColor(.white)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
                    Text(viewModel.getNicNameUsers(chat: chatUser))
                        .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
                }
                Spacer()
            }
            Spacer().frame(height: 30.0)
            HStack {
                Button {
                    print("fff")
                } label: {
                    buttonsViewProperty(image: Asset.videoButton)
                }
                
                Spacer().frame(width: 54.0)
                
                Button {
                    print("fff")
                } label: {
                    buttonsViewProperty(image: Asset.phoneButton)
                }
                Spacer().frame(width: 54.0)
                
                NavigationLink(isActive: $correspondence) {
                    CorrespondenceView(contacts: viewModel.getUserEntity(from: chatUser), chat: chatUser, socketManager: viewModel.socketManager)
                } label:{
                    Button {
                        bottomSheetPosition = .hidden
                        self.correspondence.toggle()
                    } label: {
                        buttonsViewProperty(image: Asset.messageButton)
                    }
                    
                }
                
            }
        }
    }
    private func getBodyBottomSheet() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(L10n.ChatView.recentFiles)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Text("\(viewModel.allFiles.count) файлов")
                        .font(.system(size: 12))
                        .foregroundColor(Asset.fileText.swiftUIColor)
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .frame(width: 10, height: 10)
                    .foregroundColor(Asset.fileText.swiftUIColor)
            }.padding(.leading, 50.0)
                .padding(.trailing, 50.0)
            
            Spacer().frame(height: 25.0)
            
            ForEach(viewModel.recentFile) { files in
                Button(action: {
                    
                }, label: {
                    HStack {
                        Asset.file.swiftUIImage
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                            .padding(.horizontal)
                        Text(files.title)
                            .font(.system(size: 14))
                            .foregroundColor(Asset.fileText.swiftUIColor)
                        Spacer()
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 2))
                                .foregroundColor(Asset.fileText.swiftUIColor)
                            Spacer()
                                .frame(width: 3.0)
                            Image(systemName: "circle.fill")
                                .font(.system(size: 2))
                                .foregroundColor(Asset.fileText.swiftUIColor)
                            Spacer()
                                .frame(width: 3.0)
                            Image(systemName: "circle.fill")
                                .font(.system(size: 2))
                                .foregroundColor(Asset.fileText.swiftUIColor)
                        }
                    }
                }).padding(.leading, 35.0)
                    .padding(.trailing, 50.0)
                Spacer().frame(height: 20)
            }
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
    
    private func getButtonNewChat() -> some View {
        Button {
            viewModel.isShowNewChatView = true
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
    
    //MARK: - Cell setup functions

    private func lastMessage(chat: ChatEntity) -> String {
        guard let lastIndex = chat.messages?.last else {return ""}
        return lastIndex.message
    }
    
    private func lastMessageTime(chat: ChatEntity) -> String {
        guard let lastIndex = chat.messages?.last, let createdDate = lastIndex.createdAt else {return ""}
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: createdDate)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(socketManager: nil)
    }
}
