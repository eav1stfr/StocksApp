import Foundation

protocol StocksPresenterProtocol: AnyObject {
    func viewLoaded()
    func addToFavoriteTapped(stock: StockModel)
    func deleteFromFavorite(stock: StockModel)
    func stocksChosen()
    func favoriteChosen()
    func numberOfItems() -> Int
    func returnAnItem(at indexPath: IndexPath) -> StockModel
}

final class StocksPresenter: StocksPresenterProtocol {
        
    private var savedFavStocks: [Favorite]?
    
    private let companyTickers: [String] = ["AAPL", "YNDX", "GOOGL", "AMZN", "BAC", "MSFT", "TSLA", "MA", "PFE", "JNJ", "TM", "XOM", "JPM", "CSCO", "KO", "EBAY"]
    
    private let dict: Dictionary<String, Int> = ["AAPL" : 0, "YNDX" : 1, "GOOGL" : 2, "AMZN" : 3, "BAC" : 4, "MSFT" : 5, "TSLA" : 6, "MA" : 7, "PFE" : 8, "JNJ" : 9, "TM" : 10, "XOM" : 11, "JPM" : 12, "CSCO" : 13, "KO" : 14, "EBAY" : 15]

    private var currentViewIsStocks: Bool = true
    
    private var favoriteStocksList: [StockModel] = []

    private var stocksList: [StockModel] = Array(repeating: StockModel(price: "", changeInPrice: "", stockTicker: "", companyName: "", positiveChange: false), count: 16)
    
    private var currentStocksListToShow: [StockModel] = Array(repeating: StockModel(price: "", changeInPrice: "", stockTicker: "", companyName: "", positiveChange: false), count: 16)

    unowned var view: StocksViewProtocol?
    
    private var dataManager: DataManagerProtocol
    
    private let group = DispatchGroup()
    
    init(view: StocksViewProtocol, dataManager: DataManagerProtocol) {
        self.view = view
        self.dataManager = dataManager
    }
    
    func viewLoaded() {
        for ticker in companyTickers {
            group.enter()
            // MARK: - HERE
            dataManager.fetchStocks(ticker: ticker) { stock, error in
                defer { self.group.leave() }
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let stock = stock {
                    self.stocksList[self.dict[stock.stockTicker]!] = stock
                    self.currentStocksListToShow[self.dict[stock.stockTicker]!] = stock
                }
            }
        }
        
        group.notify(queue: .main) { [self] in
            savedFavStocks = dataManager.fetchFavoriteFromDB()
            
            for ticker in savedFavStocks! {
                stocksList[dict[ticker.ticker!]!].isFavorite = true
                currentStocksListToShow[dict[ticker.ticker!]!].isFavorite = true
                favoriteStocksList.append(stocksList[dict[ticker.ticker!]!])
            }
            
            view?.updateTableData()
        }
    }
    
    func addToFavoriteTapped(stock: StockModel) {
        if let index = self.stocksList.firstIndex(where: {$0.stockTicker == stock.stockTicker}) {
            if !self.stocksList[index].isFavorite {
                self.stocksList[index].isFavorite = true
                let copy: StockModel = self.stocksList[index]
                self.favoriteStocksList.append(copy)
                dataManager.addFavoriteToDB(copy.stockTicker)
            }
        }
    }
    
    func deleteFromFavorite(stock: StockModel) {
        if let index = self.stocksList.firstIndex(where: {$0.stockTicker == stock.stockTicker}) {
            if self.stocksList[index].isFavorite {
                self.stocksList[index].isFavorite = false
                if let idx = self.favoriteStocksList.firstIndex(where: {$0.stockTicker == stock.stockTicker}) {
                    dataManager.deleteFavoriteFromDB(self.favoriteStocksList[idx].stockTicker)
                    self.favoriteStocksList.remove(at: idx)
                }
            }
        }
    }
    
    func stocksChosen() {
        if !currentViewIsStocks {
            self.currentStocksListToShow = self.stocksList
            view?.updateTableData()
            currentViewIsStocks.toggle()
        }
    }
    
    func favoriteChosen() {
        if currentViewIsStocks {
            self.currentStocksListToShow = self.favoriteStocksList
            view?.updateTableData()
            currentViewIsStocks.toggle()
        }
    }
    
    func numberOfItems() -> Int {
        return currentStocksListToShow.count
    }
    
    func returnAnItem(at indexPath: IndexPath) -> StockModel {
        return currentStocksListToShow[indexPath.row]
    }
}
