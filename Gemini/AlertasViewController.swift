//
//  EscanearViewController.swift
//  Gemini
//
//  Created by João Henrique Andrade on 28/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//
import UIKit
import CoreNFC

class AlertasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
                      /* |-------------------|
                         |VARIÁVEIS E OUTLETS|
                         |-------------------| */
    
    @IBOutlet weak var alertasTableView: UITableView!
    @IBOutlet weak var alertasSearchBar: UISearchBar!
    var animaisEmAlerta: [Animal] = []
    var searchBarResultados: [Animal] = []
    var fazenda: Fazenda? = nil
    
                      /* |---------------|
                         |FUNÇÕES DA VIEW|
                         |---------------| */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertasTableView.delegate = self
        alertasTableView.dataSource = self
        alertasSearchBar.delegate = self
        alertasTableView.separatorStyle = .none
        alertasTableView.rowHeight = alertasTableView.frame.height*0.15
        fazenda = JSONHandler.shared.fazenda
        verificarAnimais()
    }
    
    
    /* |--------------------|
     |FUNÇÕES DA TABLEVIEW|
     |--------------------| */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBarResultados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlertasCell = self.alertasTableView.dequeueReusableCell(withIdentifier: "AlertasCell") as! AlertasCell
        cell.idAnimal.text = "Animal " + searchBarResultados[indexPath.item].id
        if searchBarResultados[indexPath.item].bateria > 10 {
            cell.imagemAlerta.image = UIImage(named: "animalDesaparecidoIcon")
            cell.mensagemAlerta.text = "Animal fora de área."
            
        } else {
            cell.imagemAlerta.image = UIImage(named: "battery-no")
            cell.mensagemAlerta.text = "Coleira com pouca bateria."
        }
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "alertasSegue", sender: self)
    }
    
    /* |----------------|
     |FUNÇÕES DA SEGUE|
     |----------------| */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = alertasTableView.indexPathForSelectedRow
        
        if let AnimalViewController = segue.destination as? AnimalViewController {
            AnimalViewController.animal = searchBarResultados[indexPath?.row ?? 0]
        }
    }
    
                      /* |-----------------|
                         |FUNÇÕES DA CLASSE|
                         |-----------------| */
    
    func verificarAnimais(){
        guard let fazenda = fazenda else {return}
        let distancia: Double = Double(fazenda.raioDaFazenda/1000)
        for animal in JSONHandler.shared.animais{
            if animal.bateria <= 10 || animal.latitude > (fazenda.latitude + distancia) || animal.latitude < (fazenda.latitude - distancia) || animal.longitude < (fazenda.longitude - distancia) || animal.longitude > (fazenda.longitude + distancia) {
                animaisEmAlerta.append(animal)
            }
        }
        searchBarResultados = animaisEmAlerta
    }
                          /* |--------------------|
                             |FUNÇÕES DA SEARCHBAR|
                             |--------------------| */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if alertasSearchBar.text == "" {
            searchBarResultados = animaisEmAlerta
        } else {
            searchBarResultados = animaisEmAlerta.filter({ (anAnimal) -> Bool in
                anAnimal.id.contains(searchText) || anAnimal.lote.contains(searchText) || String(anAnimal.bateria).contains(searchText)
            })
        }
        alertasTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        alertasSearchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        alertasSearchBar.endEditing(true)
        alertasSearchBar.resignFirstResponder()
        searchBarResultados = animaisEmAlerta
        alertasTableView.reloadData()
    }
    
}
