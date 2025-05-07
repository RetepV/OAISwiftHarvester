//
//  OAIIdentifyModel.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import Foundation

struct OAIIdentifyModel:  Codable, Identifiable, Hashable {
    
    var id: Self { self }
    
    enum DeletionStatus : Int, Codable {
        case noDeletion = 0
        case persistenDeletion = 1
        case transientDeletion = 2
        case other = 3
    }
    
    var repositoryName: String?
    var baseURL: String?
    var protocolVersion: String?
    var earliestDateStamp: String?
    var granularity: String?
    var deletionStatus: DeletionStatus?
    var adminEmails: [String]?
    var compressions: [String]?
    var descriptions: [String]?
}

