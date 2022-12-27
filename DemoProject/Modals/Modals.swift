//
//  InitialVC.swift
//  DemoProject
//
//  Created by Ankush Sharma on 27/03/22.
//

import Foundation
import UIKit


class UserCore: NSObject, Decodable, TableViewCompatible {
    var reuseIdentifier: String {
        return "NormalCell"
    }
    
    var login: String?
    var id: Int?
    
    var node_id: String?
    var avatar_url: String?
    var gravatar_id: String?
    var url: String?
    var html_url: String?
    var followers_url: String?
    var following_url: String?
    var gists_url: String?
    var starred_url: String?
    
    var subscriptions_url: String?
    var organizations_url: String?
    var repos_url: String?
    var events_url: String?
    var received_events_url: String?
    var type: String?
    var site_admin: Bool?
    var _notes: String?
    var notes: String?  { return _notes ?? "" }
    
        public override init() {
            super.init()
        }
    
        
        func cellForTableView(tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
            
            if indexPath.row % 4 != 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells().reuseIdentifierInvertedCell, for: indexPath) as! InvertedCell
                        cell.configureWithModel(self)
                        return cell
            }
            
            if let notes = self.notes, !notes.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells().reuseIdentifierNoteCell, for: indexPath) as! NoteCell
                        cell.configureWithModel(self)
                        return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells().reuseIdentifierNormalCell, for: indexPath) as! NormalCell
                    cell.configureWithModel(self)
                    return cell
        }
}

class UserDetail: NSObject, Decodable {
    var login: String?
    var id: Int?
    
    var node_id: String?
    var avatar_url: String?
    var gravatar_id: String?
    var url: String?
    var html_url: String?
    var followers_url: String?
    var following_url: String?
    var gists_url: String?
    var starred_url: String?
    
    var subscriptions_url: String?
    var organizations_url: String?
    var repos_url: String?
    var events_url: String?
    var received_events_url: String?
    var type: String?
    var site_admin: Bool?
    
    
    var name: String?
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var hireable: String?
    
    var bio: String?
    var twitter_username: String?
    var public_repos: Int?
    var public_gists: Int?
    var followers: Int?
    var following: Int?
    var created_at: String?
    var updated_at: String?
    
        public override init() {
            super.init()
        }
}
  

struct Cells {
    var reuseIdentifierNormalCell = "NormalCell"
    var reuseIdentifierNoteCell = "NoteCell"
    var reuseIdentifierInvertedCell = "InvertedCell"
}
