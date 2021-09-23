//
//  DetailViewController.swift
//  DietPlanner
//
//  Created by Eric Zacharia on 4/17/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    
    var food: Food!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodImageView.load(url: URL(string: self.food.imageUrl)!)
        self.foodNameLabel.text = self.food.name
        self.caloriesLabel.text = String(self.food.calories)
        self.proteinLabel.text = String(self.food.protein)
        self.carbohydratesLabel.text = String(self.food.carbohydrates)
        self.fatLabel.text = String(self.food.fat)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async {[weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
