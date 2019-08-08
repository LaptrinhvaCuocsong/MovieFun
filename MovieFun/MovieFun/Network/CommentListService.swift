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
    
    func addGroupComment(movieId: String, completion: ((Bool?, Error?) -> Void)?) {
        let completion:((Bool?, Error?) -> Void) = completion ?? {_,_ in}
        if let accountId = AccountService.share.getAccountId() {
            let collectionRef = db.collection(COLLECTION_NAME).document(accountId).collection(SUB_COLLECTION_NAME)
            let dictionary = [
                "movieId": movieId,
                "newMessage": "",
                "newSenderName": ""
            ]
            collectionRef.document(movieId).setData(dictionary) { (error) in
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
        groupComment.movieId = dictionary["movieId"] as? String
        groupComment.newMessage = dictionary["newMessage"] as? String
        groupComment.newSenderName = dictionary["newSenderName"] as? String
        return groupComment
    }
    
}
