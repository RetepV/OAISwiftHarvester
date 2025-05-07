//
//  OAIDCMetadataModel.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 16-04-2025.
//

import Foundation

// NOTE: According to the XML schema for the Unqualified Dublin Core metadata, every entry can appear 0 or more times. Hence everything is an array.

struct OAIDCMetadataModel: Codable, Identifiable, Hashable {
    
    var id: Self { self }
    
    var titles: [String]?
    var creators: [String]?
    var subjects: [String]?
    var descriptions: [String]?
    var publishers: [String]?
    var contributors: [String]?
    var dates: [String]?
    var types: [String]?
    var formats: [String]?
    var identifiers: [String]?
    var sources: [String]?
    var languages: [String]?
    var relations: [String]?
    var coverages: [String]?
    var rights: [String]?
    
    enum CodingKeys: String, CodingKey {
        case titles = "dc:title"
        case creators = "dc:creator"
        case subjects = "dc:subject"
        case descriptions = "dc:description"
        case publishers = "dc:publisher"
        case contributors = "dc:contributor"
        case dates = "dc:date"
        case types = "dc:type"
        case formats = "dc:format"
        case identifiers = "dc:identifier"
        case sources = "dc:source"
        case languages = "dc:language"
        case relations = "dc:relation"
        case coverages = "dc:coverage"
        case rights = "dc:rights"
    }
}
