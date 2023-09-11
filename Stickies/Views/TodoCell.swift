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
    
    //weak var delegate: UpdateButtonTap?
    
    // ToDoData를 전달받을 변수 (전달 받으면 ==> 표시하는 메서드 실행) ⭐️
    var todoData: TodoData? {
        didSet {
            configureUIwithData()
        }
    }
    
    // (델리게이트 대신에) 실행하고 싶은 클로저 저장
    // 뷰컨트롤러에 있는 클로저 저장할 예정 (셀(자신)을 전달)
    var sTupdateButtonPressed: (TodoCell) -> Void = { (sender) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // 기본 UI
    func configureUI() {
        sTbackgroundView.clipsToBounds = true
        sTbackgroundView.layer.cornerRadius = 8
        
        sTupdateButton.clipsToBounds = true
        sTupdateButton.layer.cornerRadius = 10
    }
    
    // 데이터를 가지고 적절한 UI 표시하기
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

        // Configure the view for the selected state
    }
    
    
    @IBAction func sTupdateButtonTapped(_ sender: UIButton) {
        print(#function)
        print("눌려라...")
        // 뷰컨트롤로에서 전달받은 클로저를 실행 (내 자신 ToDoCell을 전달하면서) ⭐️
        sTupdateButtonPressed(self)
        //delegate?.updateButtonTapped(cell: self)
    }
    
}

//protocol UpdateButtonTap: AnyObject {
//
//    func updateButtonTapped(cell: TodoCell)
//
//}

