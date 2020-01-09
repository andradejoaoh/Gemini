//
//  AnimalViewController.swift
//  Gemini
//
//  Created by João Henrique Andrade on 28/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//

import UIKit

class AnimalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
                                /* |-------------------|
                                   |VARIÁVEIS E OUTLETS|
                                   |-------------------| */
    var animal:Animal?
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var racaLabel: UILabel!
    @IBOutlet weak var sexoLabel: UILabel!
    @IBOutlet weak var idadeLabel: UILabel!
    @IBOutlet weak var bateriaLabel: UILabel!
    @IBOutlet weak var vacaImage: UIImageView!
    @IBOutlet weak var atividadesTableView: UITableView!
    
                                     /* |---------------|
                                        |FUNÇÕES DA VIEW|
                                        |---------------| */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        atividadesTableView.delegate = self
        atividadesTableView.dataSource = self
        atividadesTableView.rowHeight = 80
        
        guard let animal = animal else {return}
        idLabel.text = "ID: " + animal.id
        racaLabel.text = "Raça: " + animal.raca
        sexoLabel.text = "Sexo: " + animal.sexo
        idadeLabel.text = "Idade: 2 anos"
        bateriaLabel.text = "Bateria " + String(animal.bateria) + "%"
        vacaImage.image = UIImage(named: "\(animal.raca)Face")
    }
    
                             /* |--------------------|
                                |FUNÇÕES DA TABLEVIEW|
                                |--------------------| */

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        animal?.registroDeAtividades.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AtividadesCell = self.atividadesTableView.dequeueReusableCell(withIdentifier: "AtividadesCell") as! AtividadesCell
        guard let animal = animal else {return cell}
        cell.dataLabel.text = animal.registroDeAtividades[indexPath.row].dataAcontecimento
        cell.acaoLabel.text = animal.registroDeAtividades[indexPath.row].acontecimentos[0] 
        return cell
    }
}
