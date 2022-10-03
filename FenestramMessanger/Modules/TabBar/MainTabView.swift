//
//  TabView.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct MainTabView: View {
    
    
    //MARK: - Properties
    
    @State var selectionTabView = 0
    
    @StateObject private var viewModel: ViewModel
    
    init(socketManager: SocketIOManager?) {
        _viewModel = StateObject(wrappedValue: ViewModel(socketManager: socketManager))
    }
    
    //MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ForEach(TabType.allCases) { tabType in
                    tabType.getContentView(with: viewModel.socketManager, showTabBar: $viewModel.showTabBar)
                        .opacity(viewModel.selectedTab == tabType ? 1 : 0)
                }
            }
            
            if viewModel.showTabBar {
                ZStack {
                    Asset.dark1.swiftUIColor
                    
                    HStack {
                        ForEach(TabType.allCases) { tabType in
                            tabType.getTabItemView(isSelected: viewModel.selectedTab == tabType)
                                .onTapGesture {
                                    viewModel.selectedTab = tabType
                                }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 16)
                }
                .frame(height: 96)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(socketManager: nil)
    }
}
