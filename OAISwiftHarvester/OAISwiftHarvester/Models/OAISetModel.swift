//
//  OAISetModel.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import Foundation

struct OAISetsModel: Codable, Identifiable, Hashable {
    
    var id: Self { self }

    var sets: [OAISetModel]?
    
    enum CodingKeys: String, CodingKey {
        case sets = "set"
    }
}

struct OAISetModel: Codable, Identifiable, Hashable {
    
    var id: Int { self.hashValue }
    
    var name: String?
    var specifier: String?
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "setName"
        case specifier = "setSpec"
        case description = "setDescription"
    }
}
