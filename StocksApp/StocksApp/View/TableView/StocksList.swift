import UIKit

final class StocksList: UIView {
    weak var presenter: StocksPresenterProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView = UITableView()
    
}

extension StocksList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StocksList: UITableViewDataSource {
    
    func updateData() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.currentStocksListToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = tableView.dequeueReusableCell(
            withIdentifier: "StocksListCustomCell",
            for: indexPath
        ) as? StocksListCustomCell else {
            return UITableViewCell()
        }
        customCell.set(cell: presenter.currentStocksListToShow[indexPath.row])
        if indexPath.row%2==0 {
            customCell.backgroundColor = .systemGray6
            customCell.favoriteButton.backgroundColor = .systemGray6
        } else {
            customCell.backgroundColor = .white
            customCell.favoriteButton.backgroundColor = .white
        }
        customCell.layer.cornerRadius = 20
        customCell.presenter = self.presenter
        return customCell
    }
}

private extension StocksList {
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        tableView.isUserInteractionEnabled = true
        addSubviews()
        setupConstraints()
        additionalSetup()
    }
    
    func addSubviews() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 68
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func additionalSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StocksListCustomCell.self, forCellReuseIdentifier: "StocksListCustomCell")
    }
}
