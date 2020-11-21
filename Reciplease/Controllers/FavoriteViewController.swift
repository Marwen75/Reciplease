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
    
    // MARK: - Outlets
    @IBOutlet weak var favoriteTableView: UITableView!
    
    // MARK: - Properties
    static let segueId = "favoriteToDetail"
    var recipeModel: RecipeModel?
    var dataStorage: DataStorage?
    
    // MARK: - View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let coreDataStack = appDelegate.coreDataStack
        dataStorage = DataStorage(coreDataStack: coreDataStack)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == FavoriteViewController.segueId {
            let recipesVC = segue.destination as! DetailViewController
            recipesVC.recipeModel = recipeModel
        }
    }
    // MARK: - Methods
    private func configureTableView() {
        favoriteTableView.rowHeight = 200
        favoriteTableView.register(UINib(nibName: "RecipeTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipeTableViewCell")
    }
}

// MARK: - Table view delegate
extension FavoriteViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recipeModel = dataStorage?.favoriteRecipes[indexPath.row]
        
        self.recipeModel = RecipeModel(name: recipeModel?.name ?? "",
                                       image: recipeModel?.image ?? "", url: recipeModel?.url ?? "",
                                       ingredients: recipeModel?.ingredients ?? [""],
                                       yield: Int(recipeModel?.yield ?? 0 ), time: Int(recipeModel?.time ?? 0 ))
        
        performSegue(withIdentifier: "favoriteToDetail", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let recipeName = dataStorage?.favoriteRecipes[indexPath.row].name else { return }
        dataStorage?.deleteFavorite(named: recipeName)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        label.backgroundColor = .black
        label.numberOfLines = 5
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Chalkduster", size: 20)
        label.text = "You don't have any favorite recipes yet ! To add a recipe to your favorite list, click the star on the upper right of the recipe details."
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataStorage?.favoriteRecipes.isEmpty ?? true ? 500 : 0
    }
}
// MARK: - Table view Data source
extension FavoriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeTableViewCell else {
            
            return UITableViewCell()
        }
        
        let defaultImage = "https://pixabay.com/photos/food-kitchen-cook-tomatoes-dish-1932466/"
        
        if let defaultImageUrl = URL(string: defaultImage) {
            
            cell.recipeImageView.load(url: (URL(string: dataStorage?.favoriteRecipes[indexPath.row].image ?? defaultImage) ?? defaultImageUrl))
        }
        
        cell.configure(title: (dataStorage?.favoriteRecipes[indexPath.row].name ?? ""),
                       ingredients: dataStorage?.favoriteRecipes[indexPath.row].ingredients?.joined(separator: ",") ?? "Nothing",
                       time: Int(dataStorage?.favoriteRecipes[indexPath.row].time ?? 0),
                       yield: Int(dataStorage?.favoriteRecipes[indexPath.row].yield ?? 0))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataStorage?.favoriteRecipes.count ?? 0
    }
}
