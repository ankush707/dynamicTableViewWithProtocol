//
//  CustomCells.swift
//  DemoProject
//
//  Created by Ankush Sharma on 27/03/22.
//

import Foundation
import UIKit



class NormalCell: UITableViewCell, Configurable {
    
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    var model: UserCore?
    
    func configureWithModel(_ model: UserCore) {
        self.model = model
        self.nameLbl.text = model.login?.uppercased()
        self.detailLbl.text = model.login
        self.imgVw.loadImageAsync(with: model.avatar_url, placeholder: UIImage.init(named: "user"))
    }
    
    
}




class NoteCell: UITableViewCell, Configurable {
    
    var notes:String?
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var noteBtn: UIButton!
    
    @IBAction func noteBtnAction(_ sender: Any) {
        UtilityFunctions.showAlert(message: self.notes)
    }
    
    var model: UserCore?
    
    func configureWithModel(_ model: UserCore) {
        self.model = model
        self.nameLbl.text = model.login?.uppercased()
        self.detailLbl.text = model.login
        self.imgVw.loadImageAsync(with: model.avatar_url, placeholder: UIImage.init(named: "user"))
    }
}

class InvertedCell: UITableViewCell, Configurable {
    
    
    var model: UserCore?
    
    func configureWithModel(_ model: UserCore) {
        self.model = model
        self.nameLbl.text = model.login?.uppercased()
        self.detailLbl.text = model.login
        self.imgVw.loadImageAsync(with: model.avatar_url, placeholder: UIImage.init(named: "user"))
        self.imgVw.image?.inverseImage(cgResult: true)
        if model.notes == "" {
            noteBtn.isHidden = true
        } else {
            noteBtn.isHidden = false
        }
    }
    
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var noteBtn: UIButton!
    
    @IBAction func noteBtnAction(_ sender: Any) {
        UtilityFunctions.showAlert(message: model?.notes)
    }
}


