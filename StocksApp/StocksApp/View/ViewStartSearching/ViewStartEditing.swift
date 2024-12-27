import UIKit

protocol ViewStartSearchingDelegate: AnyObject {
    func displaySearchOption(with companyName: String)
    func fetchSearchRequestsFromDB() -> [String]
}

final class ViewStartSearching: UIView {
    
    weak var delegate: ViewStartSearchingDelegate?
    
    private let popularRequests: [String] = ["Apple", "Microsoft", "Google", "Bloomberg", "Meta", "Jane street", "Alibaba", "Tesla", "Amazon"]
    
    private var recentSearch: [String] = []
    
    private let popularRequestsLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular Requests"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private let recentSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "You've searched for this"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private let buttonApple: StockSearchOptionButton = {
        let button = StockSearchOptionButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let horizontalScrollPopularRequests: HorizontalScroll = {
        let scroll = HorizontalScroll()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let horizontalScrollRecentSearch: HorizontalScroll = {
        let scroll = HorizontalScroll()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData() {
        guard let arr = delegate?.fetchSearchRequestsFromDB() else {
            return
        }
        recentSearch = arr
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        addSubview(popularRequestsLabel)
        addSubview(horizontalScrollPopularRequests)
        addSubview(recentSearchLabel)
        addSubview(horizontalScrollRecentSearch)
        
        horizontalScrollPopularRequests.setArray(with: popularRequests)
        horizontalScrollPopularRequests.delegateForButton = self
        
        horizontalScrollRecentSearch.setArray(with: recentSearch)
        horizontalScrollRecentSearch.delegateForButton = self
        
        NSLayoutConstraint.activate([
            popularRequestsLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            popularRequestsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            horizontalScrollPopularRequests.topAnchor.constraint(equalTo: popularRequestsLabel.bottomAnchor, constant: 20),
            horizontalScrollPopularRequests.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            horizontalScrollPopularRequests.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            horizontalScrollPopularRequests.heightAnchor.constraint(equalToConstant: 100),
            
            recentSearchLabel.topAnchor.constraint(equalTo: horizontalScrollPopularRequests.bottomAnchor, constant: 20),
            recentSearchLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            horizontalScrollRecentSearch.topAnchor.constraint(equalTo: recentSearchLabel.bottomAnchor, constant: 20),
            horizontalScrollRecentSearch.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            horizontalScrollRecentSearch.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            horizontalScrollRecentSearch.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}

extension ViewStartSearching: HorizontalScrollDelegate {
    func optionTapped(currString: String) {
        delegate?.displaySearchOption(with: currString)
    }
}
