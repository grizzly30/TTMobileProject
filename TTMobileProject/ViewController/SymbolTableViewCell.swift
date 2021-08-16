//
//  SymbolTableViewCell.swift
//  TTMobileProject
//
//  Created by Mihailo Jovanovic on 14.8.21..
//

import UIKit

class SymbolTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var chgLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func initializeCell(name: String, firstValue: String, secondValue: String,fontColor: UIColor) {
        symbolLabel.text = name
        chgLabel.text = firstValue
        lastLabel.text = secondValue
        chgLabel.textColor = fontColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
