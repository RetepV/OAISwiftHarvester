//
//  OAIIdentifierModel.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import Foundation

struct OAIIdentifiersModel: Codable, Identifiable, Hashable {
    
    var id: Self { self }
    
    var identifiers: [OAIIdentifierModel]?
    var resumptionToken: OAIResumptionTokenModel?
    
    enum CodingKeys: String, CodingKey {
        case identifiers = "header"
        case resumptionToken = "resumptionToken"
    }
}

struct OAIIdentifierModel: Codable, Identifiable, Hashable {
    
    var id: Self { self }
    
    var identifier: String?
    var datestamp: String?
    var specifiers: [String]?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "identifier"
        case datestamp = "datestamp"
        case specifiers = "setSpec"
    }
}
