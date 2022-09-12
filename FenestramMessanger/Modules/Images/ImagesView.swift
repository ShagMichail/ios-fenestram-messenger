//
//  ImagesView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI

struct ImagesView: View {
    
    
    //MARK: - Properties
    
    @State var uiTabarController: UITabBarController?
    @State private var selectedImage: UIImage?
    
    private var columns: [GridItem] = [
        GridItem(.fixed(UIScreen.screenWidth/3)),
        GridItem(.fixed(UIScreen.screenWidth/3)),
        GridItem(.fixed(UIScreen.screenWidth/3))]
    var images: [PhotoEntity]
    var i = 0
    
    init(images: [PhotoEntity]) {
        self.images = images
    }
    
    
    //MARK: - Body
    
    var body: some View {
        ZStack {
            Asset.thema.swiftUIColor.ignoresSafeArea()
            VStack {
                ImagesNavigationView()
                getListPhoto()
            }
            
            if let selectedImage = selectedImage {
                ZStack {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            self.selectedImage = nil
                        }
                    
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .cornerRadius(20)
                }
            }
        }
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }.onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
        .navigationBarHidden(true)
    }
    
    
    //MARK: - Views
    
    private func getListPhoto() -> some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns) {
                ForEach(images) { image in
                    Image(uiImage: image.image)
                        .resizable()
                        .onTapGesture {
                            selectedImage = image.image
                        }
                }
            }
        }
    }
}
