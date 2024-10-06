//
//  C1C2C3Views.swift
//  SwiftUICoordinators
//
//  Created by Development on 5/10/2024.
//
import SwiftUI
enum C1C2C3Route: Hashable {
    case viewC1, viewC2, viewC3
}

// MARK: - Flow Coordinators
class C1C2C3FlowCoordinator:RootCoordinator {
    private weak var appCoordinator: AppCoordinator?
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func navigateTo(_ route: C1C2C3Route) {
        appCoordinator?.navigate(to: .c1c2c3Flow(route))
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


struct C1C2C3ViewFactory: ViewFactory {
    static func makeView(for route: C1C2C3Route, using coordinator: C1C2C3FlowCoordinator) -> AnyView {
        switch route {
        case .viewC1:
            return AnyView(ViewC1(coordinator: coordinator))
        case .viewC2:
            return AnyView(ViewC2(coordinator: coordinator))
        case .viewC3:
            return AnyView(ViewC3(coordinator: coordinator))
        }
    }
}


// MARK: - Views
struct ViewC1: View {
    let coordinator: C1C2C3FlowCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("View C1")
            Button("Go to C2") { coordinator.navigateTo(.viewC2) }
          
        }
        .navigationTitle("View C1")
    }
}

struct ViewC2: View {
    let coordinator: C1C2C3FlowCoordinator
    
    var body: some View {
        VStack(spacing: 20) {
            Text("View C2")
            Button("Go to C3") { coordinator.navigateTo(.viewC3) }
            Button("Go back") { coordinator.navigateBack() }
        }
        .navigationTitle("View C2")
    }
}

struct ViewC3: View {
    let coordinator: C1C2C3FlowCoordinator
   
    var body: some View {
        VStack(spacing: 20) {
            Text("View C3")
       
            Button("Go back") { coordinator.navigateBack() }
            Button("Go back to root") { coordinator.navigateToRoot() }
        }
        .navigationTitle("View C3")
    }
}
