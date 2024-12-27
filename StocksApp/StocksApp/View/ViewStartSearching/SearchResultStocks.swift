import UIKit

final class SearchResultsView: UIView {
    
    private let stocksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Stocks"
        label.font = UIFont(name: "Montserrat-Bold", size: 28)
        label.textColor = .black
        return label
    }()
    
    private let showMoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Show more"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Montserrat-Light", size: 20)
        return label
    }()
    
    let tableView: StocksList = {
        let table = StocksList()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        self.addSubview(stocksLabel)
        self.addSubview(showMoreLabel)
        self.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stocksLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stocksLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            
            showMoreLabel.centerYAnchor.constraint(equalTo: stocksLabel.centerYAnchor),
            showMoreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: stocksLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
