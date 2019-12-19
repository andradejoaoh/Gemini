//
//  JSONHandler.swift
//  Gemini
//
//  Created by João Henrique Andrade on 28/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//

import Foundation
class JSONHandler {
    
    static let shared = JSONHandler()
    private init() {}
    
    var animais: [Animal] = []
    var fazenda: Fazenda?
    
    func readAnimaisJson() {
        guard let fileUrl = Bundle.main.url(forResource: "Animal", withExtension: "json") else {
            print("File could not be located at the given url")
            return
        }
        do {
            let data = try Data(contentsOf: fileUrl)
            animais = try JSONDecoder().decode([Animal].self, from: data)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func readFazendaJson() {
        guard let fileUrl = Bundle.main.url(forResource: "Fazenda", withExtension: "json") else {
            print("File could not be located at the given url")
            return
        }
        do {
            let data = try Data(contentsOf: fileUrl)
            fazenda = try JSONDecoder().decode(Fazenda.self, from: data)
        } catch {
            print("Error: \(error)")
        }
    }
}
