import UIKit

final class TextFieldSearch: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 24
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        placeholder = "Find company by name or ticker"
        translatesAutoresizingMaskIntoConstraints = false
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 48))
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 48))
        leftViewMode = .always
        rightViewMode = .always
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
