//
//  CustomTextField.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 03.08.2022.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    
    @EnvironmentObject var obj: observed
    
    func makeCoordinator() -> Coordinator {
        return CustomTextField.Coordinator(parent1: self)
    }
    
    
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextView {
        let view = UITextView()
        view.font = .systemFont(ofSize: 19)
        view.text = "Введите ваше сообщение"
        view.textColor = Asset.text.color
        view.backgroundColor = .clear
        view.delegate = context.coordinator
        return view
    }
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<CustomTextField>) {
        
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        var parent: CustomTextField
        init(parent1: CustomTextField){
            parent = parent1
        }
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
            textView.textColor = Asset.text.color
        }
        func textViewDidChange(_ textView: UITextView) {
            self.parent.obj.size = textView.contentSize.height
        }
    }
}

class observed: ObservedObject {
    @Published var size: CGFloat = 0
}
