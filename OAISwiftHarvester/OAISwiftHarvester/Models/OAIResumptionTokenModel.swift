//
//  OAIResumptionTokenModel.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import Foundation

struct OAIResumptionTokenModel : Codable, Identifiable, Hashable {
    
    var id: Self { self }
    
    var expirationDate: String?
    var token: String?
    var completeListSize: Int?
    var cursor: Int?
    
    enum CodingKeys: String, CodingKey {
        case expirationDate = "expirationDate"
        case token = ""
        case completeListSize = "completeListSize"
        case cursor = "cursor"
    }
}
