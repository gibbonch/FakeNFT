import UIKit

final class NftDetailAssembly {
    private let nftService: NftService

    init(nftService: NftService) {
        self.nftService = nftService
    }

    public func build(with input: NftDetailInput) -> UIViewController {
        let viewModel = NftDetailViewModelImpl(input: input, nftService: nftService)
        let viewController = NftDetailViewController(viewModel: viewModel)
        return viewController
    }
}
