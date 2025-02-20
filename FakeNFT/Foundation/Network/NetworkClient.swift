import Foundation

/// Протокол для выполнения сетевых запросов.
///
/// `NetworkClient` предоставляет асинхронные методы для отправки сетевых запросов и обработки ответов.
/// Поддерживает как сырые данные (`Data`), так и декодируемые модели (`Decodable`).
///
protocol NetworkClient {
    /// Отправляет сетевой запрос и возвращает сырые данные (`Data`) в completion handler.
    ///
    /// - Parameters:
    ///   - request: Модель запроса, содержащая URL, метод и тело (опционально).
    ///   - completionQueue: Очередь, на которой будет выполнен completion handler.
    ///   - onResponse: Completion handler, который вызывается с результатом выполнения запроса.
    ///
    /// - Returns: Объект `NetworkTask`, который может быть использован для отмены запроса.
    @discardableResult
    func send(request: NetworkRequest,
              completionQueue: DispatchQueue,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask?
    
    
    /// Отправляет сетевой запрос и декодирует ответ в указанный тип `T`, где `T` соответствует протоколу `Decodable`.
    ///
    /// - Parameters:
    ///   - request: Модель запроса, содержащая URL, метод и тело (опционально).
    ///   - type: Тип, в который должен быть декодирован ответ. Должен соответствовать протоколу `Decodable`.
    ///   - completionQueue: Очередь, на которой будет выполнен completion handler.
    ///   - onResponse: Completion handler, который вызывается с результатом выполнения запроса.
    ///
    /// - Returns: Объект `NetworkTask`, который может быть использован для отмены запроса.
    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            completionQueue: DispatchQueue,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask?
}

extension NetworkClient {
    /// Отправляет сетевой запрос и возвращает сырые данные (`Data`) в completion handler.
    /// Completion handler выполняется на главной очереди.
    ///
    /// - Parameters:
    ///   - request: Модель запроса, содержащая URL, метод и тело (опционально).
    ///   - onResponse: Completion handler, который вызывается с результатом выполнения запроса.
    ///
    /// - Returns: Объект `NetworkTask`, который может быть использован для отмены запроса.
    @discardableResult
    func send(request: NetworkRequest,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask? {
        send(request: request, completionQueue: .main, onResponse: onResponse)
    }
    
    
    /// Отправляет сетевой запрос и декодирует ответ в указанный тип `T`, где `T` соответствует протоколу `Decodable`.
    /// Completion handler выполняется на главной очереди.
    ///
    /// - Parameters:
    ///   - request: Модель запроса, содержащая URL, метод, заголовки и тело (опционально).
    ///   - type: Тип, в который должен быть декодирован ответ. Должен соответствовать протоколу `Decodable`.
    ///   - onResponse: Completion handler, который вызывается с результатом выполнения запроса.
    ///
    /// - Returns: Объект `NetworkTask`, который может быть использован для отмены запроса.
    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask? {
        send(request: request, type: type, completionQueue: .main, onResponse: onResponse)
    }
}
