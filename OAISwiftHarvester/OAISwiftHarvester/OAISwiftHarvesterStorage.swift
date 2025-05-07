//
//  OAISwiftHarvesterStorage.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 15-04-2025.
//

import Foundation

@Observable
class OAISwiftHarvesterStorage: Identifiable, ObservableObject {

    let id = UUID()
    
    var identify: OAIIdentifyModel? = nil
    
    var metadataFormats: [OAIMetadataFormatModel]? = nil
    
    var sets: [OAISetModel]? = nil
    
    var records: [OAIRecordModel]? = nil
    var recordsResumptionToken: OAIResumptionTokenModel? = nil
    var hasMoreRecords: Bool { return recordsResumptionToken != nil }

    var identifiers: [OAIIdentifierModel]? = nil
    var identifiersResumptionToken: OAIResumptionTokenModel? = nil
    var hasMoreIdentifiers: Bool { return identifiersResumptionToken != nil }
}
