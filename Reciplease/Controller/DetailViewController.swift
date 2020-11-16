//
//  DetailViewController.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 10/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var recipeToDisplay: EasyRecipeDisplay?
    private var ingredientLines: [String] = []
    var coreDataStore: CoreDataStore?
    
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var recipeDetailCustomView: RecipeDetailView!
    @IBOutlet weak var recipeDetailsTableView: UITableView!
    
    
    @IBAction func favoriteButtonTaped(_ sender: UIBarButtonItem) {
        
        guard let imgUrl = self.recipeToDisplay?.image, let url = recipeToDisplay?.url,
              let name = recipeToDisplay?.name, let time = recipeToDisplay?.time,
              let yield = recipeToDisplay?.yield, let ingredients = recipeToDisplay?.ingredients else {
            return
        }
        if sender.image == UIImage(named: "emptyStar") {
            sender.image = UIImage(named: "fullStar")
            coreDataStore?.addFavorite(name: name,
                                       ingredients: ingredients,
                                       yield: yield, time: time,
                                       url: url, image: imgUrl)
            displayAlert(title: "Yum !", message: "This recipe has been saved in your favorite list.")
        } else if sender.image == UIImage(named: "fullStar") {
            sender.image = UIImage(named: "emptyStar")
            coreDataStore?.deleteFavorite(named: name)
            displayAlert(title: "Done !", message: "This recipe has been deleted from your favorite list.")
        }
    }
    
    
    @IBAction func getDirectionsButtonTaped(_ sender: Any) {
        do {
            try getDirections()
        } catch let error as RecipeSearchError {
            displayAlert(title: error.errorDescription, message: error.failureReason)
        } catch {
            displayAlert(title: "Oups !", message: "Erreur inconnue...")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForFavorite()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try setRecipeDetails()
        } catch let error as RecipeSearchError {
            displayAlert(title: error.errorDescription, message: error.failureReason)
        } catch {
            displayAlert(title: "Oups !", message: "Erreur inconnue...")
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let coreDataStack = appDelegate.coreDataStack
        coreDataStore = CoreDataStore(coreDataStack: coreDataStack)
    }
    
    private func checkForFavorite() {
        guard let name = recipeDetailCustomView.recipeTitleLabel.text,
              coreDataStore?.checkForFavoriteRecipe(named: name) == true else {
            favoriteButton.image = UIImage(named: "emptyStar")
            return
        }
        favoriteButton.image = UIImage(named: "fullStar")
    }
    
    private func getDirections() throws {
        guard let recipeUrl = recipeToDisplay?.url else {
            throw RecipeSearchError.searchProblem
        }
        guard let directionsUrl = URL(string: recipeUrl) else {return}
        UIApplication.shared.open(directionsUrl)
    }
    
    private func setRecipeDetails() throws {
        
        guard let imgUrl = self.recipeToDisplay?.image, let usableUrl = URL(string: imgUrl),
              let title = recipeToDisplay?.name, let time = recipeToDisplay?.time,
              let yield = recipeToDisplay?.yield, let ingredientLines = recipeToDisplay?.ingredients else {
            throw RecipeSearchError.searchProblem
        }
        self.ingredientLines.append(contentsOf: ingredientLines)
        recipeDetailCustomView.recipeImageView.load(url: usableUrl)
        recipeDetailCustomView.recipeTitleLabel.text = title
        if time == 0 {
            recipeDetailCustomView.timeLabel.text = "N/A"
        } else {
            recipeDetailCustomView.timeLabel.text = String(time)
        }
        if yield == 0 {
            recipeDetailCustomView.yieldLabel.text = "N/A"
        } else {
            recipeDetailCustomView.yieldLabel.text = String(yield)
        }
    }
}

extension DetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
    }
}
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
