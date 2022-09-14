import Foundation
import SwiftUI

struct DatePickerTextField: UIViewRepresentable {
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    private let helper = Helper()
    
    public var placeholder: String
    @Binding public var date: Date?
    
    func makeUIView(context: Context) -> UITextField {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        if let date = date {
            datePicker.setDate(date, animated: false)
        }
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        
        textField.placeholder = placeholder
        textField.inputView = datePicker
        textField.tintColor = Asset.text.color
        textField.textColor = Asset.text.color
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: L10n.General.done, style: .done, target: helper, action: #selector(helper.doneButtonTapped))
        doneButton.tintColor = UIColor.black
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        
        helper.onDoneButtonTapped = {
            date = datePicker.date
            
            textField.resignFirstResponder()
        }
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        let datePicker = (uiView.inputView as? UIDatePicker)
        if let selectedDate = date {
            uiView.text = Date.dateFormatter.string(from: selectedDate)
            datePicker?.setDate(selectedDate, animated: true)
        } else {
            uiView.text = nil
            datePicker?.setDate(datePicker?.maximumDate ?? Date(), animated: false)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Helper {
        public var onDoneButtonTapped: (() -> Void)?
        
        @objc func doneButtonTapped() {
            onDoneButtonTapped?()
        }
    }
    
    class Coordinator {}
}
