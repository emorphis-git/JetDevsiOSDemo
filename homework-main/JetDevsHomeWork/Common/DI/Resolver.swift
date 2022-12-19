//
//  Resolver.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

// swiftlint: disable empty_first_line
protocol Resolver {
    /// Registers a new service.
    /// - Parameters:
    ///   - type: Base service type
    ///   - instance: Instance to be registered.
    func register<ServiceType>(_ type: ServiceType.Type, instance: ServiceType)

    /// Registers a new service and provides a closure with a resolver to resolve dependencies.
    /// - Parameters:
    ///   - type: Base service type
    ///   - instanceClosure: A closure that returns the resolved service.
    func register<ServiceType>(_ type: ServiceType.Type, instanceClosure: (Resolver) -> ServiceType)

    /// Resolves a service for a given type
    /// - Parameter type: the type of the service to be resolved
    func resolve<ServiceType>(_ type: ServiceType.Type) -> ServiceType

    /// Resolves a service for a given type
    /// - Parameter type: the type of the service to be resolved
    static func resolve<ServiceType>(_ type: ServiceType.Type) -> ServiceType

    /// Provides a `Resolver` to allow for configuration and registration.
    /// - Parameter configurationClosure: Closure for configuration
    static func configure(configurationClosure: (Resolver) -> Void)
}
