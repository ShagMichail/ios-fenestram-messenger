//
//  ChatView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 09.07.2022.
//

import SwiftUI
import BottomSheet


enum BookBottomSheetPosition: CGFloat, CaseIterable {
    case middle = 450, bottom = 300, hidden = 0
}

struct ChatView: View {
    //let gradient = Gradient(colors: [.red, .orange])
    @AppStorage ("isColorThema") var isColorThema: Bool?
    @State var bottomSheetPosition: BookBottomSheetPosition = .hidden
    @State var isShowingSheet = false
    @State var flag = false
    @State var chatUser: ChatEntity?
    @State var contact: UserEntity?
    
    @StateObject private var viewModel: ViewModel
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
//        contact = Settings.currentUser
//        if flag {
//            bottomSheetPosition = .bottom
//        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Asset.thema.swiftUIColor
                        .ignoresSafeArea()
                    
                    VStack {
                        getHeader()
                        
                        if viewModel.isLoading {
                            LoadingView()
                        } else {
                            if viewModel.chatList.isEmpty {
                            //if viewModel.allContacts.isEmpty {
                                getEmptyView()
                            } else {
                                getList()
                            }
                        }
                        
                    }
                    if viewModel.presentAlert {
                        AlertView(show: $viewModel.presentAlert, textTitle: $viewModel.textTitleAlert, text: $viewModel.textAlert)
                    }
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
               
                .navigationBarHidden(true)
            }
        }
    }
    
    private func getHeader() -> some View {
        HStack(alignment: .center){
            Text("FENESTRAM")
                .foregroundColor(Color.white)
                .font(FontFamily.Montserrat.semiBold.swiftUIFont(size: 22))
            Spacer()
            NavigationLink() {
                SettingsView()
            } label: {
                Image(systemName: "gearshape").foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                    .font(.system(size: 20))
            }
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
            ScrollView {
                if viewModel.chatList.count > 0 {
                    ForEach(viewModel.chatList) { chat in
                        Button(action: {
                            bottomSheetPosition = .bottom
                           // flag = true
                            chatUser = chat
                        }, label: {
                            ChatRow(chat: chat)
                        })
                        .padding(.horizontal)
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
            .padding(.bottom, 1)
            
        }.bottomSheet(bottomSheetPosition: self.$bottomSheetPosition, options: [.noDragIndicator, .allowContentDrag, .swipeToDismiss, .tapToDismiss, .absolutePositionValue, .background({ AnyView(Asset.buttonAlert.swiftUIColor) }), .cornerRadius(30)], headerContent: {
            //The name of the book as the heading and the author as the subtitle with a divider.
            VStack {
                HStack {
                    Asset.photo.swiftUIImage
                        .resizable()
                        .frame(width: 80.0, height: 80.0)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text(chatUser?.name ?? " ")
                            .foregroundColor(.white)
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
                        Text(getNicNameUsers())
                            .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
                    }
                    Spacer()
                }
                Spacer().frame(height: 30.0)
                HStack {
                    Button {
                        print("fff")
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 60, height: 60, alignment: .center)
                                .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(Asset.stroke.swiftUIColor, lineWidth: 1.5)
                                        )
                                .foregroundColor(Asset.buttonAlert.swiftUIColor)
                            Asset.videoButton.swiftUIImage
                                .foregroundColor((isColorThema == false) ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor)
                            
                        }
                    }
                    
                    Spacer().frame(width: 54.0)
                    
                    Button {
                        print("fff")
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
                    Spacer().frame(width: 54.0)
                    Button {
                        print("fff")
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 60, height: 60, alignment: .center)
                                .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(Asset.stroke.swiftUIColor, lineWidth: 1.5)
                                        )
                                .foregroundColor(Asset.buttonAlert.swiftUIColor)
                            Asset.messageButton.swiftUIImage
                                .foregroundColor((isColorThema == false) ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor)
                            
                        }
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
    }
    private func getNicNameUsers() -> String {
        let index = viewModel.allContacts.startIndex
        guard let users = chatUser?.usersId else { return "" }
        //var users = chatUser?.usersId
        //var i = 0
        var result = ""
        for userChatId in users {
            for userId in index ... viewModel.allContacts.endIndex - 1 {
                if userChatId.hashValue == viewModel.allContacts[userId].id.hashValue {
                    result.append("@")
                    result.append(viewModel.allContacts[userId].nickname ?? "")
                    result.append(" ")
                    if users.count == 2 {
                        contact = viewModel.allContacts[userId]
                    }
                }
            }
        }
        return result
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
