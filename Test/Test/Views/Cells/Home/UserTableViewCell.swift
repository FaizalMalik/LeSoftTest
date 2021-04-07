//
//  UserTableViewCell.swift
//  Test
//
//  Created by Faizal on 07/04/2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    //MARK: Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!

    //MARK: Properties
    var user: User! {
        
        didSet{
            guard user != nil else {
                return
            }
            
            lblName.text = user.username
            lblPhone.text = user.phone
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
