//
//  RecipeListViewController.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 08/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import UIKit
class RecipeListViewController: UIViewController {
    
    var ingredients: [String] = []
    let recipeService = RecipeService()
    var recipeSearchResult: RecipeSearchResult?
    //var hit: [Hit] = []
    var recipes: [Recipes] = []
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeTableView.rowHeight = 150
        recipeTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
        print(ingredients.count)
        getRecipes()
        print(recipes.count)
    }
    
    func getRecipes() {
        recipeService.getRecipes(ingredients: ingredients) { result in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let recipes):
                    strongSelf.recipeSearchResult = recipes
                    for hit in recipes.hits {
                        strongSelf.recipes.append(hit.recipe)
                    }
                    strongSelf.recipeTableView.reloadData()
                case .failure(let error):
                    strongSelf.displayAlert(title: error.errorDescription, message: error.failureReason)
                }
            }
        }
    }
}

extension RecipeListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
    }
}
extension RecipeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            print("pas bon")
            return UITableViewCell()
        }
        
        if let imageUrl = URL(string: recipes[indexPath.row].image) {
        cell.imageView?.load(url: imageUrl)
        }
        cell.configure(title: (recipes[indexPath.row].label),
                        ingredients: recipes[indexPath.row].ingredientLines.joined(separator: ","),
                        time: recipes[indexPath.row].totalTime!,
                        yield: recipes[indexPath.row].yield)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
}
