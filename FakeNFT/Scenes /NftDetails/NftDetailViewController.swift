import UIKit
import Kingfisher

final class NftDetailViewController: UIViewController, ErrorView {
    
    // MARK: - Private Properties

    private let viewModel: NftDetailViewModel
    private var cellModels: [NftDetailCellModel] = []
    
    // MARK: - Subviews

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(NftImageCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .blackDyn
        button.setImage(.closeIcon, for: .normal)
        button.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var pageControl: LinePageControl = {
        let pageControl = LinePageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    // MARK: - Init

    init(viewModel: NftDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupBindings()
    }

    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .white
        collectionView.addSubview(activityIndicator)
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(closeButton)
    }

    private func setupLayout() {
        activityIndicator.constraintCenters(to: collectionView)
        collectionView.constraintEdges(to: view)

        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: collectionView.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupBindings() {
        viewModel.cellModels.bind { [weak self] cellModels in
            self?.cellModels = cellModels
            self?.collectionView.reloadData()
            self?.pageControl.numberOfItems = cellModels.count
        }
        
        viewModel.isLoading.bind { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.errorModel.bind { [weak self] errorModel in
            guard let errorModel else { return }
            self?.showError(errorModel)
        }
    }

    @objc
    private func closeButtonDidTap() {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension NftDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        cellModels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NftImageCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let cellModel = cellModels[indexPath.row]
        cell.configure(with: cellModel)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NftDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let selectedItem = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.selectedItem = selectedItem
    }
}
