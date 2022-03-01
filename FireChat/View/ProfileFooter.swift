//
//  ProfileFooter.swift
//  FireChat
//
//  Created by SANGMIN YEOM on 2022/03/01.
//

import UIKit

protocol ProfileFooterDelegate: AnyObject {
    func handleLogout()
}

class ProfileFooter: UIView {
    // MARK: - properties
    weak var delegate: ProfileFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    // MARK: - lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(logoutButton)
        logoutButton.anchor(left:leftAnchor, right: rightAnchor, paddingLeft: 32, paddingRight: 32)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.centerY(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - selectors
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
}
