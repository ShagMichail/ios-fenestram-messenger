//
//  ChatView.swift
//  TFN
//
//  Created by Михаил Шаговитов on 07.07.2022.
//

import SwiftUI

struct CorrespondenceView: View {
    
    @State var person: String
    @State var personImage: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    //    init() {
    //
    //        UINavigationBar.appearance().backgroundColor = UIColor(named: "page")
    //    }
    
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.white)
                Image("\(personImage)")
                    .resizable()
                    .frame(width: 40.0, height: 40.0)
                Text("\(person)")
                    .foregroundColor(Color.white)
                    .font(.system(size: 20))
            }
        }
    }
    
    var btnBell : some View {
        
        
        
        HStack {
            Button(action: {
                //self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image("video")
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                }
            }
            
            Button(action: {
                //self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image("phone")
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                }
            }
            
            
        }
    }
    
    var body: some View {
        ZStack {
            
            Color("thema").ignoresSafeArea()
            
            Text("Переписка!").foregroundColor(Color.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarItems(trailing: btnBell)
        .background(NavigationConfigurator { nc in
            nc.navigationBar.backgroundColor = UIColor(named: "page")
            //nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        })
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
