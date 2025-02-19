typealias DependencyFactory<T> = () -> T

final class DIContainer {
    static let shared = DIContainer()
    private var registry: [String: DependencyFactory<Any>] = [:]
    
    private init() {
        registerDependencies()
    }
    
    func register<T>(_ type: T.Type, factory: @escaping DependencyFactory<T>) {
        let key = String(describing: type)
        registry[key] = factory
    }

    func resolve<T>(_ type: T.Type) throws -> T {
        let key = String(describing: type)
        guard let factory = registry[key] as? DependencyFactory<T> else {
            throw DIContainerError.resolvingError("\(T.self)")
        }
        return factory()
    }
}

extension DIContainer {
    private func registerDependencies() {
        register(NetworkClient.self) { DefaultNetworkClient() }
        register(NftStorage.self) { NftStorageImpl() }
    }
}
