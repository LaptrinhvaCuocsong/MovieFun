//
//  ChatService.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/11/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ChatService {
    
    static let share = ChatService()
    
    private let db = Firestore.firestore()
    private let COLLECTION_NAME = "chat"
    private let SUB_COLLECTION_NAME = "chatGroup"
    private var groupListener:[String:ListenerRegistration] = [String:ListenerRegistration]()

    func addListener(movieId: String, completion: ((([Message]?, Error?) -> Void))?) {
        let completion:((([Message]?, Error?) -> Void)) = completion ?? {_,_ in}
        let listener = db.collection(COLLECTION_NAME).document(movieId).collection(SUB_COLLECTION_NAME).addSnapshotListener {[weak self] (querySnapshot, error) in
            if error == nil {
                if let documentChanges = querySnapshot?.documentChanges {
                    var messages = [Message]()
                    for documentChange in documentChanges {
                        let data = documentChange.document.data()
                        if let message = self?.getMessage(messageId: documentChange.document.documentID, dictionay: data) {
                            messages.append(message)
                        }
                    }
                    completion(messages, nil)
                }
                else {
                    completion(nil, nil)
                }
            }
            else {
                completion(nil, error)
            }
        }
        groupListener[movieId] = listener
    }
    
    func removeListener(movieId: String) {
        if let listener = groupListener[movieId] {
            listener.remove()
        }
    }
    
    func addChatMessage(movieId: String, message: Message, completion: ((String?, Error?) -> Void)?) {
        let completion:((String?, Error?) -> Void) = completion ?? {_,_ in}
        let collectionRef = db.collection(COLLECTION_NAME).document(movieId).collection(SUB_COLLECTION_NAME)
        let dictionary:[String: Any] = [
            "isMessageImage": message.isMessageImage ?? false,
            "imageName": message.imageName ?? "",
            "accountId": message.accountId!,
            "accountName": message.accountName ?? "",
            "sendDate": message.sendDate ?? Date(),
            "content": message.content ?? ""
        ]
        var docRef: DocumentReference?
        docRef = collectionRef.addDocument(data: dictionary) { (error) in
            if error == nil {
                completion(docRef?.documentID, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    func fetchChatMessages(movieId: String, completion: (([Message]?, Error?) -> Void)?) {
        let completion:(([Message]?, Error?) -> Void) = completion ?? {_,_ in}
        let collectionRef = db.collection(COLLECTION_NAME).document(movieId).collection(SUB_COLLECTION_NAME)
        collectionRef.getDocuments(source: .default) {[weak self] (query, error) in
            if error == nil {
                if let documents = query?.documents {
                    var messages = [Message]()
                    for document in documents {
                        let data = document.data()
                        if let message = self?.getMessage(messageId: document.documentID, dictionay: data) {
                            messages.append(message)
                        }
                    }
                    completion(messages, nil)
                }
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    private func getMessage(messageId: String, dictionay: [String: Any]) -> Message {
        var message = Message()
        message.messageId = messageId
        message.isMessageImage = dictionay["isMessageImage"] as? Bool
        message.imageName = dictionay["imageName"] as? String
        message.accountId = dictionay["accountId"] as? String
        message.accountName = dictionay["accountName"] as? String
        if let timeStamp = dictionay["sendDate"] as? Timestamp {
            let sendDate = timeStamp.dateValue()
            let sendDateStr = Utils.share.stringFromDate(dateFormat: Utils.YYYY_MM_DD_HH_MM_SS, date: sendDate)
            message.sendDate = Utils.share.dateFromString(dateFormat: Utils.YYYY_MM_DD_HH_MM_SS, string: sendDateStr)
        }
        message.content = dictionay["content"] as? String
        return message
    }
    
}
