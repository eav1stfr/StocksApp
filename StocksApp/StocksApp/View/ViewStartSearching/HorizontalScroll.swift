import UIKit

protocol HorizontalScrollDelegate: AnyObject {
    func optionTapped(currString: String)
}

final class HorizontalScroll: UIScrollView {
    
    private var requests: [String] = []
    
    weak var delegateForButton: HorizontalScrollDelegate?

    private let horizontalStackOne: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .white
        stack.spacing = 15
        return stack
    }()
    
    private let horizontalStackTwo: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .white
        stack.spacing = 15
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setArray(with arr: [String]) {
        self.requests = arr
        setupScrollView()
    }
    
    private func setupScrollView() {
        self.addSubview(horizontalStackOne)
        self.addSubview(horizontalStackTwo)
        self.backgroundColor = .white
        self.isScrollEnabled = true
        self.showsHorizontalScrollIndicator = false
        
        
        NSLayoutConstraint.activate([
            horizontalStackOne.topAnchor.constraint(equalTo: self.topAnchor),
            horizontalStackOne.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            horizontalStackOne.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            horizontalStackTwo.topAnchor.constraint(equalTo: horizontalStackOne.bottomAnchor, constant: 10),
            horizontalStackTwo.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            horizontalStackTwo.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            horizontalStackTwo.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        let midIndex = requests.count / 2
        
        if midIndex == 0 {
            return
        }
        
        for i in 0...midIndex {
            let button: StockSearchOptionButton = {
                let button = StockSearchOptionButton()
                button.setTitle(requests[i], for: .normal)
                button.isUserInteractionEnabled = true
                button.addTarget(self, action: #selector(optionChosen), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            horizontalStackOne.addArrangedSubview(button)
        }
        
        for i in midIndex+1...requests.count-1 {
            let button: StockSearchOptionButton = {
                let button = StockSearchOptionButton()
                button.setTitle(requests[i], for: .normal)
                button.isUserInteractionEnabled = true
                button.addTarget(self, action: #selector(optionChosen), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                return button
            }()
            horizontalStackTwo.addArrangedSubview(button)
        }
    }
    
    @objc
    private func optionChosen(_ sender: UIButton) {
        guard let label = sender.titleLabel, let str = label.text else {
            print("faced some error")
            return
        }
        delegateForButton?.optionTapped(currString: str)
    }
}
