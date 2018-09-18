//
//  ChatRoomViewController.swift
//  
//
//  Created by duy on 9/13/18.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import Firebase
import RxSwift

class ChatRoomViewController: JSQMessagesViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var sendToID: String!
    
    var messageModel = MessageViewModel()
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        messageModel.observerMessages(sendToID: String(describing: sendToID!))
        self.senderId = Auth.auth().currentUser?.uid
        self.senderDisplayName = Auth.auth().currentUser?.email
        _ = self.messageModel.messages.asObservable().subscribe(onNext: {[weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        })
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let msg = messageModel.messages.value[indexPath.row]
        if msg.isMediaMessage {
            if let media = msg.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: media.fileURL)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.present(playerController, animated: true, completion: nil)
            }
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "ip1"), diameter: 30)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFac = JSQMessagesBubbleImageFactory()
        return bubbleFac?.outgoingMessagesBubbleImage(with: UIColor.blue)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messageModel.messages.value[indexPath.row]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageModel.messages.value.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    @IBAction func backButtonDidTouched(_ sender: Any) {
        messageModel.removeObserve()
        dismiss(animated: true, completion: nil)
    }
    
    // send
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        messageModel.sendMessage(senderId: senderId, senderName: senderDisplayName, text: text, sendToID: String(describing: self.sendToID!))
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let alert = UIAlertController(title: "media message", message: "Please select a media", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let photo = UIAlertAction(title: "Photos", style: .default, handler: {(alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeImage)
        })
        let video = UIAlertAction(title: "Videos", style: .default, handler: {(alert: UIAlertAction) in
            self.chooseMedia(type: kUTTypeMovie)
        })
        alert.addAction(cancel)
        alert.addAction(photo)
        alert.addAction(video)
        present(alert, animated: true, completion: nil)
    }
    
    
    // picker
    
    private func chooseMedia(type: CFString) {
        picker.mediaTypes = [type as String]
        present(picker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pic = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let data = UIImageJPEGRepresentation(pic, 0.01)
            messageModel.sendMedia(image: data, video: nil, senderId: self.senderId, senderName: self.senderDisplayName, sendToID: self.sendToID!)
            
        } else if let pic = info[UIImagePickerControllerMediaURL] as? URL {
//            let video = JSQVideoMediaItem(fileURL: pic, isReadyToPlay: true)
//            self.messages.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: video))
        } else {
            return
        }
        
        self.dismiss(animated: true, completion: nil)
        self.collectionView.reloadData()
    }

}
