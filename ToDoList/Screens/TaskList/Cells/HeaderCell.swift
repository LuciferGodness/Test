//
//  HeaderCell.swift
//  ToDoList
//
//  Created by Admin on 8/29/24.
//

import UIKit

final class HeaderCell: UITableViewCell {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet weak var checkbox: UIImageView!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet weak var createfLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(title: String, completed: Bool, date: Date?) {
        self.title.text = title
        if let date = date {
            createfLabel.isHidden = false
            self.date.text = dateToString(dateString: date.description)
        } else {
            createfLabel.isHidden = true
        }
        
        let image = completed ? AppAssets.checkmarkSquare : nil
        checkbox.image = image
    }
    
    private func dateToString(dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd MMMM"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            return ""
        }
    }
}
