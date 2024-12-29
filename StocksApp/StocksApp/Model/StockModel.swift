import Foundation
import UIKit

struct StockModel {
    var price: String
    var changeInPrice: String
    var isFavorite: Bool = false
    var stockTicker: String
    var companyName: String
    var positiveChange: Bool
    var imageLink: String = "https://finnhub.io/api/logo?symbol="
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
