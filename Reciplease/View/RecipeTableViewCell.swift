//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 09/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

        @IBOutlet weak var recipeImageView: UIImageView!
        @IBOutlet weak var recipeTitle: UILabel!
        @IBOutlet weak var recipeIngredients: UILabel!
        @IBOutlet weak var cookingTimeLabel: UILabel!
        @IBOutlet weak var yieldLabel: UILabel!
        
        func configure(title: String, ingredients: String, time: Int, yield: Int) {
            //recipeImageView.contentMode = .scaleAspectFill
            recipeTitle.text = title
            recipeIngredients.text = ingredients
            cookingTimeLabel.text = String(time)
            yieldLabel.text = String(yield)
        }
    
}
