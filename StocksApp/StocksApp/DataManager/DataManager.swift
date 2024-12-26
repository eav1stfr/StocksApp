import Foundation
import UIKit

// finhub api key = ctaqp2hr01qgsps7omt0ctaqp2hr01qgsps7omtg

//https://finnhub.io/api/v1/quote?symbol=AAPL&token=ctaqp2hr01qgsps7omt0ctaqp2hr01qgsps7omtg
//https://finnhub.io/api/v1/quote?symbol=MSFT&token=ctaqp2hr01qgsps7omt0ctaqp2hr01qgsps7omtg

// logo api = https://finnhub.io/api/logo?symbol=AAPL
// another logo api = https://eodhd.com/img/logos/US/MA.png

protocol DataManagerProtocol {
    func fetchStocks(ticker: String, completion: @escaping (StockModel?, Error?) -> Void)
    func fetchStockImage(ticker: String, completion: @escaping (UIImage?, Error?) -> Void)
    func fetchFavoriteFromDB() -> [Favorite]
    func addFavoriteToDB(_ ticker: String)
    func deleteFavoriteFromDB(_ ticker: String)
}

final class DataManager: DataManagerProtocol {
    
    // MARK: - Core Data Functionality
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetchFavoriteFromDB() -> [Favorite] {
        var arr: [Favorite] = []
        do {
            try arr = context.fetch(Favorite.fetchRequest())
            return arr
        } catch {
            print("CAUGHT ERROR TYRING TO FETCH FROM DB: \(error.localizedDescription)")
        }
        return arr
    }
    
    func addFavoriteToDB(_ ticker: String) {
        print("trying to add")
        let newStock = Favorite(context: self.context)
        newStock.ticker = ticker
        
        do {
            try self.context.save()
            print("success on saving new favorite")
        } catch {
            print("CAUGHT ERROR TRYING TO SAVE NEW STOCK: \(error.localizedDescription)")
        }
    }
    
    func deleteFavoriteFromDB(_ ticker: String) {
        print("trying to delete")
        let arr: [Favorite] = fetchFavoriteFromDB()
        if let idx = arr.firstIndex(where: {$0.ticker == ticker}) {
            let stockToRemoveFromDB = arr[idx]
            self.context.delete(stockToRemoveFromDB)
            do {
                try self.context.save()
                print("deleted successfully")
            } catch {
                print("CAUGHT ERROR TRYING TO DELETE STOCK FROM DB: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Networking
    func fetchStocks(ticker: String, completion: @escaping (StockModel?, Error?) -> Void) {
        var stockImage = UIImage()
        self.fetchStockImage(ticker: ticker) { image, error in
            if let error = error {
                print("caught error: \(error.localizedDescription)")
            } else if let image = image {
                stockImage = image
                print("LESSGOO SUCCESS")
            }
        }
        
        let apiLink: String = "https://finnhub.io/api/v1/quote?symbol="+ticker+"&token=ctaqp2hr01qgsps7omt0ctaqp2hr01qgsps7omtg"
        let url = URL(string: apiLink)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            if error != nil {
                print("CAUGHT ERROR: \(String(describing: error?.localizedDescription))")
                completion(nil, error)
                return
            }
            guard let safeData = data else {
                print("no data received")
                completion(nil, error)
                return
            }
            do {
                let stock = try JSONDecoder().decode(StockModelToReceive.self, from: safeData)
                var stockModel = StockModel(
                    image: stockImage,
                    price: String(stock.c),
                    changeInPrice: String(stock.d)+"$",
                    isFavorite: false,
                    stockTicker: ticker,
                    companyName: ticker,
                    positiveChange: !String(stock.d).hasPrefix("-")
                )
                
                if !String(stock.d).hasPrefix("-") {
                    stockModel.changeInPrice = "+"+stockModel.changeInPrice
                }
                
                DispatchQueue.main.async {
                    completion(stockModel, nil)
                }
            } catch {
                print("CAUGHT ERROR: \(error)")
                return
            }
        }
        task.resume()
    }
    
    func fetchStockImage(ticker: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let link = "https://finnhub.io/api/logo?symbol="+ticker
        let url = URL(string: link)!
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            if let error = error {
                print("CAUGHT ERROR FETHCING IMAGE: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("fail \(ticker)\n")
                completion(nil, error)
                return
            }
            
            DispatchQueue.main.async {
                print("SUCCESS FETCHING IMAGE")
                completion(image, nil)
            }
            
        }
        task.resume()
    }
    
}
