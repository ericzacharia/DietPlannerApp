//
//  ViewController.swift
//  DietPlanner
//
//  Created by Eric Zacharia on 4/9/21.
//

import UIKit


class FoodListViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calorieCountLabel: UILabel!
    
    var food: [Food] = []
    var foodService: FoodService!
    var calorieCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.foodService = FoodService()
        self.calorieCountLabel.text = String(self.calorieCount)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let confirmedService = self.foodService else { return }
        //
        self.showSpinner()
        //
        confirmedService.getFood(completion: { foods, error in
            guard let foods = foods, error == nil else {
                return
            }
            self.food = foods
            self.tableView.reloadData()
        })
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (t) in
            print(self.food.count)
            if self.food.count > 0 {
                self.removeSpinner()}
            else{
                if self.food.isEmpty {// Create new Alert
                    let dialogMessage = UIAlertController(title: "Alert", message: "Unable to fetch data from API. Check your internet connection.", preferredStyle: .alert)
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                 })
                //Add OK button to a dialog message
                dialogMessage.addAction(ok)
                // Present Alert to
                    self.present(dialogMessage, animated: true, completion: nil)}
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? DetailViewController,
            let selectedIndexPath = self.tableView.indexPathForSelectedRow,
            let confirmedCell = self.tableView.cellForRow(at: selectedIndexPath) as? FoodCell else {return}
        let confirmedFood = confirmedCell.food
        destination.food = confirmedFood
    }
}

extension FoodListViewController: UITableViewDataSource{
    //MARK: DataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The following handles empty API's
        if self.food.count == 0 {
        tableView.setEmptyView(title: "Food items are currently unavailable.", message: "Your food items will be placed here.")
        }
        else {
        tableView.restore()
        }
        return self.food.count
    }
        
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "foodCell") as! FoodCell
        let currentFood = self.food[indexPath.row]
        cell.food = currentFood
        
        let like = UIImageView(frame: CGRect(x: 0, y: 65, width: 25, height: 30))
        like.image = UIImage(systemName: "hand.thumbsup")
        like.tintColor = .systemGreen
        cell.accessoryView = cell.food!.confirmedLiked ? like : .none

        let dislike = UIImageView(frame: CGRect(x: 0, y: 65, width: 25, height: 30))
        dislike.image = UIImage(systemName: "hand.thumbsdown")
        dislike.tintColor = .systemRed
        
        // Logic for deciding which accessoryView icon to display
        if cell.food!.confirmedLiked == true {
            cell.accessoryView = like
        } else {
            cell.accessoryView = cell.food!.confirmedDisliked ? dislike : .none
        }
        return cell
        
    }
}

//MARK: Empty API Styling
// The following styles the table view when the API is empty.
// Reference: https://medium.com/@mtssonmez/handle-empty-tableview-in-swift-4-ios-11-23635d108409
extension UITableView {
    func setEmptyView(title: String, message: String) {
    let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = UIColor.black
    titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
    messageLabel.textColor = UIColor.lightGray
    messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
    emptyView.addSubview(titleLabel)
    emptyView.addSubview(messageLabel)
    titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
    messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
    messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
    messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
    titleLabel.text = title
    messageLabel.text = message
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    self.backgroundView = emptyView
    self.separatorStyle = .none
    }
    func restore() {
    self.backgroundView = nil
    self.separatorStyle = .singleLine
}
}

extension FoodListViewController: UITableViewDelegate{
    //MARK: Delegate

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let liked = likedAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [liked])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let disliked = dislikedAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [disliked])
    }

    func likedAction(at indexPath: IndexPath) -> UIContextualAction {
        //MARK: Like Swipe Action
        let like = UIImageView(frame: CGRect(x: 0, y: 65, width: 25, height: 30))
        like.image = UIImage(systemName: "hand.thumbsup")
        like.tintColor = .systemGreen
        
        let toEat = food[indexPath.row]
        let cell = self.tableView.cellForRow(at: indexPath) as? FoodCell
        let action = UIContextualAction(style: .normal, title: "Delicious") {(action, view, completion) in
            toEat.confirmedLiked = !toEat.confirmedLiked
            toEat.confirmedLikedIndifferent = !toEat.confirmedLikedIndifferent
            print("liked:", toEat.confirmedLiked, ", disliked:", toEat.confirmedDisliked, ", liked indifference:", toEat.confirmedLikedIndifferent, ", disliked indifference:", toEat.confirmedDislikedIndifferent)
            if toEat.confirmedLiked == true && toEat.confirmedDisliked == true {
                self.calorieCount += (2 * Int(cell!.food!.calories))
                print(self.calorieCount)
                self.calorieCountLabel.text = String(self.calorieCount)
                toEat.confirmedDisliked = false
                toEat.confirmedDislikedIndifferent = true
            } else if toEat.confirmedLiked == true && toEat.confirmedDisliked == false {
                self.calorieCount += Int(cell!.food!.calories)
                print(self.calorieCount)
                self.calorieCountLabel.text = String(self.calorieCount)
                toEat.confirmedDisliked = false
                toEat.confirmedDislikedIndifferent = true
            }
            if toEat.confirmedLikedIndifferent == true {
                self.calorieCount -= Int(cell!.food!.calories)
                print(self.calorieCount)
                self.calorieCountLabel.text = String(self.calorieCount)
                toEat.confirmedDisliked = false
                toEat.confirmedDislikedIndifferent = true
            }
            print("liked:", toEat.confirmedLiked, ", disliked:", toEat.confirmedDisliked, ", liked indifference:", toEat.confirmedLikedIndifferent, ", disliked indifference:", toEat.confirmedDislikedIndifferent)
            completion(true)
            cell!.accessoryView = cell!.food!.confirmedLiked ? like : .none
        }
        action.backgroundColor = toEat.confirmedLiked ? .gray : .green
        action.title = toEat.confirmedLiked ? "Indifferent" : "Delicious"

        return action
    }
    func dislikedAction(at indexPath: IndexPath) -> UIContextualAction {
        //MARK: Dislike Swipe Action
        let dislike = UIImageView(frame: CGRect(x: 0, y: 65, width: 25, height: 30))
        dislike.image = UIImage(systemName: "hand.thumbsdown")
        dislike.tintColor = .systemRed

        let toNotEat = food[indexPath.row]
        let cell = self.tableView.cellForRow(at: indexPath) as? FoodCell
        let action = UIContextualAction(style: .normal, title: "Disgusting") {(action, view, completion) in
            toNotEat.confirmedDisliked = !toNotEat.confirmedDisliked
            toNotEat.confirmedDislikedIndifferent = !toNotEat.confirmedDislikedIndifferent
            print("liked:", toNotEat.confirmedLiked, ", disliked:", toNotEat.confirmedDisliked, ", liked indifference:", toNotEat.confirmedLikedIndifferent, ", disliked indifference:", toNotEat.confirmedDislikedIndifferent)
            if toNotEat.confirmedDisliked == true && toNotEat.confirmedLiked == true {
                self.calorieCount -= (2 * Int(cell!.food!.calories))
                print(self.calorieCount)
                self.calorieCountLabel.text = String(self.calorieCount)
                toNotEat.confirmedLiked = false
                toNotEat.confirmedLikedIndifferent = true

            } else if toNotEat.confirmedDisliked == true && toNotEat.confirmedLiked == false {
                self.calorieCount -= Int(cell!.food!.calories)
                print(self.calorieCount)
                self.calorieCountLabel.text = String(self.calorieCount)
                toNotEat.confirmedLiked = false
                toNotEat.confirmedLikedIndifferent = true
            }
            if toNotEat.confirmedDislikedIndifferent == true {
                self.calorieCount += Int(cell!.food!.calories)
                print(self.calorieCount)
                self.calorieCountLabel.text = String(self.calorieCount)
                toNotEat.confirmedLiked = false
                toNotEat.confirmedLikedIndifferent = true
            }
            print("liked:", toNotEat.confirmedLiked, ", disliked:", toNotEat.confirmedDisliked, ", liked indifference:", toNotEat.confirmedLikedIndifferent, ", disliked indifference:", toNotEat.confirmedDislikedIndifferent)
            completion(true)
            cell!.accessoryView = cell!.food!.confirmedDisliked ? dislike : .none
        }
        action.backgroundColor = toNotEat.confirmedDisliked ? .gray : .red
        action.title = toNotEat.confirmedDisliked ? "Indifferent" : "Disgusting"
        return action
    }
}
