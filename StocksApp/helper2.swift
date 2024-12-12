//import UIKit
//
//final class TableViewCustomCell: UITableViewCell {
//
//    private let image: UIImageView = {
//        let image = UIImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.contentMode = .scaleAspectFit
//        image.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        image.tintColor = UIColor(named: "Color")!
//        image.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        return image
//    }()
//
//    private let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 1
//        label.textColor = .black
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        return label
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func set(cell: TableCellModel) {
//        descriptionLabel.text = cell.description
//        descriptionLabel.textColor = .black
//        image.image = UIImage(systemName: cell.imageName)
//    }
//
//}
//
//private extension TableViewCustomCell {
//    private func setupView() {
//        addSubviews()
//        setupConstraints()
//    }
//
//    private func addSubviews() {
//        addSubview(image)
//        addSubview(descriptionLabel)
//    }
//
//    private func setupConstraints() {
//        //translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            image.centerYAnchor.constraint(equalTo: centerYAnchor),
//
//            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//            descriptionLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 15),
//            descriptionLabel.heightAnchor.constraint(equalToConstant: 50),
//            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
//        ])
//    }
//}
//
