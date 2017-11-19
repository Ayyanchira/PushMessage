//
//  MessageInformationTableViewCell.swift
//  PushMessage
//
//  Created by Akshay Ayyanchira on 11/19/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import UIKit

class MessageInformationTableViewCell: UITableViewCell {

    @IBOutlet var infoTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
