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
                        if let message = self?.getMessage(dictionay: data) {
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
    
    func addChatMessage(movieId: String, message: Message, completion: ((Bool?, Error?) -> Void)?) {
        let completion:((Bool?, Error?) -> Void) = completion ?? {_,_ in}
        let collectionRef = db.collection(COLLECTION_NAME).document(movieId).collection(SUB_COLLECTION_NAME)
        let dictionary:[String: Any] = [
            "accountId": message.accountId!,
            "accountName": message.accountName ?? "",
            "sendDate": message.sendDate ?? Date(),
            "content": message.content ?? ""
        ]
        collectionRef.addDocument(data: dictionary) { (error) in
            if error == nil {
                completion(true, nil)
            }
            else {
                completion(false, error)
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
                        if let message = self?.getMessage(dictionay: data) {
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
    
    private func getMessage(dictionay: [String: Any]) -> Message {
        var message = Message()
        message.accountId = dictionay["accountId"] as? String
        message.accountName = dictionay["accountName"] as? String
        if let timeStamp = dictionay["sendDate"] as? Timestamp {
            message.sendDate = timeStamp.dateValue()
        }
        message.content = dictionay["content"] as? String
        return message
    }
    
}
