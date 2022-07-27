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
        
        init() {
            fillterFile()
        }
        

        private func fillterFile() {
            let files = allFiles
            var index = files.endIndex - 3
            if files.count > 3  {
                for _ in 0...2  {
                    recentFile.append(files[index])
                    index += 1
                }
                
            }
            
        }
    }
}
