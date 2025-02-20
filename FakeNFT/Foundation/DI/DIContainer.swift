/// Тип, представляющий фабрику для создания зависимостей.
///
/// `DependencyFactory` — это замыкание, которое возвращает экземпляр типа `T`.
/// Используется для регистрации и создания зависимостей в `DIContainer`.
typealias DependencyFactory<T> = () -> T?

/// Контейнер для управления зависимостями.
///
/// `DIContainer` предоставляет механизм для регистрации и разрешения зависимостей.
/// Поддерживает синглтон-паттерн, что позволяет использовать один экземпляр контейнера во всем приложении.
///
/// ## Пример использования:
/// ```swift
/// // Регистрация зависимости
/// DIContainer.shared.register(NetworkClient.self) {
///     return DefaultNetworkClient()
/// }
///
/// // Разрешение зависимости
/// let client: NetworkClient = try DIContainer.shared.resolve(NetworkClient.self)
/// ```
///
final class DIContainer {
    static let shared = DIContainer()
    private var registry: [String: DependencyFactory<Any>] = [:]

    private init() {
        registerDependencies()
    }

    /// Регистрирует фабрику для создания зависимости указанного типа.
    ///
    /// - Parameters:
    ///   - type: Тип зависимости, который нужно зарегистрировать.
    ///   - factory: Замыкание, которое создает экземпляр зависимости.
    ///
    func register<T>(_ type: T.Type, factory: @escaping DependencyFactory<T>) {
        let key = String(describing: type)
        registry[key] = factory
    }

    
    /// Разрешает зависимость для указанного типа.
    ///
    /// - Parameter type: Тип зависимости, которую нужно разрешить.
    /// - Returns: Экземпляр зависимости типа `T`.
    /// - Throws: Ошибка `DIContainerError.resolvingError`, если зависимость не была зарегистрирована.
    ///
    func resolve<T>(_ type: T.Type) throws -> T {
        let key = String(describing: type)
        guard let factory = registry[key],
              let instance = factory() as? T else {
            throw DIContainerError.resolvingError("\(T.self)")
        }
        return instance
    }
}

extension DIContainer {
    func registerDependencies() {
        register(NetworkClient.self) { DefaultNetworkClient() }
        register(NftStorage.self) { NftStorageImpl() }
        
        register(NftService.self) {
            guard let client = try? DIContainer.shared.resolve(NetworkClient.self),
                  let storage = try? DIContainer.shared.resolve(NftStorage.self) else {
                return nil
            }
            return NftServiceImpl(networkClient: client, storage: storage)
        }
    }
}

