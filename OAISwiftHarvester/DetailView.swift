//
//  DetailView.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 16-04-2025.
//

import SwiftUI

struct DetailView: View {
    
    let selectedRecordItem: OAIRecordModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DetailView(selectedRecordItem: OAIRecordModel(header: OAIRecordHeaderModel(identifier: "aap:noot-mies:123",
                                                                               datestamp: "2025-04-16",
                                                                               specifiers: ["physics:hep-ph"],
                                                                               status: .noStatus),
                                                  metadata: [OAIMetadataContainerModel(oaidcMetadata: OAIDCMetadataModel(titles: ["Test item"],
                                                                                                                         creators: ["Peter de Vroomen"],
                                                                                                                         descriptions: ["This is a test item."],
                                                                                                                         dates: ["2025-04-16"]))]))
}
