//
//  SymbolDetailViewController.swift
//  TTMobileProject
//
//  Created by Mihailo Jovanovic on 14.8.21..
//

import UIKit

class SymbolDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var isinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var stockExchangeLabel: UILabel!
    @IBOutlet weak var decorativeLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var bidLabel: UILabel!
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var changePercentLabel: UILabel!
    
    var selectedSymbol: Symbol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = selectedSymbol?.name
        idLabel.text = selectedSymbol?.id
        tickerLabel.text = selectedSymbol?.tickerSymbol
        isinLabel.text = selectedSymbol?.isin
        currencyLabel.text = selectedSymbol?.currency
        stockExchangeLabel.text = selectedSymbol?.stockExchangeName
        decorativeLabel.text = selectedSymbol?.decorativeName
        lastLabel.text = selectedSymbol?.quote.last
        highLabel.text = selectedSymbol?.quote.high
        lowLabel.text = selectedSymbol?.quote.low
        bidLabel.text = selectedSymbol?.quote.bid
        askLabel.text = selectedSymbol?.quote.ask
        volumeLabel.text = selectedSymbol?.quote.volume
        dateLabel.text = selectedSymbol?.quote.dateTime
        changeLabel.text = selectedSymbol?.quote.change
        changePercentLabel.text = selectedSymbol?.quote.changePercent
        
        changeColor()
        changeColorPercent()
       
    }
    
    func changeColor() {
        guard let selectedSymbol = selectedSymbol else {
            return
        }
        if Double(selectedSymbol.quote.change) ?? 0 > 0{
            changeLabel.textColor = .green
        }else if Double(selectedSymbol.quote.change) ?? 0 < 0{
            changeLabel.textColor = .red
        }
        
    }
    func changeColorPercent() {
        guard let selectedSymbol = selectedSymbol else {
            return
        }
        if Double(selectedSymbol.quote.changePercent) ?? 0 > 0{
            changePercentLabel.textColor = .green
        }else if Double(selectedSymbol.quote.changePercent) ?? 0 < 0{
            changePercentLabel.textColor = .red
        }
    }
}
