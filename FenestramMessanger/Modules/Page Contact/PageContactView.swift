//
//  PageContactView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI

struct PageContactView: View {
   // @GestureState private var dragOffset = CGSize.zero
    @AppStorage ("isColorThema") var isColorThema: Bool?
    @StateObject private var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode//: Binding<PresentationMode>
    var contact: UserEntity
   // @Binding var showModal: Bool
    
    init(contact: UserEntity) {
        _viewModel = StateObject(wrappedValue: ViewModel())
        self.contact = contact
        //_showModal = showModal
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
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 30)
//                                .frame(width: 60, height: 60, alignment: .center)
//                                .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
//                                .foregroundColor(Asset.buttonAlert.swiftUIColor)
//
//                        }
                        
                        
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
                }
                }
            }
        }.onBackSwipe {
            presentationMode.wrappedValue.dismiss()
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
//
//                    NavigationLink(destination: FileView().navigationBarHidden(true)){
//                        self.showModal = false
//                        Image(systemName: "chevron.down")
//                            .frame(width: 10, height: 10)
//                            .foregroundColor(Asset.fileText.swiftUIColor)
//                    }

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
                    //Spacer().frame(height: 20)
                }
            }
        }.onBackSwipe {
            presentationMode.wrappedValue.dismiss()
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
                        Text("\(viewModel.allPhoto.count) изображений")
                            .font(.system(size: 12))
                            .foregroundColor(Asset.fileText.swiftUIColor)
                    }
                    Spacer()
                    NavigationLink(destination: ImagesView(images: viewModel.allPhoto).navigationBarHidden(true)){
                        Image(systemName: "chevron.down")
                            .frame(width: 10, height: 10)
                            .foregroundColor(Asset.fileText.swiftUIColor)
                    }
                }.padding(.leading, 50.0)
                    .padding(.trailing, 50.0)
                
                Spacer().frame(height: 15.0)
                
                HStack {
                    ForEach(viewModel.recentPhotoFirst) { photo in
                        Button(action: {
                            
                        }, label: {
                            
                            HStack {
                                Image(uiImage: photo.image)
                                    .resizable()
                                    .frame(width: 90, height: 90, alignment: .leading)
                                    .cornerRadius(15)
                            }
                        })
                        Spacer().frame(width: 10)
                    }
                }
                HStack {
                    ForEach(viewModel.recentPhotoSecond) { photo in
                        
                        Button(action: {
                            
                        }, label: {
                            
                            HStack {
                                if photo.id == 5 && viewModel.allPhoto.count > 6 {
                                    ZStack {
                                        Image(uiImage: photo.image)
                                            .resizable()
                                            .frame(width: 90, height: 90, alignment: .leading)
                                            .cornerRadius(15)
                                            
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 15)
                                                .frame(width: 90, height: 90)
                                                .foregroundColor(Color.primary.opacity(0.35))
                                        Text("\(viewModel.allPhoto.count - 6)+")
                                            .foregroundColor(Color.white)
                                            .font(FontFamily.Poppins.regular.swiftUIFont(size: 24))
                                        }
                                    }

                                } else {
                                    
                                    Image(uiImage: photo.image)
                                        .resizable()
                                        .frame(width: 90, height: 90, alignment: .leading)
                                        .cornerRadius(15)
                                }
                                
                            }
                        })
                        Spacer().frame(width: 10)
                    }
                }
            }.padding(.bottom, 20)
        }.onBackSwipe {
            presentationMode.wrappedValue.dismiss()
        }
        
    }
        
}

//struct PageContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageContactView()
//    }
//}
