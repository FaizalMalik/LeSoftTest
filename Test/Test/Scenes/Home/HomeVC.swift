//
//  HomeVC.swift
//  Test
//
//  Created by Faizal on 07/04/2021.
//

import UIKit
import SVProgressHUD

class HomeVC: UIViewController {
    //MARK: Outlets
    @IBOutlet var tableViewHome: UITableView!
    
    //MARK: Properties
    fileprivate var viewModel: HomeViewModel = {
           let viewModel = HomeViewModel(service: HomeService.shared)
           
           return viewModel
       }()
    private var emptyDatasource :TableViewDataSource<EmptyTableViewCell,EmptyCellModel>!

    private var datasourceHome :TableViewDataSource<UserTableViewCell,User>!
    
   
    //router
    lazy var router:HomeRouter = {
        return HomeRouter(viewModel: viewModel)
    }()
    enum Routes:String {
        case userDetail
    }
    
    //MARK: UIVIew Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        bindViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setupNav()
    }
    
    
    //MARK: Setup Methods
    func setupView() {
       
        self.setupNav()
        //TableView setup
        self.tableViewHome.tableFooterView = UIView()
        self.tableViewHome.delegate = self
        
    }
    func setupNav(){
        self.navigationItem.title = "Home"
    }
    
    func bindViewModel(){
       
        //Binding the showloading status
        self.viewModel.showLoadingStatus.addObserver(self) { (status,message) in
            if status == true {
           
                SVProgressHUD.show(withStatus: message)

            
            }else{
                
                SVProgressHUD.dismiss(withDelay: 0.2  ){
                    print("Alert===>", message)
                   //Write code here to Display the Alert message
                    
                }
                

            }
        }
        
        //Binding the Datasourse model
        self.viewModel.usersdatasourceModels.addAndNotify(fireNow:false,observer: self) { (_) in
            
                       self.updateDataSource()
                       
    }
       
        self.viewModel.fetchUsersList()
        
    }
    //Data Source Methods
    func updateDataSource(){

        self.datasourceHome = TableViewDataSource(cellIdentifier: UserTableViewCell.className, items: self.viewModel.usersdatasourceModels.value, configureCell: { (cell, vm, ip) in

            cell.user = vm

        })
        
        DispatchQueue.main.async {
                    //Empty Tableview case check
            if  self.viewModel.usersdatasourceModels.value.isEmpty{
                          
                        self.tableViewHome.dataSource =  self.emptyDatasource
                      
                
                    }else{
                       self.tableViewHome.dataSource =  self.datasourceHome
                
                

                    }
                    
                    self.tableViewHome.reloadData()
                        
       }
        
    }
    
}


extension HomeVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let user = self.viewModel.usersdatasourceModels.value[indexPath.row]
        
        self.router.route(to: Routes.userDetail.rawValue, from: self, parameters: ["user":user])
    }
}

