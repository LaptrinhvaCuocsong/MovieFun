//
//  CommentListTableViewCell.swift
//  MovieFun
//
//  Created by nguyen manh hung on 7/13/19.
//  Copyright © 2019 nguyen manh hung. All rights reserved.
//

import UIKit

class CommentListTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newCommentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var widthTimeLabel: NSLayoutConstraint!
    
    static let nibName = "CommentListTableViewCell"
    static let cellIdentify = "commentListTableViewCell"
    private let calendar = Calendar.current as NSCalendar
    
    var commentListRowVM: CommentListRowViewModel?
    
    func setUp(with viewModel: CommentListRowViewModel) {
        commentListRowVM = viewModel
        setContent()
    }
    
    private func setContent() {
        if let viewModel = commentListRowVM, let groupComment = viewModel.groupComment?.value, let movieInfo = viewModel.movieInformation {
            titleLabel.text = movieInfo.title
            if let sendDate = groupComment.sendDate {
                timeLabel.text = getTime(startDate: sendDate)
            }
            widthTimeLabel.constant = timeLabel.intrinsicContentSize.width
            if let posterPath = movieInfo.posterPath {
                posterImage.setImage(imageName: posterPath, imageSize: .w92)
            }
            if let newComment = groupComment.newMessage, let sender = groupComment.newSenderName {
                newCommentLabel.text = "\(sender): \(newComment)"
            }
        }
    }
    
    private func getTime(startDate: Date) -> String {
        var time = ""
        let currentDate = Date()
        let day = calendar.components(.day, from: startDate, to: currentDate, options: .wrapComponents)
        if let day = day.day {
            if day == 0 {
                let hours = calendar.component(.hour, from: startDate)
                let hoursStr = hours < 10 ? "0\(hours)" : "\(hours)"
                let minutes = calendar.component(.minute, from: startDate)
                let minutesStr = minutes < 10 ? "0\(minutes)" : "\(minutes)"
                time = "\(hoursStr):\(minutesStr)"
            }
            else if day >= 1 && day <= 28 {
                time = "\(day) days before"
            }
            else {
                let month = calendar.components(.month, from: startDate, to: currentDate, options: .wrapComponents)
                if let month = month.month {
                    if month == 0 {
                        time = "\(day) days before"
                    }
                    else if month >= 1 && month < 12 {
                        time = "\(month) months before"
                    }
                    else {
                        let year = calendar.components(.year, from: startDate, to: currentDate, options: .wrapComponents)
                        if let year = year.year {
                            time = "\(year) years before"
                        }
                    }
                }
            }
        }
        return time
    }
    
}
