//
//  ABCViews.swift
//  SwiftUICoordinators
//
//  Created by Development on 5/10/2024.
//
import SwiftUI

enum ABCRoute: Hashable {
    case viewA, viewB, viewC
}


// MARK: - Flow Coordinators
class ABCFlowCoordinator: RootCrossFlowCoordinator {
    private weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func navigateTo(_ route: ABCRoute) {
        appCoordinator?.navigate(to: .abcFlow(route))
    }
    
    func navigateToNewFlow(_ route: AppRoute) {
        appCoordinator?.navigate(to: route)
    }
    
    func navigateBack() {
        appCoordinator?.navigateBack()
    }
    
    func navigateToRoot() {
        appCoordinator?.navigateToRoot()
    }
}


struct ABCViewFactory: ViewFactory {
    static func makeView(for route: ABCRoute, using coordinator: ABCFlowCoordinator) -> AnyView {
        switch route {
        case .viewA:
            return AnyView(ViewA(coordinator: coordinator))
        case .viewB:
            return AnyView(ViewB(coordinator: coordinator))
        case .viewC:
            return AnyView(ViewC(coordinator: coordinator))
        }
    }
}


// MARK: - Views
struct ViewA: View {
    let coordinator: ABCFlowCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("View A")
            Button("Go to B") { coordinator.navigateTo(.viewB) }
            Button("Go to C") { coordinator.navigateTo(.viewC) }
        }
        .navigationTitle("View A")
    }
}

struct ViewB: View {
    let coordinator: ABCFlowCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("View B")
            Button("Go to C") { coordinator.navigateTo(.viewC) }
            Button("Go back") { coordinator.navigateBack() }
        }
        .navigationTitle("View B")
    }
}

struct ViewC: View {
    let coordinator: ABCFlowCoordinator
   
    var body: some View {
        VStack(spacing: 20) {
            Text("View C")
            Button("Go to D") { coordinator.navigateToNewFlow(.defFlow(.viewD)) }
            Button("Go to C1") { coordinator.navigateToNewFlow(.c1c2c3Flow(.viewC1)) }
            Button("Go back") { coordinator.navigateBack() }
            Button("Go back to root") { coordinator.navigateToRoot() }
        }
        .navigationTitle("View C")
    }
}
