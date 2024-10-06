//
//  AppCoordinator.swift
//  SwiftUICoordinators
//
//  Created by Development on 5/10/2024.
//
import SwiftUI
// MARK: - Route Types
enum AppRoute: Hashable {
    case abcFlow(ABCRoute)
    case c1c2c3Flow(C1C2C3Route)
    case defFlow(DEFRoute)
}


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
        register(C1C2C3FlowCoordinator(appCoordinator: self))
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
