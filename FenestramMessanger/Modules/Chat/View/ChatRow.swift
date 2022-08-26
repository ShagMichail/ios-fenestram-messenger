//
//  ChatRow.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 18.07.2022.
//

//MARK: До лучших времен (если все же делать список чатов с отдельным файлом строки чата)
//import SwiftUI
//
//struct ChatRow: View {
//
//    let chat: ChatEntity
//
//    @AppStorage ("isColorThema") var isColorThema: Bool?
//
//    @Binding var bottomSheetPosition: BookBottomSheetPosition
//    @Binding var correspondence: Bool
//    @Binding var user: UserEntity?
//
//    init(chat: ChatEntity, showSheet: Binding<BookBottomSheetPosition>, correspondence: Binding<Bool>, user: Binding<UserEntity?>) {
//        _correspondence = correspondence
//        _bottomSheetPosition = showSheet
//        _user = user
//        self.chat = chat
//    }
//    var body: some View {
//        HStack() {
//            Button {
//                bottomSheetPosition = .bottom
//
//            } label: {
//                Asset.photo.swiftUIImage
//                    .resizable()
//                    .frame(width: 40.0, height: 40.0)
//                    .padding(.horizontal)
//            }
//            Button {
//                correspondence.toggle()
//
//            } label: {
//                VStack(alignment: .leading) {
//                    Text(chat.name)
//                        .foregroundColor(.white)
//                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
//                    Text(lastMessage()) //?? L10n.General.unknown)
//                        .foregroundColor(Asset.message.swiftUIColor)
//                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
//                    .lineLimit(1)
//                }
//
//                Spacer()
//
//                VStack {
//                    Text(lastMessageTime())
//                        .foregroundColor(Asset.message.swiftUIColor)
//                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
//
//                    Button(action: {
//                        print("ddd")
//                    }, label: {
//                        Image(systemName: "checkmark")
//                            .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
//                    })
//                    .padding(.trailing, 0.0)
//                    .disabled(true)
//
//                }
//            }
//        }
//    }
//
//    private func lastMessage() -> String {
//        guard let lastIndex = chat.messages?.last else { return "" }
//        return lastIndex.message
//    }
//
//    private func lastMessageTime() -> String {
//        guard let lastIndex = chat.messages?.last else { return "" }
//        return  lastIndex.createdAt?.formatted(.dateTime.hour().minute() ) ?? "01:09"
//    }
//}

