//
//  Cell.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 28.09.2022.
//

import Foundation

import UIKit

class Cell: UITableViewCell {

    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var imageViewCell: UIImageView!
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = cellView.frame.size.height / 4
        
        // iphone SE 1st gen
        if screenWidth == 320 {
            timeLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            predictionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            predictionLabel.textColor = UIColor(named: "labelColor")
            tempLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        // anything else
        } else {
            timeLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            predictionLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            predictionLabel.textColor = UIColor(named: "labelColor")
            tempLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            tempLabel.frame = CGRect(x: 250, y: 15, width: 95, height: 45)
        }
        
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5))
        }
    
}
