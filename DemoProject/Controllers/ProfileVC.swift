//
//  ProfileVC.swift
//  DemoProject
//
//  Created by Ankush Sharma on 27/03/22.
//

import Foundation

import UIKit

class ProfileVC: UIViewController, DetailOutput {
    func updateView(user: UserDetail?) {
        
        DispatchQueue.main.async {
            self.userDetailData = user
            self.setData()
        }
        
        
    }
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var followingLbl: UILabel!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var blogLbl: UILabel!
    
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var noteTxtVw: UITextView!
    
    private let userService: UserDetailService = APIManager()
    private var viewModal: DetailViewModel?
    var userData: UserCore?
    var userDetailData: UserDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        if let username = userData?.login {
            viewModal = DetailViewModel(userDetailService: userService)
            viewModal?.detailOutput = self
            viewModal?.fetchUserDeatil(username: username)
        }
        
        
    }
    
    private func setData() {
        
        self.titleLbl.text = userData?.login?.uppercased()
        self.imgVw.loadImageAsync(with: userDetailData?.avatar_url, placeholder: UIImage.init(named: "user"))
        
        if let followers = userDetailData?.followers {
            self.followersLbl.text = "Followers: \(followers)"
        }
        
        if let following = userDetailData?.following {
            self.followingLbl.text = "Following: \(following)"
        }
        
        if let name = userDetailData?.name {
            self.nameLbl.text = "Name: \(name)"
        }
        
        if let company = userDetailData?.company {
            self.companyLbl.text = "Company: \(company)"
        }
        
        if let blog = userDetailData?.blog {
            self.blogLbl.text = "Blog: \(blog)"
        }
        
        
        self.noteTxtVw.text = userData?.notes
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func followersBtnAction(_ sender: Any) {
        guard let url = URL(string: userData?.followers_url ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func followingBtnAction(_ sender: Any) {
        guard let url = URL(string: userData?.following_url ?? "") else { return }
        UIApplication.shared.open(url)
    }
    
    
    @IBAction func saveBtnAction(_ sender: Any) {
        if self.noteTxtVw.text != "" {
            DBManager.sharedUserManager.updateAddons(user: self.userData,id: userData?.id, notes: self.noteTxtVw.text)
        }
        
    }
    
}
