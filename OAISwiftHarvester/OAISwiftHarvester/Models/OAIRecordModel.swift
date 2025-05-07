//
//  OAIRecordModel.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import Foundation

struct OAIRecordsModel: Codable, Identifiable, Hashable {
    
    var id: Self { self }
    
    var records: [OAIRecordModel]?
    var resumptionToken: OAIResumptionTokenModel?

    enum CodingKeys: String, CodingKey {
        case records = "record"
        case resumptionToken = "resumptionToken"
    }
}

struct OAIRecordModel: Codable, Identifiable, Hashable {
    
    var id: Int { self.hashValue }
    
    var header: OAIRecordHeaderModel?
    var metadata: [OAIMetadataContainerModel]?

    enum CodingKeys: String, CodingKey {
        case header = "header"
        case metadata = "metadata"
    }
}
