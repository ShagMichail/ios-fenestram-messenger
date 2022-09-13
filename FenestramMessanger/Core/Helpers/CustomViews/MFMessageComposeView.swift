//
//  MFMessageComposeView.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 07.09.2022.
//

import Foundation
import SwiftUI
import MessageUI

class MFMessageComposeViewCoordinator: NSObject, MFMessageComposeViewControllerDelegate {

    @Binding var isShown: Bool
    
    init(isShown: Binding<Bool>) {
        _isShown = isShown
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.isShown = false
    }
}

struct MFMessageComposeView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MFMessageComposeViewController
    typealias Coordinator = MFMessageComposeViewCoordinator
    
    let recipients: [String]
    @Binding var isShown: Bool
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: UIViewControllerRepresentableContext<MFMessageComposeView>) {
    }
    
    func makeCoordinator() -> MFMessageComposeView.Coordinator {
        return MFMessageComposeViewCoordinator(isShown: $isShown)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MFMessageComposeView>) -> MFMessageComposeViewController {
        
        let controller = UIViewControllerType()
        controller.body = L10n.MfMessageComposeView.message
        controller.recipients = recipients
        controller.messageComposeDelegate = context.coordinator
        return controller
    }
}

