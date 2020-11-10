//
//  RecipeListViewController.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 08/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import UIKit
class RecipeListViewController: UIViewController {
    
    var recipes: [Recipes] = []
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        print(recipes.count)
    }
    
    private func configureTableView() {
        recipeTableView.rowHeight = 150
        recipeTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
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
