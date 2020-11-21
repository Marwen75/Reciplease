//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 09/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import UIKit

// Custom table view cell for the recipe list

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var cookingTimeLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    
    
    override func prepareForReuse() {
        super .prepareForReuse()
        recipeImageView.image = nil
        recipeImageView.backgroundColor = .black
    }
    
    func configure(title: String, ingredients: String, time: Int, yield: Int) {
        recipeTitle.text = title
        recipeIngredients.text = ingredients
        if time == 0 {
            cookingTimeLabel.text = "N/A"
        } else {
        cookingTimeLabel.text = String(time)
        }
        if yield == 0 {
            yieldLabel.text = "N/A"
        } else {
        yieldLabel.text = String(yield)
        }
    }
}
