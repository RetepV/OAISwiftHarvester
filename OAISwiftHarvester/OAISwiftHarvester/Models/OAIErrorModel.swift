//
//  OAIErrorModel.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import Foundation

struct OAIErrorModel:  Codable, Identifiable, Hashable {
    
    var id: Self { self }
    
    var code: String?
    var description: String?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case description = ""
    }
}
