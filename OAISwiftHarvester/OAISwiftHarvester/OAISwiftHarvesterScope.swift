//
//  OAISwiftHarvesterScope.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 15-04-2025.
//

import Foundation

class OAISwiftHarvesterScope {
    
    var setSpec: String? = nil
    var metadataPrefix: String? = nil
    var from: String? = nil
    var until: String? = nil
    
    init(setSpec: String? = nil, metadataPrefix: String? = nil, from: String? = nil, until: String? = nil) {
        self.setSpec = setSpec
        self.metadataPrefix = metadataPrefix
        self.from = from
        self.until = until
    }
    
    // MARK: - Helper functions
    
    static func scopeForListIdentifiers(setSpec: String? = nil, metadataPrefix: String? = nil, from: String? = nil, until: String? = nil) -> OAISwiftHarvesterScope {
        OAISwiftHarvesterScope(setSpec: setSpec, metadataPrefix: metadataPrefix, from: from, until: until)
    }

    static func scopeForListRecords(setSpec: String? = nil, metadataPrefix: String? = nil, from: String? = nil, until: String? = nil) -> OAISwiftHarvesterScope {
        OAISwiftHarvesterScope(setSpec: setSpec, metadataPrefix: metadataPrefix, from: from, until: until)
    }
    
    static func scopeForGetRecord(metadataPrefix: String? = nil) -> OAISwiftHarvesterScope {
        OAISwiftHarvesterScope(setSpec: nil, metadataPrefix: metadataPrefix, from: nil, until: nil)
    }
}
