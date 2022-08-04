//
//  ImagesView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI

struct ImagesView: View {
    
    @State var uiTabarController: UITabBarController?
    
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
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        ForEach(images) { image in
                            Image(uiImage: image.image)
                                .resizable()
                        }
                    }
                }
            }
        }
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }.onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
    }
}
