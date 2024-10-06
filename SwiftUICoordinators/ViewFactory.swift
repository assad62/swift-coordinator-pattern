//
//  ViewFactory.swift
//  SwiftUICoordinators
//
//  Created by Development on 5/10/2024.
//


// MARK: - View Factories
import SwiftUI
protocol ViewFactory {
    associatedtype RouteType: Hashable
    associatedtype CoordinatorType: Coordinator
    static func makeView(for route: RouteType, using coordinator: CoordinatorType) -> AnyView
}
