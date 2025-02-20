import Foundation

final class NftDetailViewModelImpl: NftDetailViewModel {
    
    // MARK: - State

    private enum NftDetailState {
        case initial, loading, failed(Error), data(Nft)
    }
    
    // MARK: - Public Properties
    
    let cellModels: Observable<[NftDetailCellModel]>
    let isLoading: Observable<Bool>
    let errorModel: Observable<ErrorModel?>
    
    var numberOfCells: Int { cellModels.value.count }

    // MARK: - Private Properties

    private let input: NftDetailInput
    private let nftService: NftService
    
    private var state = NftDetailState.initial {
        didSet {
            stateDidChange()
        }
    }

    // MARK: - Init

    init(input: NftDetailInput, nftService: NftService) {
        self.input = input
        self.nftService = nftService
        cellModels = Observable<[NftDetailCellModel]>([])
        isLoading = Observable<Bool>(false)
        errorModel = Observable<ErrorModel?>(nil)
        
        fetchNft()
    }

    // MARK: - Private Methods

    private func stateDidChange() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
            
        case .loading:
            isLoading.value = true
            
        case .data(let nft):
            isLoading.value = false
            cellModels.value = nft.images.map { NftDetailCellModel(url: $0) }
            
        case .failed(let error):
            isLoading.value = false
            errorModel.value = createErrorModel(error)
        }
    }

    private func fetchNft() {
        state = .loading
        nftService.loadNft(id: input.id) { [weak self] result in
            switch result {
            case .success(let nft):
                self?.state = .data(nft)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    private func createErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = L10n.Error.network
        default:
            message = L10n.Error.unknown
        }

        let actionText = L10n.Error.repeat
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
