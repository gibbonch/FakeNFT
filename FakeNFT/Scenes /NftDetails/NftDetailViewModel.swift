import Foundation

protocol NftDetailViewModel {
    var numberOfCells: Int { get }
    var cellModels: Observable<[NftDetailCellModel]> { get }
    var isLoading: Observable<Bool> { get }
    var errorModel: Observable<ErrorModel?> { get }
}
