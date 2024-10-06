//
//  DEFViews.swift
//  SwiftUICoordinators
//
//  Created by Development on 5/10/2024.
//
import SwiftUI

enum DEFRoute: Hashable {
    case viewD, viewE
}

class DEFFlowCoordinator: Coordinator {
    private weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func navigateTo(_ route: DEFRoute) {
        appCoordinator?.navigate(to: .defFlow(route))
    }
    
    func navigateBack() {
        appCoordinator?.navigateBack()
    }
    
    func navigateToRoot() {
        appCoordinator?.navigateToRoot()
    }
}



struct DEFViewFactory: ViewFactory {
    static func makeView(for route: DEFRoute, using coordinator: DEFFlowCoordinator) -> AnyView {
        switch route {
        case .viewD:
            return AnyView(ViewD(coordinator: coordinator))
        case .viewE:
            return AnyView(ViewE(coordinator: coordinator))
        }
    }
}


struct ViewD: View {
    let coordinator: DEFFlowCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("View D")
            Button("Go to E") { coordinator.navigateTo(.viewE) }
            Button("Go back") { coordinator.navigateBack() }
        }
        .navigationTitle("View D")
    }
}

struct ViewE: View {
    let coordinator: DEFFlowCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("View E")
            Button("Go back") { coordinator.navigateBack() }
        }
        .navigationTitle("View E")
    }
}
