import UIKit

protocol StocksListCellDelegate: AnyObject {
    func addToFavorite(stock: StockModel)
    func deletFromFavorite(stock: StockModel)
}

final class StocksListCell: UITableViewCell {
    
    static var id: String = "StocksListCustomCell"
    weak var delegate: StocksListCellDelegate?
    
    var cellImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.heightAnchor.constraint(equalToConstant: 52).isActive = true
        image.widthAnchor.constraint(equalToConstant: 52).isActive = true
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        return image
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private var changeInPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = true
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 16).isActive = true
        button.widthAnchor.constraint(equalToConstant: 16).isActive = true
        button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private var stockTickerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.textColor = .black
        return label
    }()
    
    private var companyNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    private var isFavorite: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(cellImageView)
        addSubview(priceLabel)
        addSubview(changeInPriceLabel)
        addSubview(favoriteButton)
        addSubview(stockTickerLabel)
        addSubview(companyNameLabel)
    }
    
    private func setupConstraints() {
        self.layer.cornerRadius = 20
        NSLayoutConstraint.activate([
            cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cellImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            stockTickerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            stockTickerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 72),
            
            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            favoriteButton.leadingAnchor.constraint(equalTo: stockTickerLabel.trailingAnchor, constant: 6),
            
            companyNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 38),
            companyNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 72),
            
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            
            changeInPriceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 38),
            changeInPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17)
        ])
    }
}

extension StocksListCell {
    
    @objc
    private func favoriteButtonPressed(_ sender: UIButton) {
        sender.tintColor = isFavorite ? .systemGray : .systemYellow
        let positive: Bool = changeInPriceLabel.text!.first == "-" ? false : true
        let numberPrice = priceLabel.text!.replacingOccurrences(of: "$", with: "")
        let numberChange = changeInPriceLabel.text!.replacingOccurrences(of: "$", with: "")
        let currentStock = StockModel(
            price: numberPrice,
            changeInPrice: numberChange,
            stockTicker: stockTickerLabel.text ?? "",
            companyName: companyNameLabel.text ?? "",
            positiveChange: positive,
            imageLink: ""
        )
        isFavorite ? delegate?.deletFromFavorite(stock: currentStock) : delegate?.addToFavorite(stock: currentStock)
        
        isFavorite.toggle()
    }
    
    func set(cell: StockModel) {
        priceLabel.text = "$"+cell.price
        changeInPriceLabel.text = cell.changeInPrice
        stockTickerLabel.text = cell.stockTicker
        companyNameLabel.text = cell.companyName
        changeInPriceLabel.textColor = cell.positiveChange ? .systemGreen : .red
        favoriteButton.tintColor = cell.isFavorite ? .systemYellow : .systemGray

    }
    
    func setBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
        self.favoriteButton.backgroundColor = color
    }
}
