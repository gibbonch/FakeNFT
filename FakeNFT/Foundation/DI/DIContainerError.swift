enum DIContainerError: Error {
    case resolvingError(String)
    
    var localizedDescription: String {
        switch self {
        case .resolvingError(let type):
            return "Error resolving dependency of type: \(type)"
        }
    }
}
