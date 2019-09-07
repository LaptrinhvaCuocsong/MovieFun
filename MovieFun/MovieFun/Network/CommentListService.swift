//
//  CommentListService.swift
//  MovieFun
//
//  Created by nguyen manh hung on 8/8/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import Foundation
import FirebaseFirestore

class CommentListService {
    
    static let share = CommentListService()
    let db = Firestore.firestore()
    private let COLLECTION_NAME = "groupComment"
    private let SUB_COLLECTION_NAME = "groupComments"
    private var listener: ListenerRegistration?
    
    func addListener(completion: (([GroupComment]?, Error?) -> Void)?) {
        let completion:(([GroupComment]?, Error?) -> Void) = completion ?? {_,_ in}
        if let accountId = AccountService.share.getAccountId() {
            listener = db.collection(COLLECTION_NAME).document(accountId).collection(SUB_COLLECTION_NAME).addSnapshotListener {[weak self] (querySnapshot, error) in
                if error == nil {
                    if let documents = querySnapshot?.documents {
                        var groupComments = [GroupComment]()
                        for document in documents {
                            if let groupComment = self?.getGroupComment(dictionary: document.data()) {
                                groupComments.append(groupComment)
                            }
                        }
                        completion(groupComments, nil)
                    }
                    else {
                        completion(nil, nil)
                    }
                }
                else {
                    completion(nil, error)
                }
            }
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
    
    func fetchGroupComments(completion: (([GroupComment]?, Error?) -> Void)?) {
        let completion:(([GroupComment]?, Error?) -> Void) = completion ?? {_,_ in}
        if let accountId = AccountService.share.getAccountId() {
            let collectionRef = db.collection(COLLECTION_NAME).document(accountId).collection(SUB_COLLECTION_NAME)
            collectionRef.getDocuments(source: .default) {[weak self] (query, error) in
                if error == nil {
                    if let documents = query?.documents {
                        var groupComments = [GroupComment]()
                        for document in documents {
                            let data = document.data()
                            if let groupComment = self?.getGroupComment(dictionary: data) {
                                groupComments.append(groupComment)
                            }
                        }
                        completion(groupComments, nil)
                    }
                    else {
                        completion(nil, nil)
                    }
                }
                else {
                    completion(nil, error)
                }
            }
        }
        else {
            completion(nil, nil)
        }
    }
    
    func addGroupComment(groupMessage: GroupComment, completion: ((Bool?, Error?) -> Void)?) {
        let completion:((Bool?, Error?) -> Void) = completion ?? {_,_ in}
        if let accountId = AccountService.share.getAccountId() {
            let collectionRef = db.collection(COLLECTION_NAME).document(accountId).collection(SUB_COLLECTION_NAME)
            let movieInfo = Movie.getDictionary(from: groupMessage.movie!)
            let dictionary:[String:Any] = [
                "movie": movieInfo,
                "newMessage": groupMessage.newMessage!,
                "newSenderName": groupMessage.newSenderName!,
                "sendDate": groupMessage.sendDate!
            ]
            collectionRef.document("\(groupMessage.movie!.id!)").setData(dictionary) { (error) in
                if error == nil {
                    completion(true, nil)
                }
                else {
                    completion(false, error)
                }
            }
        }
        else {
            completion(nil, nil)
        }
    }
    
    func removeGroupComment(movieId: String, completion: ((Bool?, Error?) -> Void)?) {
        let completion:((Bool?, Error?) -> Void) = completion ?? {_,_ in}
        if let accountId = AccountService.share.getAccountId() {
            let collectionRef = db.collection(COLLECTION_NAME).document(accountId).collection(SUB_COLLECTION_NAME)
            collectionRef.document(movieId).delete { (error) in
                if error == nil {
                    completion(true, nil)
                }
                else {
                    completion(false, nil)
                }
            }
        }
        else {
            completion(nil, nil)
        }
    }
    
    private func getGroupComment(dictionary: [String: Any]) -> GroupComment {
        let groupComment = GroupComment()
        groupComment.movie = Movie.getMovie(from: dictionary["movie"] as? [String: Any])
        groupComment.newMessage = dictionary["newMessage"] as? String
        groupComment.newSenderName = dictionary["newSenderName"] as? String
        if let timeStamp = dictionary["sendDate"] as? Timestamp {
            groupComment.sendDate = timeStamp.dateValue()
        }
        return groupComment
    }
    
}
