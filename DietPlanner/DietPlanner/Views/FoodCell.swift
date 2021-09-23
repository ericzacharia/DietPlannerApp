//
//  FoodCell.swift
//  DietPlanner
//
//  Created by Eric Zacharia on 4/9/21.
//

import UIKit

class FoodCell: UITableViewCell {
    
    
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var calorieAmountLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    
    
    var food: Food? {
        didSet {
            self.foodNameLabel.text = food?.name
            self.calorieAmountLabel.text = food?.caloriesString
            
            DispatchQueue.global(qos: .userInitiated).async {
                var foodImageData = NSData(contentsOf: URL(string: self.food!.imageUrl)!)
                if foodImageData == nil { // Display backup image if URL from Food Service is unsupported (Defect Fix)
                    foodImageData = NSData(contentsOf: URL(string: "https://gf.nd.gov/gnf/conservation/images/species/tmb-bird-photo-unavailable.jpg")!)
                }
                DispatchQueue.main.async {
                    self.foodImageView.image = UIImage(data: foodImageData! as Data)
                    self.foodImageView.layer.cornerRadius = self.foodImageView.frame.width / 2
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

