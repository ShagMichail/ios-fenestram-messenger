//
//  FileView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 27.07.2022.
//

import SwiftUI
import BottomSheet

struct FileView: View {
    
    
    //MARK: - Properties
    
    @State var uiTabarController: UITabBarController?
    
    @StateObject private var viewModel: ViewModel
    
    @AppStorage ("isColorThema") var isColorThema: Bool?
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    
    //MARK: - Body
    
    var body: some View {
        
        ZStack {
            Asset.background.swiftUIColor.ignoresSafeArea()
            
            VStack {
                FileNavigationView()
                Spacer().frame(height: 20)
                getListFile()
            }
        }
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }.onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
    }
    
    
    
    //MARK: - Views
    
    private func getListFile() -> some View {
        ScrollView(showsIndicators: false) {
            ForEach(viewModel.allFiles) { files in
                Button(action: {
                    
                }, label: {
                    getRowFile(files: files)
                }).padding(.leading, 15.0)
                    .padding(.trailing, 20.0)
                Spacer().frame(height: 20)
            }
        }
    }
    
    private func getRowFile(files: File) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor((isColorThema == false ? Asset.blue1.swiftUIColor : Asset.green1.swiftUIColor))
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
    }
}



struct FileView_Previews: PreviewProvider {
    static var previews: some View {
        FileView()
    }
}
