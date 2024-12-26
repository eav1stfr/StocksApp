import UIKit

final class StockSearchOptionButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.layer.cornerRadius = 30
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.isUserInteractionEnabled = true
        
        var config = UIButton.Configuration.filled()
        config.title = "Apple"
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .black
        config.background.cornerRadius = 20
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)

        self.configuration = config
    }

}
