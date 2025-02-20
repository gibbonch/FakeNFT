import UIKit

final class TestCatalogViewController: UIViewController {
    private lazy var testNftButton:  UIButton = {
        let button = UIButton()
        button.setTitle(Constants.openNftTitle, for: .normal)
        button.addTarget(self, action: #selector(showNft), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(testNftButton)
        testNftButton.constraintCenters(to: view)
    }

    @objc
    func showNft() {
        guard let service = try? DIContainer.shared.resolve(NftService.self) else {
            return
        }
        
        let assembly = NftDetailAssembly(nftService: service)
        let nftInput = NftDetailInput(id: Constants.testNftId)
        let nftViewController = assembly.build(with: nftInput)
        present(nftViewController, animated: true)
    }
}

private enum Constants {
    static let openNftTitle = L10n.Catalog.openNft
    static let testNftId = "7773e33c-ec15-4230-a102-92426a3a6d5a"
}
