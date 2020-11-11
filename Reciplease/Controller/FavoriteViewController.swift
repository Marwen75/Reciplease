//
//  FavoriteViewController.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 11/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    var recipes: [Recipes] = []
    var recipeToDisplay: Recipes?
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension FavoriteViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeToDisplay = recipes[indexPath.row]
        self.recipeToDisplay = recipeToDisplay
        performSegue(withIdentifier: "favoriteToDetail", sender: nil)
    }
}
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            print("pas bon")
            return UITableViewCell()
        }
        if let defaultImageUrl = URL(string: "https://pixabay.com/photos/food-kitchen-cook-tomatoes-dish-1932466/") {
            cell.recipeImageView.load(url: (URL(string: recipes[indexPath.row].image) ?? defaultImageUrl))
        }
        cell.configure(title: (recipes[indexPath.row].label),
                       ingredients: recipes[indexPath.row].ingredientLines.joined(separator: ","),
                       time: recipes[indexPath.row].totalTime ?? 0,
                       yield: recipes[indexPath.row].yield)
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
}
