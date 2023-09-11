//
//  TodoCell.swift
//  Stickies
//
//  Created by Dowon Kim on 03/09/2023.
//

import UIKit

final class TodoCell: UITableViewCell {
    
    
    @IBOutlet weak var sTbackgroundView: UIView!
    @IBOutlet weak var sTtodoTextLabel: UILabel!
    @IBOutlet weak var sTdateTextLabel: UILabel!
    @IBOutlet weak var sTupdateButton: UIButton!
    
    
    var todoData: TodoData? {
        didSet {
            configureUIwithData()
        }
    }

    var sTupdateButtonPressed: (TodoCell) -> Void = { (sender) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI() {
        sTbackgroundView.clipsToBounds = true
        sTbackgroundView.layer.cornerRadius = 8
        
        sTupdateButton.clipsToBounds = true
        sTupdateButton.layer.cornerRadius = 10
    }
    
    func configureUIwithData() {
        sTtodoTextLabel.text = todoData?.memoText
        sTdateTextLabel.text = todoData?.dateString
        guard let colourNum = todoData?.colour else { return }
        let colour = MyColour(rawValue: colourNum) ?? .red
        sTupdateButton.backgroundColor = colour.buttonColour
        sTbackgroundView.backgroundColor = colour.backgroundColour
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func sTupdateButtonTapped(_ sender: UIButton) {
        sTupdateButtonPressed(self)
    }
    
}
