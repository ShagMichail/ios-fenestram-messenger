//
//  ChatBottomSheet.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 18.07.2022.
//

import SwiftUI

struct ChatBottomSheetView: View {
    
    var index = 0
    
    @StateObject private var viewModel: ViewModel
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        VStack {
//            ZStack {
//                Asset.navBar.swiftUIColor
//
//                VStack {
//                    HStack {
//
//                        Asset.photo.swiftUIImage
//                            .resizable()
//                            .frame(width: 80.0, height: 80.0)
//                            .padding(.horizontal)
//
//                        VStack(alignment: .leading) {
//                            Text("fdfsdf")
//                                .foregroundColor(.white)
//                                .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
//                            Text("asdfsdf")
//                                .foregroundColor(Asset.blue.swiftUIColor)
//                                .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
//                        }
//                        Spacer()
//                    }
//                    Spacer().frame(height: 30.0)
//                    HStack {
//                        Button {
//                            print("fff")
//                        } label: {
//                            Asset.video.swiftUIImage
//                                .resizable()
//                                .frame(width: 60.0, height: 60.0)
//                                .padding(.horizontal)
//                        }
//                        Spacer().frame(width: 54.0)
//
//                        Button {
//                            print("fff")
//                        } label: {
//                            Asset.phone.swiftUIImage
//                                .resizable()
//                                .frame(width: 60.0, height: 60.0)
//                                .padding(.horizontal)
//                        }
//                        Spacer().frame(width: 54.0)
//                        Button {
//                            print("fff")
//                        } label: {
//                            Asset.messageIcon.swiftUIImage
//                                .resizable()
//                                .frame(width: 60.0, height: 60.0)
//                                .padding(.horizontal)
//                        }
//
//                    }
//                }
//                //.padding(.bottom, -26)
//            }.frame(height: 220.0)
//            Spacer().frame(height: 0.0)
//            ZStack {
//                Asset.page.swiftUIColor
//                    //.ignoresSafeArea()
//                VStack {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(L10n.ChatView.recentFiles)
//                                .font(.system(size: 14))
//                                .foregroundColor(.white)
//                            Text("\(viewModel.allFiles.count) файлов")
//                                .font(.system(size: 12))
//                                .foregroundColor(Asset.photoBack.swiftUIColor)
//                        }
//                        Spacer()
//                        Image(systemName: "chevron.down")
//                            .frame(width: 10, height: 10)
//                            .foregroundColor(Asset.photoBack.swiftUIColor)
//                    }.padding()
//
//                    Spacer().frame(height: 25.0)
//
//                    ScrollView {
//
//                        ForEach(viewModel.recentFile) { files in
//                            Button(action: {
//
//                            }, label: {
//                                HStack {
//                                    Asset.file.swiftUIImage
//                                        .resizable()
//                                        .frame(width: 20.0, height: 20.0)
//                                        .padding(.horizontal)
//                                    Text(files.title)
//                                        .font(.system(size: 14))
//                                        .foregroundColor(Asset.photoBack.swiftUIColor)
//                                    Spacer()
//                                    HStack {
//                                        Image(systemName: "circle.fill")
//                                            .font(.system(size: 2))
//                                            .foregroundColor(Asset.photoBack.swiftUIColor)
//                                        Spacer()
//                                            .frame(width: 3.0)
//                                        Image(systemName: "circle.fill")
//                                            .font(.system(size: 2))
//                                            .foregroundColor(Asset.photoBack.swiftUIColor)
//                                        Spacer()
//                                            .frame(width: 3.0)
//                                        Image(systemName: "circle.fill")
//                                            .font(.system(size: 2))
//                                            .foregroundColor(Asset.photoBack.swiftUIColor)
//                                    }
//                                }.padding()
//                            })
//                        }
//                    }.frame(height: 180.0)
//
//                }
//
//            }.frame(height: 300.0)
//        }
            
            Rectangle().frame(height: 200.0)
                .foregroundColor(Color.blue)
            Spacer().frame(height: 0.0)
            Rectangle().frame(height: 350)
                .foregroundColor(Color.red)
        }
    }
}

struct ChatBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        ChatBottomSheetView()
    }
}
