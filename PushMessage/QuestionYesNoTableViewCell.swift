//
//  QuestionYesNoTableViewCell.swift
//  PushMessage
//
//  Created by Akshay Ayyanchira on 11/19/17.
//  Copyright © 2017 Ayyanchira, Akshay Murari. All rights reserved.
//

import UIKit

class QuestionYesNoTableViewCell: UITableViewCell {

    @IBOutlet var questionTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func yesButtonPressed(_ sender: UIButton) {
    }
    @IBAction func noButtonPressed(_ sender: UIButton) {
    }
}
