//
//  SymbolListViewController.swift
//  TTMobileProject
//
//  Created by Mihailo Jovanovic on 13.8.21..
//

import UIKit

class SymbolListViewController: UIViewController {

    @IBOutlet weak var symbolsTableView: UITableView!
    @IBOutlet weak var chgButton: UIButton!
    @IBOutlet weak var highLow: UIButton!
    @IBOutlet weak var bidAsk: UIButton!
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var ascendingButton: UIButton!
    @IBOutlet weak var descendingButton: UIButton!
    
    enum SymbolMode: Int {
        case chgLast = 0
        case bidAsk = 1
        case highLow = 2
    }
    
    enum OrderMode: Int {
        case defaultOrder = 0
        case ascending = 1
        case descending = 2
    }
    
    var viewMode: SymbolMode = .chgLast
    var orderMode: OrderMode = .defaultOrder
    
    var symbolList: [Symbol] = []
    var symbolListCopy: [Symbol] = []
    var selectedSymbol: Symbol?
    private var parseDidFinish: Bool = false {
        didSet{
            if parseDidFinish{
                dataDidChange()
            }
        }
    }
    private var viewModeDidChange: Bool = false {
        didSet{
            UserDefaults.standard.set(viewMode.rawValue, forKey: "symbolViewMode")
        }
    }
    private var orderModeDidChange: Bool = false {
        didSet{
            UserDefaults.standard.set(orderMode.rawValue, forKey: "symbolOrderMode")
        }
    }
    // Symbol properties
    private var id: String = ""
    private var name: String = ""
    private var tickerSymbol: String = ""
    private var isin: String = ""
    private var currency: String = ""
    private var stockExchangeName: String = ""
    private var decorativeName: String = ""
    // Quote properties
    private var last: String = ""
    private var high: String = ""
    private var low: String = ""
    private var bid: String = ""
    private var ask: String = ""
    private var volume: String = ""
    private var dateTime: String = ""
    private var change: String = ""
    private var changePercent: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symbolsTableView.delegate = self
        symbolsTableView.dataSource = self
        getSymbols()
        viewMode = SymbolMode(rawValue: UserDefaults.standard.integer(forKey: "symbolViewMode")) ?? .chgLast
        orderMode = OrderMode(rawValue: UserDefaults.standard.integer(forKey: "symbolOrderMode")) ?? .defaultOrder
        sortByOrderMode()
    }
    
    @IBAction func chgPressed(_ sender: UIButton) {
        viewMode = .chgLast
        viewModeDidChange = true
        dataDidChange()
    }
    @IBAction func highLowPressed(_ sender: Any) {
        viewMode = .highLow
        viewModeDidChange = true
        dataDidChange()
    }
    
    @IBAction func bidAskPressed(_ sender: Any) {
        viewMode = .bidAsk
        viewModeDidChange = true
        dataDidChange()
    }
    
    @IBAction func defaultPressed(_ sender: Any) {
        orderMode = .defaultOrder
        orderModeDidChange = true
        dataDidChange()
    }
    
    @IBAction func ascendingPressed(_ sender: Any) {
        orderMode = .ascending
        orderModeDidChange = true
        dataDidChange()
    }
    
    @IBAction func descendingPressed(_ sender: Any) {
        orderMode = .descending
        orderModeDidChange = true
        dataDidChange()
    }
    
    func getSymbols() {
        // credentials encoded in base64
        let username = "android_tt"
        let password = "Sk3M!@p9e"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()

        // create the request
        guard let url = URL(string: "https://www.teletrader.rs/downloads/tt_symbol_list.xml") else { assertionFailure("Couldn't create URL"); return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")

        //making the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { assertionFailure("Found an error!"); return }

            if let httpStatus = response as? HTTPURLResponse {
                // check status code returned by the http server
                print("status code = \(httpStatus.statusCode)")
                // process result
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            }
        }.resume()
    }

    private func dataDidChange() {
        DispatchQueue.main.async {
            self.symbolsTableView.reloadData()
        }
    }
    
    private func sortByOrderMode() {
        switch orderMode {
        case .descending:
            symbolList.sort(by: {
            $0.name < $1.name
        })
        case .ascending:
            symbolList.sort(by: {
            $0.name > $1.name
        })
        case .defaultOrder:
            symbolList = symbolListCopy
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "symbolDetailSegue", let symbolDetailVC=segue.destination as? SymbolDetailViewController {
            symbolDetailVC.selectedSymbol = selectedSymbol
        }
    }
}

extension SymbolListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbolList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "symbolCell", for: indexPath) as? SymbolTableViewCell {
            var firstItem: String = ""
            var secondItem: String = ""
            var changeColor:UIColor = UIColor.init(named: "defaultColor") ?? .black
            sortByOrderMode()
            switch viewMode {
                case .chgLast :
                    firstItem = symbolList[indexPath.row].quote.changePercent
                    secondItem = symbolList[indexPath.row].quote.last
                    if Double(symbolList[indexPath.row].quote.change) ?? 0 > 0 {
                        changeColor = .green
                    } else if Double(symbolList[indexPath.row].quote.change) ?? 0 < 0{
                        changeColor = .red
                    }
                case  .bidAsk :
                    firstItem = symbolList[indexPath.row].quote.bid
                    secondItem = symbolList[indexPath.row].quote.ask
                case .highLow :
                    firstItem = symbolList[indexPath.row].quote.high
                    secondItem = symbolList[indexPath.row].quote.low
                
            }
            cell.initializeCell(name: symbolList[indexPath.row].decorativeName, firstValue: firstItem, secondValue: secondItem, fontColor: changeColor)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSymbol = symbolList[indexPath.row]
        performSegue(withIdentifier: "symbolDetailSegue", sender: nil)
    }
    
    
}

extension SymbolListViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            if elementName == "Result" {
                symbolList.removeAll()
                parseDidFinish = false
            }
            guard elementName == "Symbol" || elementName == "Quote" else { return }
            
            if elementName == "Symbol" {
                id = attributeDict["id"] ?? "None"
                name = attributeDict["name"] ?? "None"
                tickerSymbol = attributeDict["tickerSymbol"] ?? "None"
                isin = attributeDict["isin"] ?? "None"
                currency = attributeDict["currency"] ?? "None"
                stockExchangeName = attributeDict["stockExchangeName"] ?? "None"
                decorativeName = attributeDict["decorativeName"] ?? "None"
            }
            if elementName == "Quote" {
                last = attributeDict["last"] ?? "None"
                high = attributeDict["high"] ?? "None"
                low = attributeDict["low"] ?? "None"
                bid = attributeDict["bid"] ?? "None"
                ask = attributeDict["ask"] ?? "None"
                volume = attributeDict["volume"] ?? "None"
                dateTime = attributeDict["dateTime"] ?? "None"
                change = attributeDict["change"] ?? "None"
                changePercent = attributeDict["changePercent"] ?? "None"
                
                let quote = Quote(last: last, high: high, low: low, bid: bid, ask: ask, volume: volume, dateTime: dateTime, change: change, changePercent: changePercent)
                let symbol = Symbol(id: id, name: name, tickerSymbol: tickerSymbol, isin: isin, currency: currency, stockExchangeName: stockExchangeName, decorativeName: decorativeName, quote: quote)
                symbolList.append(symbol)
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Result" {
            symbolListCopy = symbolList
            parseDidFinish = true
        }
    }
}


