//
//  DeleteAlertView.swift
//  FenestramMessanger
//
//  Created by pluto on 17.10.2022.
//

import SwiftUI

enum DeleteMessageFor {
    case all, me
}

struct DeleteAlertView: View {
    @Binding var show: Bool
    @Binding var actionForAll: DeleteMessageFor
    
    private let text: String = L10n.CorrespondenceView.alertDeleteMessage
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            VStack {
                VStack {
                    
                    VStack(alignment: .center) {
                        Text(text)
                            .multilineTextAlignment(.center)
                            .font(FontFamily.Poppins.bold.swiftUIFont(size: 18))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 32)
                    
                    VStack {
                        /// for me
                        Button {
                            actionForAll = .me
                        } label: {
                            HStack {
                                Text(L10n.CorrespondenceView.deleteForMe)
                                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 14))
                                    .foregroundColor(Asset.red.swiftUIColor)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Asset.buttonAlert.swiftUIColor)
                            .cornerRadius(6)
                        }
                        .onTapGesture {
                            withAnimation {
                                show.toggle()
                            }
                        }
                        /// for all
                        Button {
                            actionForAll = .all
                        } label: {
                            HStack {
                                Text(L10n.CorrespondenceView.deleteForEveryone)
                                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 14))
                                    .foregroundColor(Asset.red.swiftUIColor)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Asset.darkRed.swiftUIColor)
                            .cornerRadius(6)
                        }
                        .onTapGesture {
                            withAnimation {
                                show.toggle()
                            }
                        }
                        /// cancel
                        Button {
                            show.toggle()
                        } label: {
                            HStack {
                                Text(L10n.General.cancel)
                                    .font(FontFamily.Poppins.semiBold.swiftUIFont(size: 14))
                                    .foregroundColor(Asset.text.swiftUIColor)
                            }
                            .frame(height: 48)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .cornerRadius(6)
                        }
                        .onTapGesture {
                            withAnimation {
                                show.toggle()
                            }
                        }

                    }
                
                }
                .padding(.vertical, 25)
                
                .padding(.horizontal, 24)
            }
            .background(Asset.photoBack.swiftUIColor)
            .cornerRadius(25)
        }
        .padding(.horizontal, 24)
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.35) )
    }
}

struct DeleteAlertView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAlertView(show: .constant(true), actionForAll: .constant(.all))
    }
}
