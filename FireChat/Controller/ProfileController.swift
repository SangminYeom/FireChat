//
//  ProfileController.swift
//  FireChat
//
//  Created by SANGMIN YEOM on 2022/02/28.
//

import UIKit

private let reuseId = "ProfileCell"

class ProfileController: UITableViewController {
    // MARK: - properties
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0,
                                                             width: view.frame.width,
                                                             height: 380))
    
    // MARK: - lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    // MARK: - helpers
    func configureUI() {
        self.tableView.backgroundColor = .white
        
        self.tableView.tableHeaderView = headerView
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInsetAdjustmentBehavior = .never
    }
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        return cell
    }
}

