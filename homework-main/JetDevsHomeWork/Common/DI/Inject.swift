//
//  Inject.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

@propertyWrapper
struct Inject<Component>: Codable {

    init() { }

    // Decodable
    init(from decoder: Decoder) throws {
        self.init()
    }

    // Encodable
    func encode(to encoder: Encoder) throws { }

    var wrappedValue: Component {
        get { Container.resolve(Component.self) }
        mutating set { Container.configure { $0.register(Component.self, instance: newValue) } }
    }
}
