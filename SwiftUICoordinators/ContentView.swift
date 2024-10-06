//
//  ContentView.swift
//  SwiftUICoordinators
//
//  Created by Development on 5/10/2024.
//

import SwiftUI


// MARK: - Route Types
enum AppRoute: Hashable {
    case abcFlow(ABCRoute)
    case defFlow(DEFRoute)
}

enum ABCRoute: Hashable {
    case viewA, viewB, viewC
}

enum DEFRoute: Hashable {
    case viewD, viewE
}

// MARK: - Protocols
protocol Coordinator: AnyObject {
    associatedtype RouteType: Hashable
    func navigateTo(_ route: RouteType)
    func navigateBack()
    func navigateToRoot()
}

protocol RootCoordinator: Coordinator {}

protocol CrossFlowNavigating: Coordinator {
    func navigateToNewFlow(_ route: AppRoute)
}

protocol RootCrossFlowCoordinator: RootCoordinator, CrossFlowNavigating {}

// MARK: - App Coordinator
final class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private var coordinators: [String: Any] = [:]
    
    init() {
        setupCoordinators()
    }
    
    private func setupCoordinators() {
        register(ABCFlowCoordinator(appCoordinator: self))
        register(DEFFlowCoordinator(appCoordinator: self))
    }
    
    private func register<T: Coordinator>(_ coordinator: T) {
        coordinators[String(describing: T.self)] = coordinator
    }
    
    func coordinator<T: Coordinator>(ofType type: T.Type) -> T {
        guard let coordinator = coordinators[String(describing: type)] as? T else {
            fatalError("Coordinator of type \(type) not registered")
        }
        return coordinator
    }
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
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

// MARK: - View Factories
protocol ViewFactory {
    associatedtype RouteType: Hashable
    associatedtype CoordinatorType: Coordinator
    static func makeView(for route: RouteType, using coordinator: CoordinatorType) -> AnyView
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
            Button("Go back") { coordinator.navigateBack() }
            Button("Go back to root") { coordinator.navigateToRoot() }
        }
        .navigationTitle("View C")
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
