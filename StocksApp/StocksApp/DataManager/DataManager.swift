import Foundation
import UIKit

// finhub api key = ctaqp2hr01qgsps7omt0ctaqp2hr01qgsps7omtg

//https://finnhub.io/api/v1/quote?symbol=AAPL&token=ctaqp2hr01qgsps7omt0ctaqp2hr01qgsps7omtg
//https://finnhub.io/api/v1/quote?symbol=MSFT&token=ctaqp2hr01qgsps7omt0ctaqp2hr01qgsps7omtg

// logo api = https://finnhub.io/api/logo?symbol=ADBE
// another logo api = https://eodhd.com/img/logos/US/MA.png

protocol DataManagerProtocol {
    func fetchStocks(ticker: String, completion: @escaping (StockModel?, Error?) -> Void)
}

final class DataManager: DataManagerProtocol {
    func fetchStocks(ticker: String, completion: @escaping (StockModel?, Error?) -> Void) {
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
}
