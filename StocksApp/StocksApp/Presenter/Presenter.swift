import Foundation

protocol StocksPresenterProtocol: AnyObject {
    func viewLoaded()
    func addToFavoriteTapped(stock: StockModel)
    func deleteFromFavorite(stock: StockModel)
    func stocksChosen()
    func favoriteChosen()
    func numberOfItems() -> Int
    func getItem(at indexPath: IndexPath) -> StockModel
    func addToRecentSearchDB(companyName: String)
    func fetchRecentSearchFromDB() -> [String]
    func performSearch(with companyTicker: String) throws
    func resetSearchResults()
    func fetchImage(imageLink: String, completion: @escaping (Result<Data, Error>)->Void)
    func showStockDetailView(index: IndexPath)
}

final class StocksPresenter: StocksPresenterProtocol {
    
    private var savedFavStocks: [Favorite]?
    
    private let companyTickers: [String] = ["AMZN", "META", "NFLX","AAPL", "BAC", "MSFT", "PFE", "JNJ", "XOM", "JPM", "CSCO", "KO", "APPN", "APPF"]

    private var currentViewIsStocks: Bool = true
    
    var isSearchResultTable: Bool = false
    
    private var favoriteStocksList: [StockModel] = []

    private var stocksList: [StockModel] = []
    
    private var currentStocksListToShow: [StockModel] = []
    
    private var searchResultList: [StockModel] = []

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
            var favoriteStocks: [String] = []
            guard let savedFav = savedFavStocks else {
                return
            }
            for ticker in savedFav {
                if let ticker = ticker.ticker {
                    favoriteStocks.append(ticker)
                }
            }
            
            for i in 0...size-1 {
                guard var stock = localDict[i] else {
                    print("No such stock exist")
                    return
                }
                if favoriteStocks.contains(stock.stockTicker) {
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
    
    func fetchImage(imageLink: String, completion: @escaping (Result<Data, Error>)->Void) {
        dataManager.fetchStockImage(imageLink: imageLink) { result in
            switch result {
            case .failure(let error):
                print("caught unexpected error trying to fetch image: \(error.localizedDescription)")
                completion(.failure(error))
            case .success(let data):
                DispatchQueue.main.async {
                    completion(.success(data))
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
    
    func addToRecentSearchDB(companyName: String) {
        dataManager.addToRecentSearchDB(name: companyName)
    }
    
    func fetchRecentSearchFromDB() -> [String] {
        let searchArr: [RecentSearch] = dataManager.fetchFromRecentSearchDB()
        var searchArrToReturn: [String] = []
        for searchRequest in searchArr {
            guard let name = searchRequest.companyName else {
                return searchArrToReturn
            }
            searchArrToReturn.append(name)
        }
        return searchArrToReturn
    }
    
    func performSearchTest(with companyTicker: String) throws {
        guard let stock = stocksList.first(where: {$0.stockTicker == companyTicker}) else {
            throw NSError()
        }
        searchResultList.append(stock)
        currentStocksListToShow = searchResultList
        view?.updateTableData()
    }
    
    func performSearch(with companyTicker: String) throws {
        let matchingStocks = stocksList.filter({
                $0.stockTicker.uppercased().hasPrefix(companyTicker.uppercased())
            })
        
        for stock in matchingStocks {
            searchResultList.append(stock)
        }
        currentStocksListToShow = searchResultList
        view?.updateTableData()
    }
    
    func resetSearchResults() {
        searchResultList = []
        currentStocksListToShow = stocksList
    }
    
    func showStockDetailView(index: IndexPath) {
        self.view?.showStockDetailView(stock: self.getItem(at: index))
    }

}
