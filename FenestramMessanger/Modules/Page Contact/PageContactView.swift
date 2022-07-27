//
//  PageContactView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI

struct PageContactView: View {
    @AppStorage ("isColorThema") var isColorThema: Bool?
    @StateObject private var viewModel: ViewModel
    var contact: UserEntity
    
    init(contact: UserEntity) {
        _viewModel = StateObject(wrappedValue: ViewModel())
        self.contact = contact
    }
    var body: some View {
        VStack{
            ZStack{
                Asset.tabBar.swiftUIColor.ignoresSafeArea()
                VStack {
                    HStack {
                        Asset.photo.swiftUIImage
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text(contact.name ?? " ")
                                .foregroundColor(.white)
                                .font(FontFamily.Poppins.regular.swiftUIFont(size: 18))
                            Text("@\(contact.nickname ?? " ")")
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
                        Asset.video.swiftUIImage
                            .resizable()
                            .frame(width: 60.0, height: 60.0)
                            .padding(.horizontal)
                    }
                    
                    Spacer().frame(width: 35.0)
                    
                    Button {
                        print("fff")
                    } label: {
                        Asset.phone.swiftUIImage
                            .resizable()
                            .frame(width: 60.0, height: 60.0)
                            .padding(.horizontal)
                    }
                }
                }
            }
        }
        Spacer().frame(height: 0)
        ZStack {
            Asset.buttonAlert.swiftUIColor
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
                    NavigationLink(destination: FileView().navigationBarHidden(true)){
                        Image(systemName: "chevron.down")
                            .frame(width: 10, height: 10)
                            .foregroundColor(Asset.fileText.swiftUIColor)
                    }

//                    Button {
//                        <#code#>
//                    } label: {
//                        Image(systemName: "chevron.down")
//                            .frame(width: 10, height: 10)
//                            .foregroundColor(Asset.fileText.swiftUIColor)
//                    }

                   
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
        Spacer().frame(height: 0)
        ZStack {
            Asset.buttonAlert.swiftUIColor.ignoresSafeArea()
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(L10n.ChatView.recentImage)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                        Text("\(viewModel.allFiles.count) изображений")
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
}

//struct PageContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageContactView()
//    }
//}
