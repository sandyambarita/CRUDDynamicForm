//
//  ListCell.swift
//  CRUD
//
//  Created by sandy ambarita on 05/03/20.
//  Copyright © 2020 Fundtastic. All rights reserved.
//

import Foundation
import UIKit

class ListCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    var listVCDelegate: ListVCDelegate?
    
    func configureCell(data: ListResponsePayload) {
        lblName.text = data.crudName
    }
    
    @IBAction func btnUpdateOnClicked(_ sender: Any) {
        listVCDelegate?.updateOnClicked(cell: self)
    }
    
    @IBAction func btnDeleteOnClicked(_ sender: Any) {
        listVCDelegate?.deleteOnClicked(cell: self)
    }
}
