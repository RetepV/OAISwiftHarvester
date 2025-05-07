//
//  RecordsView.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 15-04-2025.
//

import SwiftUI
import LaTeXSwiftUI

struct RecordsView: View {

    let selectedSetItem: OAISetModel
    
    @State
    private var recordSetFilter: String = ""
    @State
    private var storage: OAISwiftHarvesterStorage = OAISwiftHarvesterStorage()

    @EnvironmentObject
    private var navigationState: NavigationState
    @EnvironmentObject
    private var harvester: OAISwiftHarvester

    var body: some View {

#if DEBUG
        Self._printChanges()
#endif
        
        return VStack {

            // MARK: Filter bar
            
            HStack {
                ZStack {
                    Color.indigo.opacity(0.5)
                        .cornerRadius(4)
                        .frame(height: 30)
                    
                    TextField("Filter", text: $recordSetFilter)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.black)
                        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                }
                .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray, lineWidth: 2)
                )
            }
            .padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
            
            // MARK: List
            
            HStack {
                if let records = storage.records, records.count > 0 {
                    List(storage.records?.sorted(by: { left, right in
                        left.metadata?.first?.oaidcMetadata?.titles?.first ?? "" < right.metadata?.first?.oaidcMetadata?.titles?.first ?? ""
                    }) ?? [], id: \.id) { recordItem in
                        
                        let title = recordItem.metadata?.first?.oaidcMetadata?.titles?.first ?? "[no title]"
                        
                        if recordSetFilter.count < 2 || title.contains(recordSetFilter) {
                            
                            NavigationLink(value: NavigationDestinations.detailView(recordItem)) {
                                LaTeX(title)
                            }
                            .fontWeight(.heavy)
                            .foregroundStyle(Color.black)
                            .listRowBackground(Color.indigo.opacity(0.5))
                        }
                    }
                    .navigationDestination(for: NavigationDestinations.self) { destination in
                        NavigationController.navigate(to: destination)
                    }
                }
                else {
                    VStack {
                        Spacer()
                        Text("Fetching records, please wait...")
                        ProgressView()
                        Spacer()
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .containerBackground(Color.white.opacity(0), for: .navigation)
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        .toolbarVisibility(.visible, for: .automatic)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    navigationState.popView()
                } label: {
                    Image(systemName: "arrow.backward.square")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundStyle(.indigo.opacity(0.75))
                }
            }
            ToolbarItem(placement: .principal) {
                Text(selectedSetItem.name ?? "[unknown]")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
            }
            ToolbarItem(placement: .topBarTrailing) {
                // Here's a trick that will cause the title to properly center: an invisible image of
                // the size of the back button image.
                Image(systemName: "arrow.backward.square")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundStyle(.indigo.opacity(0.0))
            }
        }
        .background {
            ZStack {
                Image("arxiv")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: 10)
                Rectangle()
                    .opacity(0.1)
                    .background(.ultraThinMaterial.opacity(0.1))
                
            }
            .ignoresSafeArea(.all)
        }
        .environmentObject(harvester)
        .task {
            do {
                // Fetch records
                let recordsScope = OAISwiftHarvesterScope(setSpec: selectedSetItem.specifier,
                                                          metadataPrefix: "oai_dc")
                if let date = Calendar.current.date(byAdding: .day, value: -7, to: Date()),
                   let granularity = OAIGranularity(rawValue: storage.identify?.granularity ?? "YYYY-MM-DD") {
                    recordsScope.from = granularity.formattedDate(from: date)
                }
                try await harvester.fetchFirstRecords(scope: recordsScope, storage: storage)
            }
            catch {
                debugPrint(error)
                fatalError(error.localizedDescription)
            }
        }
    }
}

#Preview {
    RecordsView(selectedSetItem: OAISetModel(name: "Mathematical Physics", specifier: "math:math:MP", description: nil))
        .environmentObject(OAISwiftHarvester(baseURL: URL(string: "https://oaipmh.arxiv.org/oai")!))
}
