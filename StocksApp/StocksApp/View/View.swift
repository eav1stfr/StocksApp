import UIKit

protocol StocksViewProtocol: AnyObject {
    func showStocks(stocks: [StockModel])
    func showError(error: String)
    func updateTableData()
}

final class StocksViewController: UIViewController {
    
    var presenter: StocksPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTableData()
    }
    
    private var isCurrentViewStocks: Bool = true
    
    private let searchField = TextFieldSearch()
    
    private lazy var tableView: StocksList = {
        let table = StocksList()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.presenter = self.presenter
        return table
    }()
    
    private lazy var stocksLabel: UILabel = {
        let label = UILabel()
        label.text = "Stocks"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.isUserInteractionEnabled = true
        let labelTapGesure = UITapGestureRecognizer(target: self, action: #selector(stocksTapped))
        label.addGestureRecognizer(labelTapGesure)
        return label
    }()
    
    private lazy var favoriteLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorite"
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.textColor = .systemGray
        label.isUserInteractionEnabled = true
        let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        label.addGestureRecognizer(labelTapGesture)
        return label
    }()
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(searchField)
        view.addSubview(stocksLabel)
        view.addSubview(favoriteLabel)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            stocksLabel.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20),
            stocksLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            favoriteLabel.centerYAnchor.constraint(equalTo: stocksLabel.centerYAnchor),
            favoriteLabel.leadingAnchor.constraint(equalTo: stocksLabel.trailingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: stocksLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension StocksViewController: StocksViewProtocol {
    func updateTableData() {
        tableView.updateData()
    }
    
    func showStocks(stocks: [StockModel]) {
        
    }
    
    func showError(error: String) {
        
    }
}

extension StocksViewController {
    @objc
    private func stocksTapped() {
        guard isCurrentViewStocks else {
            NSLayoutConstraint.activate([
                stocksLabel.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20),
                favoriteLabel.centerYAnchor.constraint(equalTo: stocksLabel.centerYAnchor)
            ])
            stocksLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            favoriteLabel.font = UIFont.systemFont(ofSize: 18)
            favoriteLabel.textColor = .systemGray
            stocksLabel.textColor = .black
            isCurrentViewStocks.toggle()
            presenter?.stocksChosen()
            return
        }
    }
    
    @objc
    private func favoriteTapped() {
        if isCurrentViewStocks {
            NSLayoutConstraint.activate([
                favoriteLabel.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 20),
                stocksLabel.centerYAnchor.constraint(equalTo: favoriteLabel.centerYAnchor)
            ])
            favoriteLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            stocksLabel.font = UIFont.systemFont(ofSize: 18)
            favoriteLabel.textColor = .black
            stocksLabel.textColor = .systemGray
            isCurrentViewStocks.toggle()
        }
        presenter?.favoriteChosen()
    }
}
