//
//  NewsTableViewCell.swift
//  TTMobileProject
//
//  Created by Mihailo Jovanovic on 15.8.21..
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var headline2Label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initializeCell(id: String, headline: String, imageId: Int){
        headlineLabel.text = headline
        headline2Label.text = headline
        downloadImage(imageId: imageId)
    }
    
    func downloadImage(imageId: Int) {
        let imageUrl = "https://cdn.ttweb.net/News/images/%d.jpg?preset=w220_q40"
        let formatImageUrl = String(format: imageUrl, imageId)
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
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
