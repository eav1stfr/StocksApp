import SwiftUI
import Charts

struct PricePoint: Identifiable {
    let id: String
    let price: Double
}

struct StockDetailView: View {
    @State private var selectedTopButton: String = "Chart"
    @State private var selectedBottomButton: String = "All"
    @State private var selectedID: String?
    var dismissAction: (() -> Void)?
    
    var stock: StockModel
    var stockPriceHistory: StockData?
    
    init(stock: StockModel, stockPriceHistory: StockData? , dismissAction: (() -> Void)? = nil) {
        self.stock = stock
        self.stockPriceHistory = stockPriceHistory
        self.dismissAction = dismissAction
    }
    
    private var pricePoints: [PricePoint] {
        stockPriceHistory?.timeSeries.map { key, value in
            PricePoint(id: key, price: Double(value.open) ?? 0)
        }
        .sorted { $0.id < $1.id } ?? []
    }
    
    private var filteredPricePoints: [PricePoint] {
        let calendar = Calendar.current
        let now = Date()

        return pricePoints.filter { price in
            guard let date = convertToDate(price.id) else { return false }

            switch selectedBottomButton {
            case "D":
                return calendar.isDateInToday(date)
            case "W":
                return date >= calendar.date(byAdding: .day, value: -7, to: now)!
            case "M":
                return date >= calendar.date(byAdding: .month, value: -1, to: now)!
            case "6M":
                return date >= calendar.date(byAdding: .month, value: -6, to: now)!
            case "1Y":
                return date >= calendar.date(byAdding: .month, value: -12, to: now)!
            case "All":
                return true
            default:
                return true
            }
        }
    }
    
    let topButtons = ["Chart", "Summary", "News", "Forecasts", "Ideas"]
    let bottomButtons = ["D", "W", "M", "6M", "1Y", "All"]
    
    var body: some View {
        VStack(spacing: 20) {
            headerView
            topButtonScrollView
            Divider()
            Spacer()
            stockPriceView
            chart
            Spacer()
            bottomButtonScrollView
            Spacer()
            buyButton
                .padding(.bottom, 16)
        }
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    private var headerView: some View {
        HStack {
            Button(action: {
                dismissAction?()
            }) {
                Image(systemName: "arrow.backward")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
            }
            Spacer()
            VStack {
                Text(stock.stockTicker)
                    .font(.title)
                    .fontWeight(.bold)
                Text(stock.companyName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "star")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(stock.isFavorite ? .yellow : .gray)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private var topButtonScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(topButtons, id: \.self) { button in
                    selectionButton(title: button, isSelected: selectedTopButton == button) {
                        selectedTopButton = button
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var stockPriceView: some View {
        VStack {
            Text("$\(stock.price)")
                .font(.system(size: 32, weight: .bold))
            
            Text(stock.changeInPrice)
                .foregroundColor(stock.positiveChange ? .green : .red)
                .fontWeight(.medium)
        }
    }
    
    @ViewBuilder
    private var bottomButtonScrollView: some View {
        HStack(spacing: 10) {
            ForEach(bottomButtons, id: \.self) { button in
                selectionButton(
                    title: button,
                    isSelected: selectedBottomButton == button) {
                        selectedBottomButton = button
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var buyButton: some View {
        Button(action: {}) {
            Text("Buy for \(stock.price)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .cornerRadius(25)
                .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding()
    }
    
    private func selectionButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .black : .gray)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.white : Color.clear)
                .cornerRadius(20)
                .shadow(color: isSelected ? .gray.opacity(0.3) : .clear, radius: 5, x: 0, y: 2)
        }
    }
    
    @ViewBuilder
    private var chart: some View {
        Chart {
            ForEach(filteredPricePoints) { price in
                LineMark(
                    x: .value("Date", price.id),
                    y: .value("Price", price.price))
                .foregroundStyle(Color.black)
                AreaMark(
                    x: .value("Date", price.id),
                    y: .value("Price", 0),
                    series: .value("Price", price.price)
                )
                .foregroundStyle(Color.black)
            }
            .foregroundStyle(Color.black)
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 260)
    }
    
    private func convertToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StockDetailView(
            stock: StockModel(
                price: "123",
                changeInPrice: "1",
                stockTicker: "man",
                companyName: "man",
                positiveChange: true,
                imageLink: "ayo"
            ),
            stockPriceHistory: nil
        )
    }
}




//Chart {
//    ForEach(viewModel.pricesPerPeriod) { priceDay in
//        LineMark(
//            x: .value("id", priceDay.id),
//            y: .value("Price", priceDay.price)
//        )
//        AreaMark(
//            x: .value("id", priceDay.id),
//            yStart: .value("Price", 0),
//            yEnd: .value("Price", priceDay.price)
//        )
//        .foregroundStyle(
//            Color.pink.opacity(0.2)
//        )
//    }
//    .foregroundStyle(Color.pink)
//
//    if let selectedData = viewModel.pricesPerPeriod.first(where: { $0.id == selectedID }) {
//        PointMark(
//            x: .value("id", selectedData.id),
//            y: .value("Price", selectedData.price)
//        )
//        .symbol {
//            ZStack {
//                Circle()
//                    .strokeBorder(Color.white, lineWidth: 4)
//                    .frame(width: 12, height: 12)
//                Circle()
//                    .fill(Color.pink)
//                    .frame(width: 8, height: 8)
//            }
//        }
//    }
//
//    if let selectedID {
//        RuleMark(x: .value("Index", selectedID))
//            .foregroundStyle(Color.clear)
//            .annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
//                VStack {
//                    Text(viewModel.getPriceForIndex(of: selectedID))
//                        .font(.title3)
//                    Text(viewModel.getDateForIndex(of: selectedID))
//                        .font(.caption)
//
//                }
//                .foregroundStyle(Color.white)
//                .padding(12)
//                .background(RoundedRectangle(cornerRadius: 10).fill(.pink.gradient).opacity(0.95))
//            }
//    }
//}
//.frame(height: 260)
//.padding(.top, 100)
//.chartXAxis(.hidden)
//.chartYAxis(.hidden)
//.chartXSelection(value: $selectedID)
