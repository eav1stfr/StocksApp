import SwiftUI

struct StockDetailView: View {
    @State private var selectedTopButton: String = "Chart"
    @State private var selectedBottomButton: String = "All"
    var dismissAction: (() -> Void)?
    
    var stock: StockModel
    
    init(dismissAction: (() -> Void)? = nil, stock: StockModel) {
        self.stock = stock
        self.dismissAction = dismissAction
    }
    
    let topButtons = ["Chart", "Summary", "News", "Forecasts", "Ideas"]
    let bottomButtons = ["D", "W", "M", "6M", "1Y", "All"]
    
    var body: some View {
        VStack(spacing: 20) {
            headerView
            topButtonScrollView
            Spacer()
            stockPriceView
            Spacer()
            bottomButtonScrollView
            Spacer()
            buyButton
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
                ForEach(topButtons, id: \ .self) { button in
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
            Text("\(stock.price)")
                .font(.system(size: 32, weight: .bold))
            
            Text(stock.changeInPrice)
                .foregroundColor(.green)
                .fontWeight(.medium)
        }
    }
    
    @ViewBuilder
    private var bottomButtonScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(bottomButtons, id: \ .self) { button in
                    selectionButton(title: button, isSelected: selectedBottomButton == button) {
                        selectedBottomButton = button
                    }
                }
            }
            .padding(.horizontal)
        }
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
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StockDetailView(stock: StockModel(price: "123",
                                        changeInPrice: "1",
                                        stockTicker: "man",
                                        companyName: "man",
                                        positiveChange: true,
                                        imageLink: "ayo"))
    }
}
