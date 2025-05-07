//
//  OAIMetadataContainerModel.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import Foundation
import XMLCoder

struct OAIMetadataContainerModel: Codable, Identifiable, Hashable {
    
    var id: Self { self }
    
    var oaidcMetadata: OAIDCMetadataModel?
    
    enum CodingKeys: String, CodingKey {
        case oaidcMetadata = "oai_dc:dc"
    }
}
