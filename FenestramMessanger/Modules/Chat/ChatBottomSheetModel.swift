//
//  ChatBottomSheetModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 19.07.2022.
//

import SwiftUI

extension ChatBottomSheetView {
    @MainActor
    final class ViewModel: ObservableObject {
        
        @Published var allFiles: [File] = [
            File(title: "fffff"),
            File(title: "aaaaa"),
            File(title: "ggggg"),
            File(title: "kkkkk"),
            File(title: "qqqqq")
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

