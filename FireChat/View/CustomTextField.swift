//
//  CustomTextField.swift
//  FireChat
//
//  Created by SANGMIN YEOM on 2022/02/21.
//

import UIKit

class CustomTextField: UITextField {
    init(placeHoler: String) {
        super.init(frame: .zero)
        
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = .white
        keyboardAppearance = .dark
        attributedPlaceholder = NSAttributedString(string: placeHoler,
                                                   attributes: [.foregroundColor : UIColor.white])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
