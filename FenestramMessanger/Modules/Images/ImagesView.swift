//
//  ImagesView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI

struct ImagesView: View {
    private var columns: [GridItem] = [
        GridItem(.fixed(UIScreen.screenWidth/3)),
        GridItem(.fixed(UIScreen.screenWidth/3)),
        GridItem(.fixed(UIScreen.screenWidth/3))]
    var images: [PhotoEntity]
    var i = 0
    init(images: [PhotoEntity]) {
        self.images = images
    }
    
    var body: some View {
        ZStack {
            Asset.thema.swiftUIColor.ignoresSafeArea()
            VStack {
                ImagesNavigationView()
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(images) { image in
                            Image(uiImage: image.image)
                                .resizable()
                            //.frame(width: UIScreen.screenWidth/3, height: UIScreen.screenWidth/3)
                                //.cornerRadius(15)
                        }
                    }
                }
                //                    ForEach(images) { image in
                //                        if i
                //                        HStack {
                //                            Button {
                //                                print("fff")
                //                            } label: {
                //                                Image(uiImage: image.image)
                //                                    .resizable()
                //                                    .frame(width: UIScreen.screenWidth/3, height: UIScreen.screenWidth/3)
                //                                    .cornerRadius(15)
                //                            }
                //
                //                        }
                //                    }
                //                }
            }
        }
        
    }
}

//struct ImagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagesView()
//    }
//}
