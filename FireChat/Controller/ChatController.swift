//
//  ChatController.swift
//  FireChat
//
//  Created by SANGMIN YEOM on 2022/02/23.
//

import UIKit

class ChatController: UICollectionViewController {
    // MARK: - properties
    private let user: User
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0,
                                                        width: view.frame.width, height: 50))
        return iv
    }()
    
    // MARK: - lifecycles
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - helpers
    func configureUI() {
        self.collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.username, prefersLargeTitles: false)
    }
}
