//
//  PizzeriasListCell.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 24.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import UIKit

class PizzeriasListCell: UITableViewCell, Reusable
{
    //MARK: - Reusable
    
    static var nib: UINib? {
        return UINib(nibName: String(describing: PizzeriasListCell.self), bundle: nil)
    }
    
    //MARK: -
    
    func setPizzeriaInfo(_ info: PizzeriasList.FetchPizzerias.ViewModel.DisplayedPizzerias)
    {
        textLabel?.text = info.name
        detailTextLabel?.text = "distance: \(info.distance)"
    }
}
