//
//  DetailViewController.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 10/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import SafariServices
import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var recipeDetailCustomView: RecipeDetailView!
    @IBOutlet weak var recipeDetailsTableView: UITableView!
    
    // MARK: - Properties
    var recipeModel: RecipeModel?
    private var ingredientLines: [String] = []
    private var favoriteRecipeStorage: FavoriteRecipeStorage?
    
    // MARK: - View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForFavorite()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRecipeDetails()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let coreDataStack = appDelegate.coreDataStack
        favoriteRecipeStorage = FavoriteRecipeStorage(coreDataStack: coreDataStack)
    }
    
    // MARK: - Actions
    @IBAction func favoriteButtonTaped(_ sender: UIBarButtonItem) {
        guard let recipe = self.recipeModel else {return}
        checkForFavorite()
        if !recipe.isFavorite {
            sender.tintColor = .systemGreen
            recipeModel?.isFavorite = true
            favoriteRecipeStorage?.addFavorite(recipe: recipe) { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.displayAlert(title: "Yum !", message: "This recipe has been saved in your favorite list.")
            }
        } else {
            sender.tintColor = .white
            recipeModel?.isFavorite = false
            favoriteRecipeStorage?.deleteFavorite(named: recipe.name) { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.displayAlert(title: "Done !", message: "This recipe has been deleted from your favorite list.")
            }
        }
    }
    
    @IBAction func getDirectionsButtonTaped(_ sender: Any) {
        getDirections()
    }
    
    // MARK: - Methods
    private func checkForFavorite() {
        guard let name = recipeModel?.name else {return}
        if favoriteRecipeStorage?.checkForFavoriteRecipe(named: name) == true { 
            recipeModel?.isFavorite = true
            favoriteButton.tintColor = .green
        } else {
            recipeModel?.isFavorite = false
            favoriteButton.tintColor = .white
        }
    }
    
    private func getDirections() {
        guard let recipeUrl = recipeModel?.url,
              let directionsUrl = URL(string: recipeUrl) else {return}
        // Opening an SFSafariVC for the user to read the recipes instruction
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: directionsUrl, configuration: config)
        present(vc, animated: true)
    }
    // setting the recipe details using our recipeModel
    private func setRecipeDetails() {
        guard let imgUrl = self.recipeModel?.image, let usableUrl = URL(string: imgUrl),
              let title = recipeModel?.name, let time = recipeModel?.time,
              let yield = recipeModel?.yield, let ingredientLines = recipeModel?.ingredients else {
            return
        }
        self.ingredientLines.append(contentsOf: ingredientLines)
        recipeDetailCustomView.recipeImageView.load(url: usableUrl)
        recipeDetailCustomView.recipeTitleLabel.text = title
        recipeDetailCustomView.timeLabel.text = time == 0 ? "N/A" : String(time)
        recipeDetailCustomView.yieldLabel.text = yield == 0 ? "N/A" : String(yield)
    }
}

// MARK: - Table View delegate
extension DetailViewController : UITableViewDelegate {
    // Creating a header for the ingredient list 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        label.backgroundColor = .black
        label.textColor = UIColor.white
        label.font = UIFont(name: "Chalkduster", size: 20)
        label.text = "Ingredients: "
        return label
    }
}

// MARK: - Table View datasource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientsDetailCell", for: indexPath)
        let ingredient = ingredientLines[indexPath.row]
        cell.textLabel?.text = "- \(ingredient)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ingredientLines.count)
    }
}
