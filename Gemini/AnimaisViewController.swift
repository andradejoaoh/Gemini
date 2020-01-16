//
//  AnimaisViewController.swift
//  Gemini
//
//  Created by João Henrique Andrade on 28/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//

import UIKit

class AnimaisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
   
                            /* |-------------------|
                               |VARIÁVEIS E OUTLETS|
                               |-------------------| */
    
    var animais: [Animal] = []
    var animaisFiltrados: [Animal] = []
    var numeroArea: Int? = nil
    @IBOutlet weak var animaisTableView: UITableView!
    @IBOutlet weak var animaisSearchBar: UISearchBar!
    
                             /* |---------------|
                                |FUNÇÕES DA VIEW|
                                |---------------| */

    override func viewDidLoad() {
        super.viewDidLoad()
        animaisTableView.delegate = self
        animaisTableView.dataSource = self
        animaisTableView.rowHeight = 120
        animaisTableView.separatorStyle = .none
        animaisSearchBar.delegate = self
        self.animais = JSONHandler.shared.animais.filter{ $0.area == numeroArea ?? 1 }
        self.animaisFiltrados = animais
    }

    
    
                           /* |--------------------|
                              |FUNÇÕES DA TABLEVIEW|
                              |--------------------| */

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animaisFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AnimaisCell = self.animaisTableView.dequeueReusableCell(withIdentifier: "AnimaisCell") as! AnimaisCell
        cell.cellID.text = "ID: " + self.animaisFiltrados[indexPath.row].id
        cell.cellBateria.text = "Bateria " + String(self.animaisFiltrados[indexPath.row].bateria) + "%"
        cell.cellInformacoes.text = "Informação recebida há 2hrs"
        cell.cellImage.image = UIImage(named: self.animaisFiltrados[indexPath.row].raca)
        cell.layer.cornerRadius = 6
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
            AnimalViewController.animal = animaisFiltrados[indexPath?.row ?? 0]
        }
    }
    
    /* |--------------------|
       |FUNÇÕES DA SEARCHBAR|
       |--------------------| */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if animaisSearchBar.text == "" {
            animaisFiltrados = animais
        } else {
            animaisFiltrados = animais.filter({ (anAnimal) -> Bool in
                anAnimal.id.contains(searchText) || anAnimal.lote.contains(searchText) || String(anAnimal.bateria).contains(searchText)
            })
        }
        animaisTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        animaisSearchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        animaisSearchBar.endEditing(true)
        animaisSearchBar.resignFirstResponder()
        animaisFiltrados = animais
        animaisTableView.reloadData()
    }
}
