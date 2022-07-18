//
//  Asset+Extensions.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 14.07.2022.
//

import SwiftUI

extension ImageAsset {
    var swiftUIImage: SwiftUI.Image {
        SwiftUI.Image(uiImage: self.image)
    }
}

extension ColorAsset {
    var swiftUIColor: SwiftUI.Color {
        SwiftUI.Color(self.color)
    }
}

extension FontConvertible {
    func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
        SwiftUI.Font(self.font(size: size))
    }
}
