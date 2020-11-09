//
//  AddIngredientsViewController.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 02/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import UIKit

class AddIngredientsViewController: UIViewController {
    
    var ingredients: [String] = []
    let segueId = "showRecipesList"
    
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
        if segue.identifier == segueId {
            let recipesVC = segue.destination as! RecipeListViewController
            recipesVC.ingredients = ingredients
        }
    }
    
    @IBAction func addButtonTaped(_ sender: Any) {
        addIngrendients()
    }
    
    @IBAction func clearButtonTaped(_ sender: Any) {
        clearIngrendientsList()
    }
    
    @IBAction func searchButtonTaped(_ sender: Any) {
        if !ingredients.isEmpty {
            performSegue(withIdentifier: segueId, sender: self)
        } else {
           displayAlert(title: "Nope", message: "Sans ingrédients, pas de cuisine")
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        searchButton.isHidden = shown
    }
    
    private func addIngrendients() {
        guard let ingredient = ingredientTextField.text else {return}
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
