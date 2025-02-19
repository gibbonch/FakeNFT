typealias DependencyFactory<T> = () -> T

/// Класс для управления зависимостями.
final class DIContainer {
    static let shared = DIContainer()
    private var registry: [String: DependencyFactory<Any>] = [:]
    
    private init() {
        registerDependencies()
    }
    
    /**
     Регистрирует фабрику зависимости для указанного типа.
     
     - Parameters:
     - type: Тип зависимости, который нужно зарегистрировать.
     - factory: Фабрика для создания объекта типа `T`.
     
     - Note:
     Все зависимости регистрируются с использованием строкового представления типа в качестве ключа.
     */
    func register<T>(_ type: T.Type, factory: @escaping DependencyFactory<T>) {
        let key = String(describing: type)
        registry[key] = factory
    }
    
    /**
     Разрешает зависимость для указанного типа.
     
     - Parameters:
     - type: Тип зависимости, которую нужно разрешить.
     
     - Throws:
     - `DIContainerError.resolvingError`: если зависимость для указанного типа не была зарегистрирована.
     
     - Returns:
     Объект типа `T`, созданный с использованием зарегистрированной фабрики.
     */
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
