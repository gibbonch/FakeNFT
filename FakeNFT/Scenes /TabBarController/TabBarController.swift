import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Private Properties
    
    private let catalogTabBarItem = UITabBarItem(
        title: L10n.Tab.catalog,
        image: .catalogTab,
        tag: 0
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: L10n.Tab.profile,
        image: .profileTab,
        tag: 0
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: L10n.Tab.cart,
        image: .cartTab,
        tag: 0
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: L10n.Tab.statistics,
        image: .statisticsTab,
        tag: 0
    )
    
    // MARK: - Public Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController()
        catalogController.tabBarItem = catalogTabBarItem
        viewControllers = [catalogController]
        view.backgroundColor = .systemBackground
    }
}
