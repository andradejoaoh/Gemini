//
//  KeyboardHandler.swift
//  Gemini
//
//  Created by João Henrique Andrade on 16/01/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
