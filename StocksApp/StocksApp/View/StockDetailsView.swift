//
//  StockDetailsView.swift
//  StocksApp
//
//  Created by Александр Эм on 30.12.2024.
//
import SwiftUI

struct StockDetailsView: View {
    var body: some View {
        VStack {
            Text("Hello world")
            UpperButton(buttonText: "Chart")
        }
    }
    
    var upperButton: some View {
        Text("Chart")
    }
}

struct UpperButton: View {
    var buttonText: String
    var body: some View {
        Button(action: {
            print("Button tapped")
        }, label: {
            Text(buttonText)
                .fontWeight(.bold)
                .font(.system(size: 25))
                .foregroundStyle(.black)
        })
    }
}

struct StockDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        StockDetailsView()
    }
}

//struct StockDetailsView: View {
//
//    @State var currentView: String = "Chart"
//
//    var body: some View {
//        ZStack {
//            Color(.systemBlue)
//                .ignoresSafeArea()
//            VStack {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 20) {
//                        UpperButton(buttonText: "Chart", currentView: currentView)
//                        UpperButton(buttonText: "Summary", currentView: currentView)
//                        UpperButton(buttonText: "News", currentView: currentView)
//                        UpperButton(buttonText: "Forecast", currentView: currentView)
//                        UpperButton(buttonText: "Chart", currentView: currentView)
//                    }
//                }
//                .padding(.horizontal)
//                Divider()
//                HStack {
//                    SquareButton(buttonText: "All")
//                }
//            }
//        }
//    }
//}
//
//struct SquareButton: View {
//    var buttonText: String
//    var body: some View {
//        Button(action: {
//            print("all button pressed")
//        }) {
//            Text(buttonText)
//                .fontWeight(.bold)
//                .foregroundColor(.white)
//                .padding()
//                .background(
//                    Color.black
//                        .cornerRadius(20)
//                        .frame(width: 60, height: 60)
//                )
//        }
//    }
//}
//
//struct UpperButton: View {
//    var buttonText: String
//    var currentView: String
//    var index: Int
//    var body: some View {
//        Button(action: {
//            store.handleUpperButtonTapped(at: index)
//        }) {
//            if currentView == buttonText {
//                Text(buttonText)
//                    .foregroundColor(.white)
//                    .fontWeight(.bold)
//                    .font(.system(size: 25))
//            } else {
//                Text(buttonText)
//                    .foregroundColor(.black)
//                    .fontWeight(.bold)
//                    .font(.system(size: 25))
//            }
//        }
//    }
//}
//
