//
//  OAIResultModel.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import Foundation

struct OAIResultModel: Codable {

    var xmlns: String?
    var xmlnsxsi: String?
    var xsiSchemaLocation: String?
    
    var responseDate: String?
    var request: String?
    
    var error: OAIErrorModel?

    var record: OAIRecordModel?
    var identify: OAIIdentifyModel?
    
    var identifiers: OAIIdentifiersModel?
    var records: OAIRecordsModel?
    var metadataFormats: OAIMetadataFormatsModel?
    var sets: OAISetsModel?
    
    enum CodingKeys: String, CodingKey {
        case xmlns = "xmlns"
        case xmlnsxsi = "xmlns:xsi"
        case xsiSchemaLocation = "xsi:schemaLocation"
        
        case responseDate = "responseDate"
        case request = "request"
        
        case error = "error"
        
        case record = "GetRecord"
        case identify = "Identify"
        case identifiers = "ListIdentifiers"
        case records = "ListRecords"
        case metadataFormats = "ListMetadataFormats"
        case sets = "ListSets"
    }
}
