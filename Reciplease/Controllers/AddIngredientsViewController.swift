//
//  AddIngredientsViewController.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 02/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import UIKit
class AddIngredientsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    // MARK: - Properties
    static let segueId = "showRecipesList"
    
    private var ingredients: [String] = []
    private let recipeService = RecipeService(session: AlamoClient() as SessionProtocol)
    var recipes: [Recipes] = []
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
    }
    // preparing for the segue and sending the array of recipes to the recipelistVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AddIngredientsViewController.segueId {
            let recipesVC = segue.destination as! RecipeListViewController
            recipesVC.recipes = recipes
        }
    }
    
    // MARK: - Actions
    @IBAction func addButtonTaped(_ sender: Any) {
        do {
            try addIngrendients()
        } catch let error as RecipeSearchError {
            displayAlert(title: error.errorDescription, message: error.failureReason)
        } catch {
            
        }
    }
    
    @IBAction func clearButtonTaped(_ sender: Any) {
        clearIngrendientsList()
    }
    
    @IBAction func searchButtonTaped(_ sender: Any) {
        do {
            try getRecipes()
        } catch let error as ApiError {
            displayAlert(title: error.errorDescription, message: error.failureReason)
        } catch {
            displayAlert(title: "Oups", message: "Erreur inconnue.")
        }
    }
    
    // MARK: - Methods
    func getRecipes() throws {
        toggleActivityIndicator(shown: true)
        // Checking that the user is connected to internet
        guard InternetConnectionVerifiyer.isConnectedToNetwork() else {
            toggleActivityIndicator(shown: false)
            throw ApiError.noInternet
        }
        // Using the recipe service to make our api call
        recipeService.getRecipes(ingredients: ingredients) { result in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let recipes):
                    strongSelf.recipes = recipes
                    // checking that there is a result
                    guard recipes.count > 0 else {
                        strongSelf.displayAlert(title: RecipeSearchError.noResults.errorDescription, message: RecipeSearchError.noResults.failureReason)
                        strongSelf.toggleActivityIndicator(shown: false)
                        return
                    }
                    // if there is at least one result, the segue is performed
                    strongSelf.performSegue(withIdentifier: AddIngredientsViewController.segueId, sender: nil)
                case .failure(let error):
                    strongSelf.displayAlert(title: error.errorDescription, message: error.failureReason)
                }
                strongSelf.toggleActivityIndicator(shown: false)
            }
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        searchButton.isHidden = shown
    }
    
    private func addIngrendients() throws {
        guard let ingredient = ingredientTextField.text else {return}
        // checking that something has been entered in the textfield
        guard !ingredient.isEmpty else {
            throw RecipeSearchError.noIngredients
        }
        // Re arranging the textfield text
        ingredients.append(contentsOf: ingredient.components(separatedBy: [" ", ","]))
        let sortedIngredients = ingredients.map {
            $0.trimmingCharacters(in: .whitespaces)
        }
        let filteredIngredients = sortedIngredients.filter { $0 != "" }
        ingredients = filteredIngredients
        ingredientsTableView.reloadData()
        ingredientTextField.text = ""
    }
    
    private func clearIngrendientsList() {
        ingredients = []
        ingredientsTableView.reloadData()
    }
}

// MARK: - Text field delegate
extension AddIngredientsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // Making sure that only characters are allowed in the textfield
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string == string.filter("abcdefghijklmnopqrstuvwxyz, ".contains)
    }
}

// MARK: - Table view data source
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
