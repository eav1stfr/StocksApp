import UIKit

final class StocksList: UIView {
    weak var presenter: StocksPresenterProtocol!
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.isUserInteractionEnabled = true
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(StocksListCell.self, forCellReuseIdentifier: StocksListCell.id)
        table.rowHeight = 68
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
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension StocksList: UITableViewDelegate, UITableViewDataSource {
    
    func updateData() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customCell = tableView.dequeueReusableCell(
            withIdentifier: StocksListCell.id,
            for: indexPath
        ) as? StocksListCell else {
            return UITableViewCell()
        }
        customCell.set(cell: presenter.getItem(at: indexPath))
        customCell.setBackgroundColor(indexPath.row%2==0 ? .systemGray6 : .white)
        customCell.delegate = self
        DataManager().fetchStockImage(imageLink: presenter.getItem(at: indexPath).imageLink) { result in
            switch (result) {
            case .failure(let error):
                print("caught error fetching image: \(error.localizedDescription)")
            case .success(let img):
                DispatchQueue.main.async {
                    customCell.image.image = img
                }
            }
        }
        return customCell
    }
}

extension StocksList: StocksListCellDelegate {
    func addToFavorite(stock: StockModel) {
        presenter.addToFavoriteTapped(stock: stock)
    }
    
    func deletFromFavorite(stock: StockModel) {
        presenter.deleteFromFavorite(stock: stock)
    }
}
