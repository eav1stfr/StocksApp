import UIKit

protocol TextFieldSearchDelegate: AnyObject {
    func searchButtonTapped()
    func backButtonTapped()
    func clearButtonTapped()
}

final class TextFieldSearch: UITextField {
    
    weak var textFieldDelegate: TextFieldSearchDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.isUserInteractionEnabled = true
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.tintColor = .black
        button.isHidden = true
        return button
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        button.tintColor = .black
        button.isHidden = true
        return button
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.tintColor = .black
        button.isHidden = false
        return button
    }()
    
    private lazy var leftViewSpace: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 48).isActive = true
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        view.addSubview(backButton)
        view.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            searchButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            backButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        return view
    }()

    private lazy var rightViewSpace: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 48).isActive = true
        view.heightAnchor.constraint(equalToConstant: 48).isActive = true
        view.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            clearButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        return view
    }()
    
    @objc
    private func backButtonPressed(_ sender: UIButton) {
        textFieldDelegate?.backButtonTapped()
    }
    
    @objc
    private func clearButtonPressed(_ sender: UIButton) {
        textFieldDelegate?.clearButtonTapped()
    }
    
    @objc
    private func searchButtonPressed(_ sender: UIButton) {
        textFieldDelegate?.clearButtonTapped()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 24
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        placeholder = "Find company by name or ticker"
        translatesAutoresizingMaskIntoConstraints = false
        leftView = leftViewSpace
        rightView = rightViewSpace
        leftViewMode = .always
        rightViewMode = .always
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
