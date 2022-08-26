//
//  File.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 19.07.2022.
//

import SwiftUI

struct File: Identifiable {
    var id = UUID()
    var title: String
    var data: String
    var volume: String
}
