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
    var animaisEmAlerta: [Animal] = []
    var fazenda: Fazenda? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertasTableView.delegate = self
        alertasTableView.dataSource = self
        alertasTableView.rowHeight = 100
        fazenda = JSONHandler.shared.fazenda
        verificarAnimais()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animaisEmAlerta.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AlertasCell = self.alertasTableView.dequeueReusableCell(withIdentifier: "AlertasCell") as! AlertasCell
        cell.idAnimal.text = "Animal " + animaisEmAlerta[indexPath.item].id
        if animaisEmAlerta[indexPath.item].bateria > 10 {
            cell.imagemAlerta.image = UIImage(named: "animalDesaparecidoIcon")
            cell.mensagemAlerta.text = "Animal fora de área."

        } else {
            cell.imagemAlerta.image = UIImage(named: "battery-no")
            cell.mensagemAlerta.text = "Coleira com pouca bateria."
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "alertasSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = alertasTableView.indexPathForSelectedRow
        
        if let AnimalViewController = segue.destination as? AnimalViewController {
            AnimalViewController.animal = animaisEmAlerta[indexPath?.row ?? 0]
        }
    }
    
    func verificarAnimais(){
        guard let fazenda = fazenda else {return}
        let distancia: Double = Double(fazenda.raioDaFazenda/1000)
        for animal in JSONHandler.shared.animais{
            if animal.bateria <= 10 || animal.latitude > (fazenda.latitude + distancia) || animal.latitude < (fazenda.latitude - distancia) || animal.longitude < (fazenda.longitude - distancia) || animal.longitude > (fazenda.longitude + distancia) {
                animaisEmAlerta.append(animal)
            }
        }
    }
    
}
