//
//  ImagesView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI

struct ImagesView: View {
    //MARK: Проперти
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
    //MARK: Боди
    var body: some View {
        ZStack {
            Asset.thema.swiftUIColor.ignoresSafeArea()
            VStack {
                ImagesNavigationView()
                getListPhoto()
            }
        }
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }.onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
    }
    //MARK: Получаем все вью
    private func getListPhoto() -> some View {
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
