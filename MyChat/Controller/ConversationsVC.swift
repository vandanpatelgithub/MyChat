//
//  ConversationsVC.swift
//  MyChat
//
//  Created by Vandan Patel on 10/2/20.
//

import UIKit
import Firebase

private let reusableIdentifier = "ConversationCell"

var loggedInUser: User?

class ConversationsVC: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView()
    
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.imageView?.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(didTapNewMessage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        authenticateUser()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func showProfile() {
        logout()
    }
    
    @objc func didTapNewMessage() {
        let controller = NewMessageVC()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - API
    func authenticateUser() {
        if let uid = Auth.auth().currentUser?.uid {
            if loggedInUser == nil {
                Service.fetchUser(withUID: uid) { [weak self] (user, error) in
                    if let error = error {
                        self?.showError(error.localizedDescription)
                    }
                    
                    if let user = user {
                        loggedInUser = user
                    }
                }
            }
        } else {
            presentLogInScreen()
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            presentLogInScreen()
        } catch let error {
            print("DEBUG: Error signing out \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helper Methods
    /// Called in viewDidLoad to set up UI
    func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
        configureTableView()
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        
        view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 56, width: 56)
        newMessageButton.layer.cornerRadius = 28
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 24)
    }
    
    func presentLogInScreen() {
        DispatchQueue.main.async { [weak self] in
            let controller = LogInVC()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true, completion: nil)
        }
    }
        
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80.0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reusableIdentifier)
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        setupTableViewConstraints()
    }
    
    // MARK: - Constraints
    func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - TableView Delegates

extension ConversationsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath)
        cell.textLabel?.text = "Conversation Cell"
        cell.selectionStyle = .none
        return cell
    }
}

extension ConversationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected \(indexPath.row)")
    }
}

// MARK: - NewMessageVCDelegate
extension ConversationsVC: NewMessageVCDelegate {
    func controller(_ controller: NewMessageVC, wantsToStartChatWith user: User) {
        controller.dismiss(animated: true, completion: nil)
        let currentUser = Sender(senderId: "123", displayName: "Vandan Patel", profileImageURL: loggedInUser?.profileImageURL)
        let otherUser = Sender(senderId: "456", displayName: "Arya Patel", profileImageURL: user.profileImageURL)
        let chatVC = ChatVC(currentUser: currentUser,
                            otherUser: otherUser,
                            messages: [Message(sender: currentUser,
                                               messageId: "1",
                                               sentDate: Date(),
                                               kind: .text("Hello, How are you?")),
                                       Message(sender: otherUser,
                                               messageId: "2",
                                               sentDate: Date(),
                                               kind: .text("I am fine, papa!"))])
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
