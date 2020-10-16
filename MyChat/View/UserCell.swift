//
//  UserCell.swift
//  MyChat
//
//  Created by Vandan Patel on 10/14/20.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemPurple
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "vandanpatel"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Vandan Patel"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
            
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addProfileImage()
        addUsernameFullnameLabels()
        accessoryType = .disclosureIndicator
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    fileprivate func addProfileImage() {
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 64, width: 64)
        profileImageView.layer.cornerRadius = 32
    }
    
    fileprivate func addUsernameFullnameLabels() {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    func configureCell(for user: User) {
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullName
        
        guard let url = URL(string: user.profileImageURL) else { return }
        profileImageView.sd_setImage(with: url)
    }
}
