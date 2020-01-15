//
//  AreasViewController.swift
//  Gemini
//
//  Created by João Henrique Andrade on 28/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//

import UIKit
import CoreNFC

class AreasViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NFCNDEFReaderSessionDelegate {
        
                        /* |-------------------|
                           |VARIÁVEIS E OUTLETS|
                           |-------------------| */
    @IBOutlet weak var areasCollectionViewOutlet: UICollectionView!
    @IBOutlet weak var totalAnimais: UILabel!
    @IBOutlet weak var totalAreas: UILabel!
    var session: NFCNDEFReaderSession?
    var selectedCell: Int? = nil
    
                            /* |---------------|
                               |FUNÇÕES DA VIEW|
                               |---------------| */
    override func viewDidLoad() {
        super.viewDidLoad()
        areasCollectionViewOutlet.dataSource = self
        areasCollectionViewOutlet.delegate = self
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        totalAnimais.text = String(JSONHandler.shared.animais.count) + " Animais"
        totalAreas.text = String(JSONHandler.shared.fazenda!.qtdeAreas) + " Áreas"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
    }
    
                        /* |-------------------------|
                           |FUNÇÕES DA COLLECTIONVIEW|
                           |-------------------------| */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        JSONHandler.shared.fazenda?.qtdeAreas ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AreaCell = self.areasCollectionViewOutlet.dequeueReusableCell(withReuseIdentifier: "AreaCell", for: indexPath) as! AreaCell
        
        cell.numeroArea.text = "Área " + String(indexPath.row + 1)
        cell.quantidadeAnimais.text = "100 animais"
        cell.layer.cornerRadius = 6
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = Int(indexPath.row) + 1
        performSegue(withIdentifier: "animaisSegue", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.areasCollectionViewOutlet.frame.width/2 - 8, height: self.areasCollectionViewOutlet.frame.height*0.1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
                           /* |--------------|
                              |FUNÇÕES DO NFC|
                              |--------------| */
    
    @IBAction func escanear(_ sender: Any) {
        guard NFCNDEFReaderSession.readingAvailable else {
            let alertController = UIAlertController(
                title: "Scanning Not Supported",
                message: "This device doesn't support tag scanning.",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Encoste seu iPhone na etiqueta para escanear."
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                if let string = String(data: record.payload, encoding: .ascii) {
                    print(string)
                }
            }
        }
    }
    
                             /* |----------------|
                                |FUNÇÕES DE SEGUE|
                                |----------------| */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let AnimaisViewController = segue.destination as? AnimaisViewController {
            AnimaisViewController.numeroArea = selectedCell
        }
    }
}
