//
//  Animal.swift
//  Gemini
//
//  Created by João Henrique Andrade on 28/11/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//

import Foundation
struct Animal: Codable {
    let id: String
    let lote: String
    let area: Int
    let tipo: String
    let raca: String
    let sexo: String
    let bateria: Int
    let latitude: Double
    let longitude: Double
    let remedios: [Remedio]
    let registroDeAtividades: [Registro]
}
