//
//  ContentView.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 14-04-2025.
//

import SwiftUI
import SwiftData
import LaTeXSwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    private var storage: OAISwiftHarvesterStorage = OAISwiftHarvesterStorage()
    
    @State
    private var dataSetFilter: String = ""
    
    @StateObject
    private var navigationState: NavigationState = NavigationState()
    @StateObject
    private var harvester: OAISwiftHarvester = OAISwiftHarvester(baseURL: URL(string: "https://oaipmh.arxiv.org/oai")!)
    // private var harvester: OAISwiftHarvester = OAISwiftHarvester(baseURL: URL(string: "https://data.rijksmuseum.nl/oai")!)

    
    var body: some View {
        
#if DEBUG
        Self._printChanges()
#endif
        
        return VStack {
            
            NavigationStack(path: $navigationState.navigationPath) {
                
                VStack {
                    
                    // MARK: Filter bar
                    
                    HStack {
                        ZStack {
                            Color.indigo.opacity(0.5)
                                .cornerRadius(4)
                                .frame(height: 30)

                            TextField("Filter", text: $dataSetFilter)
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

                    List(storage.sets?.sorted(by: { $0.name ?? "" < $1.name ?? "" }) ?? [], id: \.id) { setItem in
                        
                        if dataSetFilter.count < 2 || (setItem.name ?? "").contains(dataSetFilter) {
                            NavigationLink(value: NavigationDestinations.recordsView(setItem)) {
                                Text(setItem.name ?? "[no name]")
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
                .scrollContentBackground(.hidden)
                .containerBackground(Color.white.opacity(0), for: .navigation)
                .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
                .toolbarVisibility(.visible, for: .automatic)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(storage.identify?.repositoryName ?? "[unknown]")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                    }
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
            }
            .environmentObject(navigationState)
            .environmentObject(harvester)
        }
        .ignoresSafeArea(.all)
        .task {
            do {
                // Fetch Identify information
                try await harvester.fetchIdentify(storage: storage)
                
                // Fetch known sets.
                try await harvester.fetchSets(storage: storage)
            }
            catch {
                debugPrint(error)
                fatalError(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
