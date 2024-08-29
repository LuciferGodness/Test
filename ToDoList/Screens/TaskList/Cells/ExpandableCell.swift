//
//  ExpandableCell.swift
//  ToDoList
//
//  Created by Admin on 8/29/24.
//

import UIKit

final class ExpandableCell: UITableViewCell {
    @IBOutlet private weak var descriptionText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(description: String?) {
        descriptionText.text = description
    }
}
