//
//  ConversationController.swift
//  FireChat
//
//  Created by SANGMIN YEOM on 2022/02/17.
//

import UIKit
import Firebase

private let reuseIdCell = "ConversationCell"

class ConversationController: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView()
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        authenticateUser()
    }
    
    // MARK: - actions
    @objc func showProfile() {
        logout()
    }
    
    @objc func showNewMessage() {
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    // MARK: - APIs
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        } else {
            print("DEBUG: User is logged in")
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch let error {
            print("DEBUG: error signing out. \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helpers
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
        }
        
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
        configureTableView()
        
        let image = UIImage(systemName: "person.circle.fill")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(showProfile))
        
        self.view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 56, width: 56)
        newMessageButton.layer.cornerRadius = 56 / 2
        newMessageButton.anchor(bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                                right: self.view.rightAnchor,
                                paddingBottom: 16, paddingRight: 24)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdCell)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        tableView.frame = self.view.frame
    }
    
}

// MARK: - delegate
extension ConversationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdCell, for: indexPath)
     
        cell.textLabel?.text = "text cell"
        
        return cell
    }
}

extension ConversationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - NewMessageControllerDelegate
extension ConversationController: NewMessageControllerDelegate {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        controller.dismiss(animated: false, completion: nil)
        let chat = ChatController(user: user)
        self.navigationController?.pushViewController(chat, animated: true)
    }
}
