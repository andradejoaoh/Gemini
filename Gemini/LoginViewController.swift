//
//  LoginViewController.swift
//  Gemini
//
//  Created by João Henrique Andrade on 16/01/20.
//  Copyright © 2020 João Henrique Andrade. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .darkContent
    }
}
