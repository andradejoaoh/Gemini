//
//  EscanearViewController.swift
//  Gemini
//
//  Created by João Henrique Andrade on 28/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//
import UIKit
import CoreNFC

class AlertasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var alertasTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        alertasTableView.delegate = self
        alertasTableView.dataSource = self
        alertasTableView.rowHeight = 100
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlertasCell = self.alertasTableView.dequeueReusableCell(withIdentifier: "AlertasCell") as! AlertasCell
        cell.idAnimal.text = "Animal XXXX"
        cell.mensagemAlerta.text = "Animal fora de área"
        return cell
    }
    
}
