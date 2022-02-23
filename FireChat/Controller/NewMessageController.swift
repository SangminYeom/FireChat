//
//  NewMessageController.swift
//  FireChat
//
//  Created by SANGMIN YEOM on 2022/02/22.
//

import UIKit

private let reuseId = "UserCell"

protocol NewMessageControllerDelegate: AnyObject {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user:User)
}

class NewMessageController: UITableViewController {
    // MARK: - properties
    private var users = [User]()
    
    weak var delegate: NewMessageControllerDelegate?
    
    // MARK: - lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUsers()
    }
    
    // MARK: - selector
    @objc func handleDismissal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - api
    func fetchUsers() {
        Service.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: - helpers
    func configureUI() {
        configureNavigationBar(withTitle: "New Message", prefersLargeTitles: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                 target: self,
                                                                 action: #selector(handleDismissal))
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseId)
        tableView.rowHeight = 80
    }
}

// MARK: - UITableViewDataSource
extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! UserCell
     
        cell.user = users[indexPath.row]
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else { return }
        delegate.controller(self, wantsToStartChatWith: users[indexPath.row])
    }
}
