//
//  CorrespondenceViewExtension.swift
//  FenestramMessanger
//
//  Created by pluto on 19.10.2022.
//

import SwiftUI
import Combine
import BottomSheet
import AlertToast
import Kingfisher

extension CorrespondenceView {
    
    func getEditMessageView() -> some View {
        ZStack {
            
            ZStack(alignment: .bottom) {
                VStack {
                                        
                    HStack{
                        VStack(alignment: .leading, spacing: 4) {
                            
                            HStack(alignment: .top) {
                                Text(L10n.CorrespondenceView.editingMessage)
                                    .padding(.top, 10)
                                    .padding(.leading, 14)
                                    .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                                    .foregroundColor(Asset.blue1.swiftUIColor)
                                
                                Spacer()
                                
                                // close editing
                                Button {
                                    viewModel.textMessage.removeAll()
                                    withAnimation {
                                        isMessageEditing = false
                                    }
                                    
                                } label: {
                                    Asset.closeIc.swiftUIImage
                                        .resizable()
                                }
                                .frame(width: 16.0, height: 16.0)
                                .padding(.top, 10)
                                .padding(.trailing, 20)
                               
                            }
                            
                            Text(viewModel.selectedMessage?.message ?? "")
                                .padding()
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(2)
                                .font(FontFamily.Poppins.regular.swiftUIFont(size: 12))
                                .foregroundColor(Asset.grey1.swiftUIColor)
                            
                            if #available(iOS 16.0, *) {
                                getTextEditor(true)
                                    .scrollContentBackground(.hidden)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Asset.dark1.swiftUIColor)
                                        .frame(width: UIScreen.screenWidth - 80), alignment: .leading)
                            } else {
                                getTextEditor(true)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Asset.dark1.swiftUIColor)
                                        .frame(width: UIScreen.screenWidth - 80), alignment: .leading)
                            }
                        }
                        .frame(minHeight: 40, maxHeight: 260, alignment: .center)
                        .foregroundColor(Asset.text.swiftUIColor)
                        .accentColor(Asset.text.swiftUIColor)
                        .font(FontFamily.Poppins.regular.swiftUIFont(size: 14))
                        .background(RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Asset.background0.swiftUIColor)
                            .frame(width: UIScreen.screenWidth - 80), alignment: .leading)
                        .padding(.leading , 15)
                        .padding(.trailing , 50)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }

                HStack(alignment: .bottom) {
                    Spacer()
                    Button {
                        // send edit message
                        viewModel.editMessage()
                        viewModel.textMessage.removeAll()
                        viewModel.selectedMessage = nil
                        withAnimation {
                            isMessageEditing = false
                        }
                    } label: {
                        (isColorThema == false ? Asset.sendMessageIc.swiftUIImage : Asset.sendMessageGreen.swiftUIImage)
                            .resizable()
                            .frame(width: 28.0, height: 28.0)
                    }
                    .padding(.trailing, 16.0)
                    .padding(.bottom, 5)
                }

            }
        }
    }
    
}
