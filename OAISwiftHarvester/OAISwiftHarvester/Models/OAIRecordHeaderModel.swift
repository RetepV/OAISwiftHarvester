//
//  OAIRecordHeaderModel.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import Foundation

struct OAIRecordHeaderModel: Codable, Identifiable, Hashable {
    
    var id: Self { self }
    
    enum RecordStatus: Int, Codable {
        case noStatus = 0
        case statusDeleted = 1
    }

    var identifier: String?
    var datestamp: String?
    var specifiers: [String]?
    var status: RecordStatus?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "identifier"
        case datestamp = "datestamp"
        case specifiers = "setSpec"
        case status = "status"
    }
}
