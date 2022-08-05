//
//  PageContactViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI

extension PageContactView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        
        //MARK: - Properties
        
        @Published var isLoading: Bool = false
        @Published var allFiles: [File] = [
            File(title: "FFFFF", data: "22.02.22", volume: "10 MB"),
            File(title: "fffff", data: "22.02.22", volume: "10 MB"),
            File(title: "aaaaa", data: "22.02.22", volume: "10 MB"),
            File(title: "ggggg", data: "22.02.22", volume: "10 MB"),
            File(title: "kkkkk", data: "22.02.22", volume: "10 MB"),
            File(title: "qqqqq", data: "22.02.22", volume: "10 MB")
        ]
        @Published var recentFile: [File] = []
        @Published var allPhoto: [PhotoEntity] = [
            PhotoEntity(id: 0, image: Asset.defaultImage.image),
            PhotoEntity(id: 1, image: Asset.defaultImage.image),
            PhotoEntity(id: 2, image: Asset.defaultImage.image),
            PhotoEntity(id: 3, image: Asset.defaultImage.image),
            PhotoEntity(id: 4, image: Asset.defaultImage.image),
            PhotoEntity(id: 5, image: Asset.defaultImage.image),
            PhotoEntity(id: 6, image: Asset.defaultImage.image),
            PhotoEntity(id: 7, image: Asset.defaultImage.image),
            PhotoEntity(id: 8, image: Asset.defaultImage.image),
            PhotoEntity(id: 9, image: Asset.defaultImage.image),
            PhotoEntity(id: 10, image: Asset.defaultImage.image),
        ]
        @Published var recentPhotoFirst: [PhotoEntity] = []
        @Published var recentPhotoSecond: [PhotoEntity] = []
        
        var index = 0
        
        init() {
            fillterFile()
            fillterPhotoFirst()
            fillterPhotoSecond()
        }
        
        
        //MARK: - Auxiliary functions
        
        private func fillterFile() {
            let files = allFiles
            var index = 0
            if files.count > 3  {
                for _ in 0...2  {
                    recentFile.append(files[index])
                    index += 1
                }
            }
        }
        
        private func fillterPhotoFirst() {
            let files = allPhoto
            if files.count > 0  {
                for _ in 0...2  {
                    recentPhotoFirst.append(files[index])
                    index += 1
                }
            }
        }
        
        private func fillterPhotoSecond() {
            let files = allPhoto
            if files.count > 3  {
                for _ in 0...2  {
                    recentPhotoSecond.append(files[index])
                    index += 1
                }
            }
        }
    }
}
