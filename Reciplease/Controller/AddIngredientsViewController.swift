//
//  AddIngredientsViewController.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 02/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import UIKit

class AddIngredientsViewController: UIViewController {
    
    private var ingredients: [String] = []
    static let segueId = "showRecipesList"
    var recipeService = RecipeService(session: AlamoClient() as SessionProtocol)
    var recipes: [Recipes] = []
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredientsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AddIngredientsViewController.segueId {
            let recipesVC = segue.destination as! RecipeListViewController
            recipesVC.recipes = recipes
        }
    }
    
    @IBAction func addButtonTaped(_ sender: Any) {
        do {
            try addIngrendients()
        } catch let error as RecipeSearchError {
            displayAlert(title: error.errorDescription, message: error.failureReason)
        } catch {
            displayAlert(title: "Oups", message: "Erreur inconnue")
        }
    }
    
    @IBAction func clearButtonTaped(_ sender: Any) {
        clearIngrendientsList()
    }
    
    @IBAction func searchButtonTaped(_ sender: Any) {
        do {
             try getRecipes()
        } catch let error as RecipeSearchError {
            displayAlert(title: error.errorDescription, message: error.failureReason)
        } catch {
            displayAlert(title: "Oups!", message: "Erreur inconnue")
        }
    }
    
    func getRecipes() throws {
        guard !ingredients.isEmpty else {
            throw RecipeSearchError.noIngredients
        }
        toggleActivityIndicator(shown: true)
        recipeService.getRecipes(ingredients: ingredients) { result in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let recipes):
                    strongSelf.toggleActivityIndicator(shown: false)
                    strongSelf.recipes = recipes.hits.map { $0.recipe }
                    print(recipes.hits.count)
                    strongSelf.performSegue(withIdentifier: AddIngredientsViewController.segueId, sender: nil)
                case .failure(let error):
                    strongSelf.displayAlert(title: error.errorDescription, message: error.failureReason)
                }
            }
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        searchButton.isHidden = shown
    }
    
    private func addIngrendients() throws {
        guard let ingredient = ingredientTextField.text else {return}
        if ingredient.contains(" ") {
            throw RecipeSearchError.wrongSpelling
        }
        ingredients.append(ingredient)
        ingredientsTableView.reloadData()
        ingredientTextField.text = ""
    }
    
    private func clearIngrendientsList() {
        ingredients = []
        ingredientsTableView.reloadData()
    }
}

extension AddIngredientsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension AddIngredientsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
    }
}
extension AddIngredientsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        let ingredient = ingredients[indexPath.row]
        cell.textLabel?.text = "- \(ingredient)"
        return cell 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
}
