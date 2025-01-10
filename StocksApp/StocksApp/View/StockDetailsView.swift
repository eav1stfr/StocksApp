import SwiftUI

struct StockDetailView: View {
    @State private var selectedTopButton: String = "Chart"
    @State private var selectedBottomButton: String = "All"
    
    var stock: StockModel = StockModel(price: "$131.93",
                                       changeInPrice: "+$0.12 (1.15%)",
                                       isFavorite: true,
                                       stockTicker: "AAPL",
                                       companyName: "Apple inc.",
                                       positiveChange: true,
                                       imageLink: "")
    
    let topButtons = ["Chart", "Summary", "News", "Forecasts", "Ideas"]
    let bottomButtons = ["D", "W", "M", "6M", "1Y", "All"]
    
    var body: some View {
        VStack(spacing: 20) {
            HStack (spacing: 50) {
                Image(systemName: "arrowshape.backward")
                    .foregroundColor(.black)
                VStack {
                    Text(stock.stockTicker)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(stock.companyName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Image(systemName: "star")
                    .foregroundColor(
                        stock.isFavorite ? .yellow : .gray
                    )
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(topButtons, id: \.self) { button in
                        Button(action: {
                            selectedTopButton = button
                        }) {
                            Text(button)
                                .fontWeight(.semibold)
                                .foregroundColor(selectedTopButton == button ? .black : .gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    selectedTopButton == button ? Color.white : Color.clear
                                )
                                .cornerRadius(20)
                                .shadow(color: selectedTopButton == button ? .gray.opacity(0.3) : .clear, radius: 5, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal)
            }
            Spacer()
            VStack {
                Text("$\(stock.price)")
                    .font(.system(size: 32, weight: .bold))
                
                Text(stock.changeInPrice)
                    .foregroundColor(.green)
                    .fontWeight(.medium)
            }
            Spacer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(bottomButtons, id: \.self) { button in
                        Button(action: {
                            selectedBottomButton = button
                        }) {
                            Text(button)
                                .fontWeight(.semibold)
                                .foregroundColor(selectedBottomButton == button ? .black : .gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    selectedBottomButton == button ? Color.white : Color.clear
                                )
                                .cornerRadius(20)
                                .shadow(color: selectedBottomButton == button ? .gray.opacity(0.3) : .clear, radius: 5, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button(action: {
                
            }) {
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
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StockDetailView()
    }
}
