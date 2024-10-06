//
//  ContentView.swift
//  SwiftUICoordinators
//
//  Created by Development on 5/10/2024.
//

import SwiftUI

// MARK: - Content View
struct ContentView: View {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $appCoordinator.path) {
            ABCViewFactory.makeView(for: .viewA, using: appCoordinator.coordinator(ofType: ABCFlowCoordinator.self))
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .abcFlow(let abcRoute):
                        ABCViewFactory.makeView(for: abcRoute, using: appCoordinator.coordinator(ofType: ABCFlowCoordinator.self))
                    case .defFlow(let defRoute):
                        DEFViewFactory.makeView(for: defRoute, using: appCoordinator.coordinator(ofType: DEFFlowCoordinator.self))
                    case .c1c2c3Flow(let c1C2C3Route):
                        C1C2C3ViewFactory.makeView(for: c1C2C3Route, using: appCoordinator.coordinator(ofType: C1C2C3FlowCoordinator.self))
                    }
                
                }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
