//
//  ConfiguracoesViewController.swift
//  Gemini
//
//  Created by João Henrique Andrade on 28/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//

import UIKit

class ConfiguracoesViewController: UIViewController {

    @IBOutlet weak var botaoSair: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        botaoSair.layer.cornerRadius = 6
    }

    @IBAction func sair(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
