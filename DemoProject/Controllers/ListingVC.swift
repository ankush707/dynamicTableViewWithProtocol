//
//  ListingVC.swift
//  DemoProject
//
//  Created by Ankush Sharma on 27/03/22.
//

import UIKit
import Reachability


class ListingVC: UIViewController, ListingOutput {
    
    //Outlets
    @IBOutlet weak private var noDataVw: UIView! {
        didSet {
            noDataVw.isHidden = true
        }
    }
 
    
    @IBOutlet private var searchbar: UISearchBar!
    @IBOutlet private weak var noDataImgVw: UIImageView!
    @IBOutlet private weak var tblVw: UITableView!
    
    //variables
    private var userArr: [UserCore]?
    private var searchedUserArr: [UserCore]?
    
    private let userService: FetchUserService = APIManager()
    private var viewModal : ListingViewModel?
    private var activityIndicator : LoadMoreActivityIndicator!
    
    private var isLoadingList: Bool = false
    let reachability = try! Reachability()
    var since: Int = 0
    var searchActive: Bool = false
    
    
    //MARK: - Viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        //DBManager.sharedUserManager.cleanCart()
        tblVw.tableFooterView = UIView()
        activityIndicator = LoadMoreActivityIndicator(scrollView: tblVw, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 60)
        viewModal = ListingViewModel(fetchUserService: userService)
        viewModal?.listingOutput = self
        self.tblVw.dataSource = self
        self.fetchOfflineUsers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNetworkChangeNotiHandler()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopNotif()
    }
    
    
    
    //MARK: - Reachability
    private func setNetworkChangeNotiHandler() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        
        switch reachability.connection {
        case .wifi:
            if self.userArr?.count ?? 0 < 1 {
                self.fetchOfflineUsers()
            }
        case .cellular:
            if self.userArr?.count ?? 0 < 1 {
                self.fetchOfflineUsers()
            }
        case .unavailable:
            if self.userArr?.count ?? 0 < 1 {
                self.fetchOfflineUsers()
            }
        case .none:
            print("Nothing")
        }
    }
    
    private func stopNotif () {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    
    //MARK: - User data fetching
    private func fetchOfflineUsers() {
        DBManager.sharedUserManager.getUsersFromDatabase { userArr in
            self.userArr = userArr
            
            if self.userArr?.count ?? 0 < 1 {
                self.noDataVw.isHidden = false
                self.tblVw.isHidden = true
                
                if ReachabilityManager.isConnectedToNetwork() {
                    
                    self.getAllUsers(since: self.since)
                }
            } else {
                self.noDataVw.isHidden = true
                self.tblVw.isHidden = false
                self.since = self.userArr?.count ?? 0 - 1
            }
            
            self.tblVw.reloadData()
        }
    }
    
    private func getAllUsers(since: Int) {
        viewModal?.fetchUserList(since: since)
    }
    
    internal func updateView(user: [UserCore]?) {
        
        if userArr?.count ?? 0 > 0 {
            self.userArr?.append(contentsOf: user!)
        } else {
            self.userArr = user
        }
        
        DispatchQueue.main.async {
            self.tblVw.reloadData()
            if self.userArr?.count ?? 0 < 1 {
                self.noDataVw.isHidden = false
                self.tblVw.isHidden = true
            } else {
                self.noDataVw.isHidden = true
                self.tblVw.isHidden = false
            }
        }
        DBManager.sharedUserManager.saveUsersToCoreData(users: user)
        DispatchQueue.main.async { [weak self] in
            self?.isLoadingList = false
            self?.activityIndicator.stop()
        }
    }
}


// Table view logic
extension ListingVC : UITableViewDelegate, UITableViewDataSource  {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return searchedUserArr?.count ?? 0
        }
        return userArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchActive {
            return (self.searchedUserArr?[indexPath.row].cellForTableView(tableView: tableView, atIndexPath: indexPath))!
        }
        
        return (self.userArr?[indexPath.row].cellForTableView(tableView: tableView, atIndexPath: indexPath))!

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !ReachabilityManager.isConnectedToNetwork() {
            UtilityFunctions.showAlert(message: "Internet is not available")
            return
        }
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
        if searchActive {
            vc?.userData = self.searchedUserArr?[indexPath.row]
        } else {
            vc?.userData = self.userArr?[indexPath.row]
        }
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}


// Scrolling and adding data to listing logic

extension ListingVC {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !self.isLoadingList && ReachabilityManager.isConnectedToNetwork() && !searchActive) {
            activityIndicator.start {
                DispatchQueue.main.async {
                    
                    self.isLoadingList = true
                    
                    self.since = self.userArr?.count ?? 0 - 1
                    
                    self.getAllUsers(since: self.since)
                    
                }
            }
        }
    }
}


// Searching logic
extension ListingVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == "" {
            searchActive = false
        } else {
            searchActive = true
        }
        searchedUserArr = []
        searchedUserArr = userArr?.filter({ user in
            
            if let text = user.login {
                return text.lowercased().contains(searchText.lowercased())
            }
            return false
            
        })

        DispatchQueue.main.async {
            self.tblVw.reloadData()
        }
        
    }
}
