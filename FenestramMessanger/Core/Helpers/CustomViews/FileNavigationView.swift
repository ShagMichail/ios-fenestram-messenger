//
//  FileNavigationView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI

struct FileNavigationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
   
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    var body: some View {
        ZStack {
            Asset.dark1.swiftUIColor.ignoresSafeArea()
            
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
        HStack {

            VStack(alignment: .leading) {
                Text("Файлы")
                    .foregroundColor(Color.white)
                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 16))

                
            }
        }
    }
    
    var btnBell : some View {
        HStack {
            Button(action: {
                
            }) {
                HStack {
                    Asset.search.swiftUIImage
                        .resizable()
                        .frame(width: 20.0, height: 20.0)
                }
            }
        }
    }
}

struct FileNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        FileNavigationView()
    }
}
