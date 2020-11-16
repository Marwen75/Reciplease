//
//  Extension+Viewcontroller.swift
//  Reciplease
//
//  Created by Marwen Haouacine on 08/11/2020.
//  Copyright © 2020 marwen. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func displayAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func loadImageDataFromUrl(imageUrl: String) -> Data{
        guard let url = URL(string: imageUrl) else {return Data()}
        
        do {
            let data =  try Data(contentsOf: url)
            return data
        } catch let error as RecipeSearchError {
            displayAlert(title: error.errorDescription, message: error.failureReason)
        } catch {
            displayAlert(title: "Oups", message: "Erreur inconnue")
        }
        return Data()
    }
}
