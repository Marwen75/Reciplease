//
//  RecipeListViewController.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 08/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import UIKit
class RecipeListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeTableView: UITableView!
    
    // MARK: - Properties
    static let segueId = "recipeToDetail"
    var recipes: [Recipes] = []
    var recipeModel: RecipeModel?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try configureTableView()
        } catch let error as RecipeSearchError {
            displayAlert(title: error.errorDescription, message: error.failureReason)
        } catch {}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RecipeListViewController.segueId {
            let recipesVC = segue.destination as! DetailViewController
            recipesVC.recipeModel = recipeModel
        }
    }
    
    // MARK: - Methods
    private func configureTableView() throws {
        recipeTableView.rowHeight = 200
        recipeTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
        guard !recipes.isEmpty else {
            throw RecipeSearchError.noResults
        }
    }
}

// MARK: - Table view delegate
extension RecipeListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeModel = recipes[indexPath.row]
        self.recipeModel = RecipeModel(name: recipeModel.label, image: recipeModel.image, url: recipeModel.url, ingredients: recipeModel.ingredientLines, yield: Int(recipeModel.yield ?? 0), time: Int(recipeModel.totalTime ?? 0.0))
        performSegue(withIdentifier: "recipeToDetail", sender: nil)
    }
}

// MARK: - Table view data source
extension RecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        if let defaultImageUrl = URL(string: "https://pixabay.com/photos/food-kitchen-cook-tomatoes-dish-1932466/") {
            cell.recipeImageView.load(url: (URL(string: recipes[indexPath.row].image) ?? defaultImageUrl))
        }
        cell.configure(title: (recipes[indexPath.row].label),
                       ingredients: recipes[indexPath.row].ingredientLines.joined(separator: ","),
                       time: Int(recipes[indexPath.row].totalTime ?? 0),
                       yield: Int(recipes[indexPath.row].yield ?? 0))
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
}
