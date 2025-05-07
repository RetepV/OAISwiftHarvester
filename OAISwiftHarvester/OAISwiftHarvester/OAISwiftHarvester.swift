//
//  OAISwiftHarvester.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import Foundation
import XMLCoder
import Algorithms

class OAISwiftHarvester: ObservableObject {
    
    var baseURL: URL? = nil
    
    required init(baseURL: URL) {
        self.baseURL = baseURL
    }
        
    // MARK: - Private
    
    // MARK: Utility
    
    private func makeScopedURL(scope: OAISwiftHarvesterScope?, from url: URL) -> URL {
        guard let scope else {
            return url
        }
        
        var urlWithScope = url
        
        if let setSpec = scope.setSpec {
            urlWithScope.append(queryItems: [URLQueryItem(name: "set", value: setSpec)])
        }
        
        if let metadataPrefix = scope.metadataPrefix {
            urlWithScope.append(queryItems: [URLQueryItem(name: "metadataPrefix", value: metadataPrefix)])
        }
        
        if let from = scope.from {
            urlWithScope.append(queryItems: [URLQueryItem(name: "from", value: from)])
        }
        
        if let until = scope.until {
            urlWithScope.append(queryItems: [URLQueryItem(name: "until", value: until)])
        }
        
        return urlWithScope
    }
    
    // MARK: - OAI-PMH Verbs
    
    // MARK: "getRecord"
    
    func fetchRecord(identifier: String, scope: OAISwiftHarvesterScope, storage: OAISwiftHarvesterStorage) async throws -> Void {
        try await doGetRecord(identifier: identifier, scope: scope, storage: storage)
    }
    
    private func doGetRecord(identifier: String, scope: OAISwiftHarvesterScope, storage: OAISwiftHarvesterStorage) async throws -> Void {
        
        guard let baseURL else {
            throw OAIError.baseURLMustBeProvided
        }
        
        guard scope.metadataPrefix != nil else {
            throw OAIError.metadataPrefixMustBeProvided
        }

        var url = baseURL.appending(queryItems: [OAIRequestVerbs.getRecord.urlQueryItem,
                                                 URLQueryItem(name: "identifier", value: identifier)])
        url = makeScopedURL(scope: scope, from: url)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw OAIError.noResponseFromServer
        }
        guard response.statusCode == 200 else {
            throw OAIError.fetchingDataFailed(httpStatusCode: response.statusCode)
        }

        do {
            let result: OAIResultModel = try XMLDecoder().decode(OAIResultModel.self, from: data)
            
            if let errorResult = result.error {
                throw OAIError.requestError(code: errorResult.code, description: errorResult.description)
            }
            else if let identifyResult = result.identify {
                storage.identify = identifyResult
            }
            else {
                throw OAIError.unexpectedResultError
            }
        }
        catch {
            throw OAIError.decodeXMLFailed(error: error)
        }
    }
    
    // MARK: "Identify"
    
    func fetchIdentify(storage: OAISwiftHarvesterStorage) async throws -> Void {
        try await doIdentify(storage: storage)
    }
    
    private func doIdentify(storage: OAISwiftHarvesterStorage) async throws -> Void {
        
        guard let baseURL else {
            throw OAIError.baseURLMustBeProvided
        }

        let url = baseURL.appending(queryItems: [OAIRequestVerbs.identify.urlQueryItem])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw OAIError.noResponseFromServer
        }
        guard response.statusCode == 200 else {
            throw OAIError.fetchingDataFailed(httpStatusCode: response.statusCode)
        }

        do {
            let result: OAIResultModel = try XMLDecoder().decode(OAIResultModel.self, from: data)
            
            if let errorResult = result.error {
                throw OAIError.requestError(code: errorResult.code, description: errorResult.description)
            }
            else if let identifyResult = result.identify {
                storage.identify = identifyResult
            }
            else {
                throw OAIError.unexpectedResultError
            }
        }
        catch {
            throw OAIError.decodeXMLFailed(error: error)
        }
    }
    
    // MARK: "ListIdentifiers"
    
    @discardableResult
    func fetchFirstIdentifiers(scope: OAISwiftHarvesterScope, storage: OAISwiftHarvesterStorage) async throws -> Bool {
        
        try await doListIdentifiers(scope: scope, storage: storage)
        
        return storage.hasMoreIdentifiers
    }
    
    @discardableResult
    func fetchNextIdentifiers(storage: OAISwiftHarvesterStorage) async throws -> Bool {
        
        if storage.hasMoreIdentifiers {
            try await doListIdentifiers(scope: nil, storage: storage)
        }

        return storage.hasMoreIdentifiers
    }
    
    private func doListIdentifiers(scope: OAISwiftHarvesterScope?, storage: OAISwiftHarvesterStorage) async throws -> Void {
        
        guard let baseURL else {
            throw OAIError.baseURLMustBeProvided
        }
        
        var url: URL?
        var clearStorageBeforeAppending: Bool = false

        if let scope {
            // If a scope is provided, we assume this is a new fetch.
            guard scope.metadataPrefix != nil else {
                throw OAIError.metadataPrefixMustBeProvided
            }
            url = baseURL.appending(queryItems: [OAIRequestVerbs.listIdentifiers.urlQueryItem])
            url = makeScopedURL(scope: scope, from: url!)
            clearStorageBeforeAppending = true
        }
        else {
            // If no scope is given, it must be a resumption.
            guard let resumptionToken = storage.identifiersResumptionToken else {
                throw OAIError.resumptionTokenMustBeProvided
            }
            url = baseURL.appending(queryItems: [OAIRequestVerbs.listIdentifiers.urlQueryItem,
                                                 URLQueryItem(name: "resumptionToken", value: resumptionToken.token)])
        }
        
        guard let url else {
            throw OAIError.failedToCreateURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw OAIError.noResponseFromServer
        }
        guard response.statusCode == 200 else {
            throw OAIError.fetchingDataFailed(httpStatusCode: response.statusCode)
        }

        do {
            let result: OAIResultModel = try XMLDecoder().decode(OAIResultModel.self, from: data)

            if let errorResult = result.error {
                throw OAIError.requestError(code: errorResult.code, description: errorResult.description)
            }
            else if let identifiersResult = result.identifiers {
                if let resumptionToken = identifiersResult.resumptionToken {
                    storage.identifiersResumptionToken = resumptionToken
                }
                // NOTE: There might be duplicates in the new data or even in the whole concatenated list.
                // NOTE: We want to eliminate ALL duplicates.
                // NOTE: storage is being observed, and we want only one change. So we need to make sure to
                //       set storage.records only once.
                var newIdentifiers: [OAIIdentifierModel] = []
                if clearStorageBeforeAppending {
                    newIdentifiers = identifiersResult.identifiers ?? []
                }
                else {
                    newIdentifiers = storage.identifiers ?? []
                    newIdentifiers.append(contentsOf: identifiersResult.identifiers ?? [])
                }
                storage.identifiers = .init(newIdentifiers.uniqued())
            }
            else {
                throw OAIError.unexpectedResultError
            }
        }
        catch {
            throw OAIError.decodeXMLFailed(error: error)
        }
    }
    
    // MARK: "ListMetadataFormats"
    
    final func fetchMetaDataFormats(identifier: String?, storage: OAISwiftHarvesterStorage) async throws -> Void {
        
        try await doListMetadataFormat(identifier: identifier, storage: storage)
    }
    
    private final func doListMetadataFormat(identifier: String?, storage: OAISwiftHarvesterStorage) async throws -> Void {
        
        guard let baseURL = baseURL else {
            throw OAIError.baseURLMustBeProvided
        }
        
        var url = baseURL.appending(queryItems: [OAIRequestVerbs.listMetadataFormats.urlQueryItem])
        
        if let identifier {
            url = url.appending(queryItems: [URLQueryItem(name: "identifier", value: identifier)])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw OAIError.noResponseFromServer
        }
        guard response.statusCode == 200 else {
            throw OAIError.fetchingDataFailed(httpStatusCode: response.statusCode)
        }

        do {
            let result: OAIResultModel = try XMLDecoder().decode(OAIResultModel.self, from: data)

            if let errorResult = result.error {
                throw OAIError.requestError(code: errorResult.code, description: errorResult.description)
            }
            else if let metadataFormatsResult = result.metadataFormats {
                storage.metadataFormats = metadataFormatsResult.metadataFormats
            }
            else {
                throw OAIError.unexpectedResultError
            }
        }
        catch {
            throw OAIError.decodeXMLFailed(error: error)
        }
    }
    
    // MARK: "ListRecords"
    
    @discardableResult
    func fetchFirstRecords(scope: OAISwiftHarvesterScope, storage: OAISwiftHarvesterStorage) async throws -> Bool {
        
        try await doListRecords(scope: scope, storage: storage)
        
        return storage.hasMoreIdentifiers
    }
    
    @discardableResult
    func fetchNextRecords(storage: OAISwiftHarvesterStorage) async throws -> Bool {
        
        if storage.hasMoreIdentifiers {
            try await doListIdentifiers(scope: nil, storage: storage)
        }

        return storage.hasMoreIdentifiers
    }
    
    private func doListRecords(scope: OAISwiftHarvesterScope?, storage: OAISwiftHarvesterStorage) async throws -> Void {
        
        guard let baseURL else {
            throw OAIError.baseURLMustBeProvided
        }
        
        var url: URL?
        var clearStorageBeforeAppending: Bool = false

        if let scope {
            // If a scope is provided, we assume this is a new fetch.
            guard scope.metadataPrefix != nil else {
                throw OAIError.metadataPrefixMustBeProvided
            }
            url = baseURL.appending(queryItems: [OAIRequestVerbs.listRecords.urlQueryItem])
            url = makeScopedURL(scope: scope, from: url!)
            clearStorageBeforeAppending = true
        }
        else {
            // If no scope is given, it must be a resumption.
            guard let resumptionToken = storage.identifiersResumptionToken else {
                throw OAIError.resumptionTokenMustBeProvided
            }
            url = baseURL.appending(queryItems: [OAIRequestVerbs.listRecords.urlQueryItem,
                                                 URLQueryItem(name: "resumptionToken", value: resumptionToken.token)])
        }
        
        guard let url else {
            throw OAIError.failedToCreateURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw OAIError.noResponseFromServer
        }
        guard response.statusCode == 200 else {
            throw OAIError.fetchingDataFailed(httpStatusCode: response.statusCode)
        }

        do {
            let result: OAIResultModel = try XMLDecoder().decode(OAIResultModel.self, from: data)

            if let errorResult = result.error {
                throw OAIError.requestError(code: errorResult.code, description: errorResult.description)
            }
            else if let recordsResult = result.records {
                // Allocate or clear storage
                if let resumptionToken = recordsResult.resumptionToken {
                    storage.recordsResumptionToken = resumptionToken
                }
                // NOTE: There might be duplicates in the new data or even in the whole concatenated list. We want
                //       to eliminate ALL duplicates, even though it's going to be a very heavy operation.
                
                // NOTE: storage is being observed, and we want only one change. So we need to make sure to
                //       set storage.records only once.
                var newRecords: [OAIRecordModel] = []
                if clearStorageBeforeAppending {
                    newRecords = recordsResult.records ?? []
                }
                else {
                    newRecords = storage.records ?? []
                    newRecords.append(contentsOf: recordsResult.records ?? [])
                }
                storage.records = .init(newRecords.uniqued())
            }
            else {
                throw OAIError.unexpectedResultError
            }
        }
        catch {
            throw OAIError.decodeXMLFailed(error: error)
        }
    }
    
    // MARK: "ListSets"
    
    final func fetchSets(storage: OAISwiftHarvesterStorage) async throws -> Void {
        try await doListSets(storage: storage)
    }

    final private func doListSets(storage: OAISwiftHarvesterStorage) async throws -> Void {
        
        guard let baseURL = baseURL else {
            throw OAIError.baseURLMustBeProvided
        }
        
        let url = baseURL.appending(queryItems: [OAIRequestVerbs.listSets.urlQueryItem])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw OAIError.noResponseFromServer
        }
        guard response.statusCode == 200 else {
            throw OAIError.fetchingDataFailed(httpStatusCode: response.statusCode)
        }
        
        do {
            let result: OAIResultModel = try XMLDecoder().decode(OAIResultModel.self, from: data)

            if let errorResult = result.error {
                throw OAIError.requestError(code: errorResult.code, description: errorResult.description)
            }
            else if let setsResult = result.sets {
                if storage.sets == nil {
                    storage.sets = .init()
                }
                // New list every time.
                storage.sets?.removeAll()
                // NOTE: There is no prevention of duplicate items, so unique the result.
                var newSets: [OAISetModel] = storage.sets ?? []
                newSets.append(contentsOf: setsResult.sets ?? [])
                storage.sets = .init(newSets.uniqued())
            }
            else {
                throw OAIError.unexpectedResultError
            }
        }
        catch {
            throw OAIError.decodeXMLFailed(error: error)
        }
    }
}
