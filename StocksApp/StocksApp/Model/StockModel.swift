import Foundation
import UIKit

struct StockModel {
    var price: String
    var changeInPrice: String
    var isFavorite: Bool = false
    var stockTicker: String
    var companyName: String
    var positiveChange: Bool
    var imageLink: String
}

struct StockModelToReceive: Codable {
    var c: Double
    var d: Double
    var dp: Double
    var h: Double
    var l: Double
    var o: Double
    var pc: Double
    var t: Double
}

struct MetaData: Codable {
    let information: String
    let symbol: String
    let lastRefreshed: String
    let outputSize: String
    let timeZone: String
    
    enum CodingKeys: String, CodingKey {
        case information = "1. Information"
        case symbol = "2. Symbol"
        case lastRefreshed = "3. Last Refreshed"
        case outputSize = "4. Output Size"
        case timeZone = "5. Time Zone"
    }
}

struct DailyData: Codable {
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}

struct StockData: Codable {
    let metaData: MetaData
    let timeSeries: [String: DailyData]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Time Series (Daily)"
    }
}
