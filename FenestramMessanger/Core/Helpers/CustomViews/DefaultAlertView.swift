//
//  DefaultAlertView.swift
//  FenestramMessanger
//
//  Created by pluto on 17.10.2022.
//

import SwiftUI

struct DefaultAlertView: View {
    @Binding var show: Bool
    @Binding var action: Bool
    let text: String
    
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
                    
                    HStack {
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
                            .background(Asset.buttonAlert.swiftUIColor)
                            .cornerRadius(6)
                        }
                        .onTapGesture {
                            withAnimation {
                                show.toggle()
                            }
                        }
                        
                        Button {
                            action.toggle()
                        } label: {
                            HStack {
                                Text(L10n.General.delete)
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

struct DefaultAlertView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultAlertView(show: .constant(true), action: .constant(false), text: "Some text")
    }
}


