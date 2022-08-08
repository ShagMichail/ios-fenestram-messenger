//
//  TextField.swift
//  FenestramMessanger
//
//  Created by Михаил Шаговитов on 06.07.2022.
//

import UIKit

extension  UITextField {
   @objc func doneButtonTapped(button:UIBarButtonItem) -> Void {
      self.resignFirstResponder()
   }
}

