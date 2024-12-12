//import UIKit
//
//protocol ProfileViewDelegate: AnyObject {
//    func profileOptionViewDidSelect()
//}
//
//final class ProfileView: UIView {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    weak var delegate: ProfileViewDelegate?
//
//    private let tableView = UITableView()
//
//    private var tableCells: [TableCellModel] = []
//
//}
//
//extension ProfileView: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableCells.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let customCell = tableView.dequeueReusableCell(
//            withIdentifier: "TableViewCustomCell",
//            for: indexPath
//        ) as? TableViewCustomCell else {
//            return UITableViewCell()
//        }
//        customCell.set(cell: tableCells[indexPath.row])
//        return customCell
//    }
//
//}
//
//extension ProfileView: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        delegate?.profileOptionViewDidSelect()
//    }
//}
//
//extension ProfileView {
//    func configure(cellList: [TableCellModel]) {
//        self.tableCells = cellList
//
//        tableView.reloadData()
//    }
//
//    private func setupView() {
//        translatesAutoresizingMaskIntoConstraints = false
//        addSubviews()
//        setupConstraints()
//        addSubviewsStyle()
//    }
//
//    private func addSubviews() {
//        addSubview(tableView)
//    }
//
//    private func setupConstraints() {
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.rowHeight = 50
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//    }
//
//    private func addSubviewsStyle() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(TableViewCustomCell.self, forCellReuseIdentifier: "TableViewCustomCell")
//    }
//
//}
//
//private func parseJSON() {
//    print("started parsing json, retreiving product list of certain farmer")
//
//    let url = URL(string: "https://farmer-market-zlmy.onrender.com/api/my-products/")!
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//
//    request.setValue(
//        "application/json",
//        forHTTPHeaderField: "Content-Type"
//    )
//
//    let defaults = UserDefaults.standard
//    if let token = defaults.string(forKey: "UserToken") {
//        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
//    } else {
//        print("error: something went wrong")
//        return
//    }
//
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        if error != nil {
//            print("ERROR IS NOT NIL")
//            return
//        }
//
//        guard let safeData = data else {
//            print("no data received")
//            return
//        }
//
//        do {
//            let product = try JSONDecoder().decode([TableProductListingCellModel].self, from: safeData)
//            DispatchQueue.main.async {
//                self.myProductsList = product
//                print("products successfully retreived from safe dataa eeeeee")
//                self.productListingView.configure(cellList: self.myProductsList)
//                print(self.myProductsList)
//            }
//        } catch {
//            print("got some error \(error)")
//            return
//        }
//    }
//    task.resume()
//}
//
