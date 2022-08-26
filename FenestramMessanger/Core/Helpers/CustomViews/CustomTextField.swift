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
        self.obj.size = view.contentSize.height
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = true
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

class observed: ObservableObject {
    @Published var size: CGFloat = 0
}


struct WrappedTextView: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    let textDidChange: (UITextView) -> Void

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
        DispatchQueue.main.async {
            self.textDidChange(uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, textDidChange: textDidChange)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        let textDidChange: (UITextView) -> Void

        init(text: Binding<String>, textDidChange: @escaping (UITextView) -> Void) {
            self._text = text
            self.textDidChange = textDidChange
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
            self.textDidChange(textView)
        }
    }
}
