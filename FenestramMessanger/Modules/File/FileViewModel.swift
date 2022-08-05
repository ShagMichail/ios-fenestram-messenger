//
//  FileViewModel.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI

extension FileView {
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
    }
}
