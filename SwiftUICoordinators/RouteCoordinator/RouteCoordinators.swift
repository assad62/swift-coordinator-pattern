//
//  RouteCoordinators.swift
//  SwiftUICoordinators
//
//  Created by Development on 5/10/2024.
//

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
