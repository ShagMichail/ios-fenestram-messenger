//
//  TitleView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 26.07.2022.
//

import SwiftUI

struct CorrespondenceNavigationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var contact: UserEntity
    @AppStorage ("isColorThema") var isColorThema: Bool?
    @State var showSheet = false
    
    var body: some View {
        ZStack {
            Asset.buttonDis.swiftUIColor.ignoresSafeArea()
            HStack {
                btnBack
                title
                Spacer()
                btnBell
            }.padding(.leading, 15)
                .padding(.trailing, 15)
        }
        .frame(width: UIScreen.screenWidth, height: 60.0)
        
    }
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.white)
            }
        }
    }
    
    var title : some View {
        Button {
            self.showSheet.toggle()
        } label: {
            HStack {
                Asset.photo.swiftUIImage
                    .resizable()
                    .frame(width: 40.0, height: 40.0)
                
                VStack(alignment: .leading) {
                    Text(contact.name ?? L10n.General.unknown)
                        .foregroundColor(Color.white)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
                    
                    Text("В сети")
                        .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                    
                }
                
            }
        }.sheet(isPresented: $showSheet) {
            PageContactView(contact: contact)
        }
//
//        NavigationLink(destination: PageContactView(contact: contact).navigationBarHidden(true)) {
//            HStack {
//                Asset.photo.swiftUIImage
//                    .resizable()
//                    .frame(width: 40.0, height: 40.0)
//
//                VStack(alignment: .leading) {
//                    Text(contact.name ?? L10n.General.unknown)
//                        .foregroundColor(Color.white)
//                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))
//
//                    Text("В сети")
//                        .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
//                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
//
//                }
//
//            }
//        }
    }
    
    var btnBell : some View {
        HStack {
            Button(action: {
                
            }) {
                HStack {
                    Asset.video.swiftUIImage
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                }
            }
            
            Button(action: {
                
            }) {
                HStack {
                    Asset.phone.swiftUIImage
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                }
            }
        }
    }
}

//struct TitleView_Previews: PreviewProvider {
//    static var previews: some View {
//        TitleView()
//    }
//}
