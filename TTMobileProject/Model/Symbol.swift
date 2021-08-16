//
//  Symbol.swift
//  TTMobileProject
//
//  Created by Mihailo Jovanovic on 15.8.21..
//

import Foundation

public struct Symbol {
    let id: String
    let name: String
    let tickerSymbol: String
    let isin: String
    let currency: String
    let stockExchangeName: String
    let decorativeName: String
    let quote: Quote
    
    public init(id: String, name: String, tickerSymbol: String, isin: String, currency: String, stockExchangeName: String, decorativeName: String, quote: Quote) {
        self.id = id
        self.name = name
        self.tickerSymbol = tickerSymbol
        self.isin = isin
        self.currency = currency
        self.stockExchangeName = stockExchangeName
        self.decorativeName = decorativeName
        self.quote = quote
    }
}

public struct Quote {
    let last: String
    let high: String
    let low: String
    let bid: String
    let ask: String
    let volume: String
    let dateTime: String
    let change: String
    let changePercent: String
    
    public init(last: String, high: String, low: String, bid: String, ask: String, volume: String, dateTime: String, change: String, changePercent: String) {
        self.last = last
        self.high = high
        self.low = low
        self.bid = bid
        self.ask = ask
        self.volume = volume
        self.dateTime = dateTime
        self.change = change
        self.changePercent = changePercent
    }
}
