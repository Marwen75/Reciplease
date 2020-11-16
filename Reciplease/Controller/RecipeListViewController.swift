//
//  RecipeListViewController.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 08/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import UIKit
class RecipeListViewController: UIViewController {
    
    static let segueId = "recipeToDetail"
    var recipes: [Recipes] = []
    var recipeToDisplay: EasyRecipeDisplay?
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RecipeListViewController.segueId {
            let recipesVC = segue.destination as! DetailViewController
            recipesVC.recipeToDisplay = recipeToDisplay
        }
    }
    
    private func configureTableView() {
        recipeTableView.rowHeight = 200
        recipeTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
    }
}

extension RecipeListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeToDisplay = recipes[indexPath.row]
        self.recipeToDisplay = EasyRecipeDisplay(name: recipeToDisplay.label, image: recipeToDisplay.image, url: recipeToDisplay.url, ingredients: recipeToDisplay.ingredientLines, yield: recipeToDisplay.yield, time: recipeToDisplay.totalTime ?? 0)
        performSegue(withIdentifier: "recipeToDetail", sender: nil)
    }
}
extension RecipeListViewController: UITableViewDataSource {
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
