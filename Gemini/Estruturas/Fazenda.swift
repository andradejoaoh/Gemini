//
//  Fazenda.swift
//  Gemini
//
//  Created by João Henrique Andrade on 04/12/19.
//  Copyright © 2019 João Henrique Andrade. All rights reserved.
//

import Foundation
class Fazenda: Codable {
    let usuario: String
    let senha: String
    let nomeFazenda: String
    let qtdeAreas: Int
    let latitude: Double
    let longitude: Double
    let raioDaFazenda: Int
}
