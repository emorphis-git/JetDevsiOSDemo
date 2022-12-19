//
//  Container.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

import UIKit

class Container: Resolver {

    private let lockQueue = DispatchQueue(label: "com.jetdevs.JetDevsHomeWork.Inject",
                                          attributes: .concurrent)

    private static var shared = Container()

    private var container: [String: Any] = [:]

    private init() { }

    func register<T>(_ type: T.Type, instance: T) {
       lockQueue.async(flags: .barrier) { [weak self] in
            self?.container["\(type.self)"] = instance
       }
    }

    func register<ServiceType>(_ type: ServiceType.Type, instanceClosure: (Resolver) -> ServiceType) {
        register(type, instance: instanceClosure(Container.shared))
    }

    func resolve<ServiceType>(_ type: ServiceType.Type) -> ServiceType {
        Container.resolve(type)
    }

    static func resolve<ServiceType>(_ type: ServiceType.Type) -> ServiceType {
        return shared.lockQueue.sync { () -> ServiceType in
            if let component = shared.container["\(type.self)"] as? ServiceType {
                return component
            } else {
                fatalError("Missing service with type: \(type) - Forgot binding?")
            }
        }
    }

    static func configure(configurationClosure: (Resolver) -> Void) {
        configurationClosure(shared)
    }
}
