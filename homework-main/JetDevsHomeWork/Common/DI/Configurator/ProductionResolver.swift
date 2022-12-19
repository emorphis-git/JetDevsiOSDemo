//
//  ProductionResolver.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

import UIKit

enum ProductionResolver: ResolverConfigurator {
    /// Registers the production dependencies to the provided resolver.
    /// - Parameter resolver: The resolver to be configured
    static func configure() {
        Container.configure { resolver in

            // MARK: - Foundation
            // This is use on app to store data and manage fileManager
            resolver.register(UserDefaults.self, instance: UserDefaults.standard)
            resolver.register(NotificationCenter.self, instance: NotificationCenter.default)
            resolver.register(FileManager.self, instance: FileManager.default)
            resolver.register(UIPasteboard.self, instance: UIPasteboard.general)

            // MARK: - Instances
            resolver.register(JetDevsAPI.self, instance: JetDevsService())
        }
    }
}
