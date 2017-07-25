//
//  PizzeriaDetailsCell.swift
//  Pizzarello
//
//  Created by Oleksandr Nechet on 26.07.17.
//  Copyright © 2017 Oleksandr Nechet. All rights reserved.
//

import UIKit

class PizzeriaDetailsCell: UITableViewCell, Reusable
{
    func setDisplayedItem(_ item: PizzeriaDetails.ViewModel.DisplayedItem)
    {
        textLabel?.text = item.title
        detailTextLabel?.text = item.value
    }
}
