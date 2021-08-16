//
//  NewsDetailsViewController.swift
//  TTMobileProject
//
//  Created by Mihailo Jovanovic on 15.8.21..
//

import UIKit

class NewsDetailsViewController: UIViewController {

    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    var selectedNews: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage(presets: UIDevice.current.orientation.isLandscape ? "w800_q70" : "w320_q50")
        titleLabel.text = selectedNews?.headline
        footerLabel.text = selectedNews?.headline
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            if UIDevice.current.orientation.isLandscape {
                downloadImage(presets: "w800_q70")
            } else {
                downloadImage(presets: "w320_q50")
            }
        }
    
    func downloadImage(presets: String) {
        guard let selectedNews = selectedNews else { return }
        let imageUrl = "https://cdn.ttweb.net/News/images/%d.jpg?preset=%@"
        let formatImageUrl = String(format: imageUrl, selectedNews.imageId, presets)
        guard let url = URL(string: formatImageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.imageNews.image = image
            }
        }.resume()
    }
}
