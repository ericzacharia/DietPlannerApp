//
//  ViewController.swift
//  DietPlanner
//
//  Created by Eric Zacharia on 4/9/21.
//

import UIKit

class FoodListViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var food: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.food = ["chicken breast", "banana", "egg", "broccoli", "Butterfinger"]
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    
}

extension FoodListViewController: UITableViewDataSource{
    //MARK: DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "foodCell")!
        cell.textLabel?.text = self.food[indexPath.row]
        return cell
    }
}

extension FoodListViewController: UITableViewDelegate{
    //MARK: Delegate

}

extension UIColor {
    var uChicagoRed = UIColor(hex: 0x800000)
}

