//
//  FileView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI
import BottomSheet

struct FileView: View {
    
    @StateObject private var viewModel: ViewModel
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        
        ZStack {
            Asset.thema.swiftUIColor.ignoresSafeArea()
            VStack {
                FileNavigationView()
                Spacer().frame(height: 20)
                ScrollView(showsIndicators: false) {
                    ForEach(viewModel.allFiles) { files in
                        Button(action: {
                            
                        }, label: {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor((isColorThema == false ? Asset.blue.swiftUIColor : Asset.green.swiftUIColor))
                                        .frame(width: 32, height: 32)
                                    Asset.fileWhite.swiftUIImage
                                        .resizable()
                                        .frame(width: 13.0, height: 16.0)
                                        .padding(.horizontal)
                                }
                                VStack(alignment: .leading) {
                                    Text(files.title)
                                        .font(.system(size: 14))
                                        .foregroundColor(Asset.fileText.swiftUIColor)
                                    Text(files.volume)
                                        .font(.system(size: 12))
                                        .foregroundColor(Asset.fileText.swiftUIColor)
                                }
                                Spacer()
                                HStack {
                                    Text(files.data)
                                        .font(.system(size: 12))
                                        .foregroundColor(Asset.fileText.swiftUIColor)
                                }
                            }
                        }).padding(.leading, 15.0)
                            .padding(.trailing, 20.0)
                        Spacer().frame(height: 20)
                    }
                }
            }
        }
    }
}

struct FileView_Previews: PreviewProvider {
    static var previews: some View {
        FileView()
    }
}
