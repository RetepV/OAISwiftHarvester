//
//  Navigation.swift
//  OAISwiftHarvesterApp
//
//  Created by Peter de Vroomen on 17-04-2025.
//

import SwiftUI

enum NavigationDestinations: Hashable {
    case contentView
    case recordsView(OAISetModel)
    case detailView(OAIRecordModel)
}

@Observable
class NavigationState: ObservableObject {
    
    var navigationPath: [NavigationDestinations] = []
    
    func navigateTo(_ destination: NavigationDestinations) {
        navigationPath.append(destination)
    }
    
    func popView() {
        guard !navigationPath.isEmpty else {
            return
        }
        navigationPath.removeLast()
    }
}

class NavigationController {

    @ViewBuilder
    static func navigate(to destination: NavigationDestinations) -> some View {
        switch destination {
        case .contentView:
            ContentView()
        case .recordsView(let model):
            RecordsView(selectedSetItem: model)
        case .detailView(let model):
            DetailView(selectedRecordItem: model)
        default:
            fatalError("Unsupported destination: \(destination)")
        }
    }
}
