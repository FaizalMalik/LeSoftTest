//
//  EmptyTableViewCell.swift
//
//  Created by Faizal on 07/04/2021.
//


import UIKit

class EmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    
  
    var cellModel:EmptyCellModel!{
        didSet{
            if cellModel != nil{
                self.imgEmpty.image = cellModel.image
                        self.lblText.text = cellModel.body
            }
           
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
//Model of Empty Cell
struct EmptyCellModel {
    let body:String
    let image:UIImage?
}
