//
//  OAIMetadataFormatModel.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import Foundation

struct OAIMetadataFormatsModel: Codable, Identifiable, Hashable {
    
    var id: Self { self }
    
    var metadataFormats: [OAIMetadataFormatModel]?
    
    enum CodingKeys: String, CodingKey {
        case metadataFormats = "metadataFormat"
    }
}

struct OAIMetadataFormatModel: Codable, Identifiable, Hashable {
    
    var id: Self { self }
    
    var prefix: String?
    var schema: String?
    var namespace: String?
    
    enum CodingKeys: String, CodingKey {
        case prefix = "metadataPrefix"
        case schema = "schema"
        case namespace = "metadataNamespace"
    }
}
