//
//  HeaderCell.swift
//  ToDoList
//
//  Created by Admin on 8/29/24.
//

import UIKit

final class HeaderCell: UITableViewCell {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var checkbox: UIButton!
    @IBOutlet private weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkbox.isUserInteractionEnabled = false
        checkbox.layer.borderColor = AppColors.gray
        checkbox.layer.borderWidth = 2.0
        
        checkbox.layer.cornerRadius = 5.0
        checkbox.clipsToBounds = true
    }
    
    func setup(title: String, completed: Bool, date: Date?) {
        self.title.text = title
        self.date.text = date?.description ?? ""
        
        let image = completed ? AppAssets.checkmarkSquare : nil
        checkbox.setImage(image, for: .normal)
    }
}
