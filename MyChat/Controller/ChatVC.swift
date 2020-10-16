//
//  ChatVC.swift
//  MyChat
//
//  Created by Vandan Patel on 10/15/20.
//

import UIKit
import MessageKit
import SDWebImage
import InputBarAccessoryView

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    var profileImageURL: String?
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class ChatVC: MessagesViewController {
    
    // MARK: - Properties
    private let currentUser: Sender
    private let otherUser: Sender
    private let messages: [MessageType]
        
    // MARK: - Life Cycle
    
    init(currentUser: Sender, otherUser: Sender, messages: [MessageType]) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        self.messages = messages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Helpers
    private func configureUI() {
        configureNavigationBar(withTitle: otherUser.displayName, prefersLargeTitles: false)
    }
}

extension ChatVC: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return message.sender.senderId == currentUser.senderId ? UIColor.systemPurple : UIColor(white: 0.9, alpha: 1.0)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == currentUser.senderId {
            avatarView.sd_setImage(with: URL(string: currentUser.profileImageURL ?? ""))
        } else {
            avatarView.sd_setImage(with: URL(string: otherUser.profileImageURL ?? ""))
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("DEBUG: \(text)")
        inputBar.inputTextView.text = ""
    }
}
