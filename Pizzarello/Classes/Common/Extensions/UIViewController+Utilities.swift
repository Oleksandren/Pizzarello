//
//  UIViewController+Utilities.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 24.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import UIKit

//MARK: - Utilities

extension UIViewController
{
    func displayAlert(title: String,
                      message: String)
    {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let alertActionOK = UIAlertAction(title: Constants.Strings.ok,
                                          style: .default,
                                          handler: nil)
        alertController.addAction(alertActionOK)
        
        present(alertController,
                animated: true,
                completion: nil)
    }
    
    func hideKeyboardWhenTappedAround()
    {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

//MARK: - CleanSwift extensions

extension UIViewController
{
    func displayErrorMessage(errorMessage: String)
    {
        displayAlert(title: Constants.Strings.error,
                     message: errorMessage)
    }
}
