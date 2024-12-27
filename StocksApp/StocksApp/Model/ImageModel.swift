import UIKit

final class StockImageModel: UIImageView {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        self.heightAnchor.constraint(equalToConstant: 52).isActive = true
        self.widthAnchor.constraint(equalToConstant: 52).isActive = true
        self.layer.cornerRadius = 12
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
    
    func setImage(with image: UIImage) {
        self.image = image
    }
}
