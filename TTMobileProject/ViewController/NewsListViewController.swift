//
//  NewsViewController.swift
//  TTMobileProject
//
//  Created by Mihailo Jovanovic on 15.8.21..
//

import UIKit

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var newsListTableView: UITableView!
    
    var newsList: [News] = []
    
    var selectedNews: News?
    
    private var id: String = ""
    private var headline: String = ""
    private var imageId: Int = 0
    private var didEnterTag: Bool = false
    private var currentlyReadValue: String = ""
    private var parseDidFinish: Bool = false {
        didSet{
            if parseDidFinish{
                dataDidParse()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsListTableView.delegate = self
        newsListTableView.dataSource = self
        getNews()
        

        // Do any additional setup after loading the view.
    }
    
    func getNews() {
        // credentials encoded in base64
        let username = "android_tt"
        let password = "Sk3M!@p9e"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()

        // create the request
        guard let url = URL(string: "https://www.teletrader.rs/downloads/tt_news_list.xml") else { assertionFailure("Couldn't create URL"); return }
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
    
    private func dataDidParse() {
        DispatchQueue.main.async {
            self.newsListTableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsDetailSegue", let newsDetailsVC = segue.destination as? NewsDetailsViewController {
            newsDetailsVC.selectedNews = selectedNews
        }
    }
    
}

extension NewsListViewController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "NewsArticle" {
            id = attributeDict["id"] ?? "None"
        }
        if elementName == "Headline" {
            didEnterTag = true
        }
        if elementName == "ImageID" {
            didEnterTag = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if didEnterTag {
            currentlyReadValue += string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Result" {
            DispatchQueue.main.async {
                self.parseDidFinish = true
            }
        }
        if elementName == "NewsArticle" {
            newsList.append(News(id: id, headline: headline, imageId: imageId))
        }
        if elementName == "Headline" {
            headline = currentlyReadValue
            didEnterTag = false
            currentlyReadValue = ""
        }
        if elementName == "ImageID" {
            imageId = Int(currentlyReadValue) ?? 0
            didEnterTag = false
            currentlyReadValue = ""
        }
    }
}

extension NewsListViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell{
            
            cell.initializeCell(id: newsList[indexPath.row].id, headline: newsList[indexPath.row].headline, imageId: newsList[indexPath.row].imageId)
            
            return cell
        }else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNews = newsList[indexPath.row]
        performSegue(withIdentifier: "newsDetailSegue", sender: nil)
    }
    
}
