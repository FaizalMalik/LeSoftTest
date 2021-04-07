//
//  UserDetailVC.swift
//  Test
//
//  Created by Faizal on 07/04/2021.
//

import UIKit

class UserDetailVC: UIViewController,StoryboardInstantiatable {
    
    static var storyboardName: String{
        return "Main"
    }
    
    //MARK: Outlets
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblUserAddress: UILabel!
    @IBOutlet var lblCompanyInfo: UILabel!
    
    //MARK: Properties
    var user:User! {
        didSet{
            DispatchQueue.main.async {
                guard let  userPassed = self.user else {
                    
                    return
                }
                
                self.lblName.text = userPassed.name
                self.lblUserName.text = userPassed.username
                self.lblEmail.text = userPassed.email
                self.lblUserAddress.text = """
                    \(userPassed.address.street ?? ""), \(userPassed.address.suite ?? ""), \(userPassed.address.zipcode ?? "")
                    """
                self.lblCompanyInfo.text = """
                    \(userPassed.company.name ?? "")) \n
                    \(userPassed.company.catchPhrase ?? "") \n
                    \(userPassed.company.bs ?? "")
                    """
            }
           
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
    }
    

    func setupView(){
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Details"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
