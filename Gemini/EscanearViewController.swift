//
//  EscanearViewController.swift
//  Gemini
//
//  Created by João Henrique Andrade on 28/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//
import UIKit
import CoreNFC

class EscanearViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    var session: NFCNDEFReaderSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        escanear(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session = nil
    }
    override func viewWillAppear(_ animated: Bool) {
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        escanear(self)
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
}
