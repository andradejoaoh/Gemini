//
//  AnimaisViewController.swift
//  Gemini
//
//  Created by João Henrique Andrade on 28/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//

import UIKit

class AnimaisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
                            /* |-------------------|
                               |VARIÁVEIS E OUTLETS|
                               |-------------------| */
    
    var animais: [Animal] = []
    var numeroArea: Int? = nil
    @IBOutlet weak var animaisTableView: UITableView!

    
                             /* |---------------|
                                |FUNÇÕES DA VIEW|
                                |---------------| */

    override func viewDidLoad() {
        super.viewDidLoad()
        animaisTableView.delegate = self
        animaisTableView.dataSource = self
        animaisTableView.rowHeight = 130
        self.animais = JSONHandler.shared.animais.filter{ $0.area == numeroArea ?? 1 }
    }

    
    
                           /* |--------------------|
                              |FUNÇÕES DA TABLEVIEW|
                              |--------------------| */

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animais.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AnimaisCell = self.animaisTableView.dequeueReusableCell(withIdentifier: "AnimaisCell") as! AnimaisCell
        cell.cellID.text = "ID: " + self.animais[indexPath.row].id
        cell.cellBateria.text = "Bateria " + String(self.animais[indexPath.row].bateria) + "%"
        cell.cellInformacoes.text = "Informação recebida há 2hrs"
        cell.cellImage.image = UIImage(named: self.animais[indexPath.row].raca)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "atividadesSegue", sender: self)
    }
    
                                /* |----------------|
                                   |FUNÇÕES DA SEGUE|
                                   |----------------| */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = animaisTableView.indexPathForSelectedRow
        
        if let AnimalViewController = segue.destination as? AnimalViewController {
            AnimalViewController.animal = animais[indexPath?.row ?? 0]
        }
    }

}
