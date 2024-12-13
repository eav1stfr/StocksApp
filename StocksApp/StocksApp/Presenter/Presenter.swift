import Foundation

protocol StocksPresenterProtocol: AnyObject {
    func viewLoaded()
    func addToFavoriteTapped(stock: StockModel)
    func deleteFromFavorite(stock: StockModel)
    func stocksChosen()
    func favoriteChosen()
    var currentViewIsStocks: Bool {get set}
    var stocksList: [StockModel] {get set}
    var favoriteStocksList: [StockModel] {get set}
    var currentStocksListToShow: [StockModel] {get set}
}

final class StocksPresenter: StocksPresenterProtocol {
    
    private let companyTickers: [String] = ["AAPL", "YNDX", "GOOGL", "AMZN", "BAC", "MSFT", "TSLA", "MA"]

    var currentViewIsStocks: Bool = true
    
    var favoriteStocksList: [StockModel] = []

    var stocksList: [StockModel] = []
    
    var currentStocksListToShow: [StockModel] = []

    unowned var view: StocksViewProtocol?
    
    private var dataManager: DataManagerProtocol
    
    init(view: StocksViewProtocol, dataManager: DataManagerProtocol) {
        self.view = view
        self.dataManager = dataManager
    }
    
    func viewLoaded() {
        for ticker in companyTickers {
            dataManager.fetchStocks(ticker: ticker) { stock, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let stock = stock {
                    self.stocksList.append(stock)
                    self.currentStocksListToShow.append(stock)
                    DispatchQueue.main.async {
                        self.view?.updateTableData()
                    }
                }
            }
        }
        
        view?.updateTableData()
    }
    
    func addToFavoriteTapped(stock: StockModel) {
        print("ADD TO FAVORITE FROM PRESENTER")
        if let index = self.stocksList.firstIndex(where: {$0.stockTicker == stock.stockTicker}) {
            self.stocksList[index].isFavorite = true
            self.favoriteStocksList.append(stocksList[index])
        }
    }
    
    func deleteFromFavorite(stock: StockModel) {
        print("DELETE FROM FAVORITE FROM PRESENTER")
        
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
}
