//
//  DetailViewController.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 10/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var recipeToDisplay: Recipes?
    private var ingredientLines: [String] = []
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var recipeDetailCustomView: RecipeDetailView!
    @IBOutlet weak var recipeDetailsTableView: UITableView!
    
    @IBAction func favoriteButtonTaped(_ sender: Any) {
        favoriteButton.image = UIImage(named: "fullStar")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try setRecipeDetails()
        } catch let error as RecipeSearchError {
            displayAlert(title: error.errorDescription, message: error.failureReason)
        } catch {
            displayAlert(title: "Oups !", message: "Erreur inconnue...")
        }
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
              let title = recipeToDisplay?.label, let time = recipeToDisplay?.totalTime,
              let yield = recipeToDisplay?.yield, let ingredientLines = recipeToDisplay?.ingredientLines else {
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
