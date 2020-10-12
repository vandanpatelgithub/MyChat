//
//  ConversationsVC.swift
//  MyChat
//
//  Created by Vandan Patel on 10/2/20.
//

import UIKit
import Firebase

private let reusableIdentifier = "ConversationCell"

class ConversationsVC: UIViewController {
    
    // MARK: - Properties
    private let tableView = UITableView()
    
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
    
    // MARK: - API
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil  {
            presentLogInScreen()
        } else {
            print("DEBUG: user is logged in. Configure controller")
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
        
        configureNavigationBar()
        configureTableView()
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
    }
    
    func presentLogInScreen() {
        DispatchQueue.main.async { [weak self] in
            let controller = LogInVC()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true, completion: nil)
        }
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemPurple
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
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
