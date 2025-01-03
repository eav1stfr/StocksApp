import Foundation

protocol StocksPresenterProtocol: AnyObject {
    func viewLoaded()
    func addToFavoriteTapped(stock: StockModel)
    func deleteFromFavorite(stock: StockModel)
    func stocksChosen()
    func favoriteChosen()
    func numberOfItems() -> Int
    func getItem(at indexPath: IndexPath) -> StockModel
}

final class StocksPresenter: StocksPresenterProtocol {
        
    private var savedFavStocks: [Favorite]?
    
    private let companyTickers: [String] = ["AAPL", "YNDX", "GOOGL", "AMZN", "BAC", "MSFT", "TSLA", "MA", "PFE", "JNJ", "TM", "XOM", "JPM", "CSCO", "KO", "EBAY"]

    private var currentViewIsStocks: Bool = true
    
    private var favoriteStocksList: [StockModel] = []

    private var stocksList: [StockModel] = []
    
    private var currentStocksListToShow: [StockModel] = []

    unowned var view: StocksViewProtocol?
    
    private var dataManager: DataManagerProtocol
    
    init(view: StocksViewProtocol, dataManager: DataManagerProtocol) {
        self.view = view
        self.dataManager = dataManager
    }
    
    func viewLoaded() {
        let group = DispatchGroup()
        var localDict: Dictionary<Int, StockModel> = [:]
        for (index, ticker) in companyTickers.enumerated() {
            group.enter()
            dataManager.fetchStocks(ticker: ticker) { result in
                defer { group.leave() }
                switch (result) {
                case .failure(let error):
                    print("Caught error fetching stocks: \(error.localizedDescription)")
                case .success(let stock):
                    localDict[index] = stock
                }
            }
        }
        
        group.notify(queue: .main) { [self] in
            savedFavStocks = dataManager.fetchFavoriteFromDB()
            let size = localDict.count
            var tempArr: [String] = []
            guard let savedFav = savedFavStocks else {
                return
            }
            for ticker in savedFav {
                if let ticker = ticker.ticker {
                    tempArr.append(ticker)
                }
            }
            
            for i in 0...size-1 {
                guard var stock = localDict[i] else {
                    print("No such stock exist")
                    return
                }
                if tempArr.contains(stock.stockTicker) {
                    stock.isFavorite = true
                    favoriteStocksList.append(stock)
                }
                stocksList.append(stock)
                currentStocksListToShow.append(stock)
            }
            
            view?.updateTableData()
        }
    }
    
    func addToFavoriteTapped(stock: StockModel) {
        if let index = self.stocksList.firstIndex(where: {$0.stockTicker == stock.stockTicker}) {
            guard self.stocksList[index].isFavorite else {
                self.stocksList[index].isFavorite = true
                let copy: StockModel = self.stocksList[index]
                self.favoriteStocksList.append(copy)
                dataManager.addFavoriteToDB(copy.stockTicker)
                return
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
        guard currentViewIsStocks else {
            self.currentStocksListToShow = self.stocksList
            view?.updateTableData()
            currentViewIsStocks.toggle()
            return
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
    
    func getItem(at indexPath: IndexPath) -> StockModel {
        return currentStocksListToShow[indexPath.row]
    }
}
