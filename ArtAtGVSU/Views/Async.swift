import Foundation

enum Async<T> {
    case uninitialized
    case loading
    case success(T)
    case failure

    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
}
