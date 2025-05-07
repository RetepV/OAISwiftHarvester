//
//  OAIDefinitions.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import Foundation

enum OAIError: Error {
    
    case baseURLMustBeProvided

    case failedToCreateURL
    
    case scopeMustBeProvided
    case storageMustBeProvided
    
    case resumptionTokenMustBeProvided
    case metadataPrefixMustBeProvided
    
    case noResponseFromServer
    case fetchingDataFailed(httpStatusCode: Int)
    
    case decodeXMLFailed(error: Error)
    
    case unexpectedResultError
    case requestError(code: String?, description: String?)
}

enum OAIRequestVerbs: String {
    
    case getRecord = "GetRecord"
    case identify = "Identify"
    case listIdentifiers = "ListIdentifiers"
    case listMetadataFormats = "ListMetadataFormats"
    case listRecords = "ListRecords"
    case listSets = "ListSets"

    var urlQueryItem: URLQueryItem {
        return URLQueryItem(name: "verb", value: self.rawValue)
    }
}

enum OAIGranularity: String {
    
    case day = "YYYY-MM-DD"
    case seconds = "YYYY-MM-DDThh:mm:ssZ"
    
    var dateFormat: String {
        switch self {
        case .day:
            return "yyyy-MM-dd"
        case .seconds:
            return "yyyy-MM-dd'T'HH:mm:ss'Z'"
        }
    }

    init?(rawValue: String) {
        switch rawValue {
        case "YYYY-MM-DD":
            self = .day
        case "YYYY-MM-DDThh:mm:ssZ":
            self = .seconds
        default:
            return nil
        }
    }
    
    func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.dateFormat
        return dateFormatter.string(from: date)
    }
}
