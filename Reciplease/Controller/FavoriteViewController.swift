//
//  FavoriteViewController.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 11/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//
import CoreData
import UIKit

class FavoriteViewController: UIViewController {
    
    static let segueId = "favoriteToDetail"
    var recipeToDisplay: EasyRecipeDisplay?
    var coreDataStore: CoreDataStore?
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let coreDataStack = appDelegate.coreDataStack
        coreDataStore = CoreDataStore(coreDataStack: coreDataStack)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == FavoriteViewController.segueId {
            let recipesVC = segue.destination as! DetailViewController
            recipesVC.recipeToDisplay = recipeToDisplay
        }
    }
    
    private func configureTableView() {
        favoriteTableView.rowHeight = 200
        favoriteTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
    }
}

extension FavoriteViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recipeToDisplay = coreDataStore?.favoriteRecipes[indexPath.row]
        
        self.recipeToDisplay = EasyRecipeDisplay(name: recipeToDisplay?.name ?? "",
                                                 image: recipeToDisplay?.image ?? "", url: recipeToDisplay?.url ?? "",
                                                 ingredients: recipeToDisplay?.ingredients ?? [""],
                                                 yield: Int(recipeToDisplay?.yield ?? 0 ), time: Int(recipeToDisplay?.time ?? 0 ))
        
        performSegue(withIdentifier: "favoriteToDetail", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let recipeName = coreDataStore?.favoriteRecipes[indexPath.row].name else { return }
        
        if tableView.dataHasChanged {
            tableView.reloadData()
        }
        coreDataStore?.deleteFavorite(named: recipeName)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
extension FavoriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            print("pas bon")
            return UITableViewCell()
        }
        
        let defaultImage = "https://pixabay.com/photos/food-kitchen-cook-tomatoes-dish-1932466/"
        
        if let defaultImageUrl = URL(string: defaultImage) {
            
            cell.recipeImageView.load(url: (URL(string: coreDataStore?.favoriteRecipes[indexPath.row].image ?? defaultImage) ?? defaultImageUrl))
        }
        
        cell.configure(title: (coreDataStore?.favoriteRecipes[indexPath.row].name ?? ""),
                       ingredients: coreDataStore?.favoriteRecipes[indexPath.row].ingredients?.joined(separator: ",") ?? "Nothing",
                       time: Int(coreDataStore?.favoriteRecipes[indexPath.row].time ?? 0),
                       yield: Int(coreDataStore?.favoriteRecipes[indexPath.row].yield ?? 0))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return coreDataStore?.favoriteRecipes.count ?? 0
    }
}
