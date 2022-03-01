//
//  ProfileController.swift
//  FireChat
//
//  Created by SANGMIN YEOM on 2022/02/28.
//

import UIKit
import Firebase

private let reuseId = "ProfileCell"

protocol ProfileControllerDelegate: AnyObject {
    func handleLogout()
}

class ProfileController: UITableViewController {
    // MARK: - properties
    weak var delegate: ProfileControllerDelegate?
    
    private var user: User? {
        didSet {
            headerView.user = user
        }
    }
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0,
                                                             width: view.frame.width,
                                                             height: 380))
    
    private lazy var footerView = ProfileFooter()
    
    // MARK: - lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
    
    // MARK: - helpers
    func configureUI() {
        self.tableView.backgroundColor = .white
        
        headerView.delegate = self
        
        self.tableView.tableHeaderView = headerView
        self.tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseId)
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInsetAdjustmentBehavior = .never
        
        self.tableView.rowHeight = 64
        self.tableView.backgroundColor = .systemGroupedBackground
        
        footerView.delegate = self
        
        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        self.tableView.tableFooterView = footerView
    }
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! ProfileCell
        
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else { return }
        print("DEBUG: \(viewModel.description)")
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension ProfileController: ProfileHeaderDelegate {
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileController: ProfileFooterDelegate {
    func handleLogout() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            self.delegate?.handleLogout()
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

