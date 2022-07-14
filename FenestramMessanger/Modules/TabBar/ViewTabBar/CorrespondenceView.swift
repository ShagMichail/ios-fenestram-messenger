//
//  ChatView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct CorrespondenceView: View {
    
    
    let contact: Contact
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    //        init() {
    //
    //            UINavigationBar.appearance().backgroundColor = UIColor(named: "page")
    //        }
    
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.white)
            }
        }
    }
    
    var title : some View {
        HStack {
            contact.image
                .resizable()
                .frame(width: 40.0, height: 40.0)
            Text(contact.name)
                .foregroundColor(Color.white)
                .font(.system(size: 20))
        }
        
    }
    
    var btnBell : some View {
        
        
        
        HStack {
            Button(action: {
                //self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Asset.video.swiftUIImage
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                }
            }
            
            Button(action: {
                //self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Asset.phone.swiftUIImage
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                }
            }
            
            
        }
    }
    
    var body: some View {
        ZStack {
            Asset.thema.swiftUIColor
                .ignoresSafeArea()
            
            VStack {
                RoundedRectangle(cornerRadius: 0)
                //.background(Color("buttonDis"))
                    .foregroundColor(Asset.buttonDis.swiftUIColor)
                    .frame(width: UIScreen.screenWidth, height: 100.0)
                    .ignoresSafeArea()
                Spacer()
            }
            Text("Переписка!").foregroundColor(Color.white)
        }
        .navigationBarBackButtonHidden(true)
        navigationBarItems(leading: title)
            .navigationBarItems(leading: btnBack)
            .navigationBarItems(trailing: btnBell)
    }
}
//
//struct CorrespondenceView_Previews: PreviewProvider {
//    static var previews: some View {
//        CorrespondenceView()
//    }
//}


struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
    
}
