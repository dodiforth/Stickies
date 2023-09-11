//
//  DetailViewController.swift
//  Stickies
//
//  Created by Dowon Kim on 03/09/2023.
//

import UIKit

final class DetailViewController: UIViewController {

    
    @IBOutlet weak var sTredButton: UIButton!
    @IBOutlet weak var sTgreenButton: UIButton!
    @IBOutlet weak var sTblueButton: UIButton!
    @IBOutlet weak var sTpurpleButton: UIButton!
    
    // 버튼에 쉽게 접근하기 위해 배열로 만들어 놓기 (고차함수 사용 가능)
    lazy var sTbuttons: [UIButton] = {
        return [sTredButton, sTgreenButton, sTblueButton, sTpurpleButton]
    }()
    
    @IBOutlet weak var sTmainTextView: UITextView!
    @IBOutlet weak var sTbackgroundView: UIView!
    @IBOutlet weak var sTsaveButton: UIButton!
    //🚩
    @IBOutlet weak var sTdeleteButton: UIButton!
    
    // ToDo 색깔 구분을 위해 임시적으로 숫자저장하는 변수
    // (나중에 어떤 색상이 선택되어 있는지 쉽게 파악하기 위해)
    var temporaryNum: Int64? = 1
    
    // 모델(저장 데이터를 관리하는 코어데이터)
    let todoManager = CoreDataManager.shared
    
    var todoData: TodoData? {
        didSet {
            temporaryNum = todoData?.colour
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureUI()
    }
    
    func setup() {
        sTmainTextView.delegate = self
        
        sTbackgroundView.clipsToBounds = true
        sTbackgroundView.layer.cornerRadius = 10
        
        sTsaveButton.clipsToBounds = true
        sTsaveButton.layer.cornerRadius = 8
        
        //🚩
        sTdeleteButton.clipsToBounds = true
        sTdeleteButton.layer.cornerRadius = 8
        clearButtonColours()
    }
    
    func configureUI() {
        // 기존데이터가 있을때
        if let todoData = self.todoData {
            self.title = "메모 수정하기"
            
            guard let text = todoData.memoText else { return }
            sTmainTextView.text = text
            sTmainTextView.textColor = .black
            sTsaveButton.setTitle("UPDATE", for: .normal)
            //🚩
            sTdeleteButton.isEnabled = true
            sTmainTextView.becomeFirstResponder()
            let colour = MyColour(rawValue: todoData.colour)
            setupColourTheme(colour: colour)
            
        // 기존데이터가 없을때
        } else {
            self.title = "새로운 메모 생성하기"
            
            sTmainTextView.text = "텍스트를 여기에 입력하세요."
            sTmainTextView.textColor = .lightGray
            sTsaveButton.setTitle("SAVE", for: .normal)
            //🚩
            sTdeleteButton.backgroundColor = .gray
            sTdeleteButton.isEnabled = false
            setupColourTheme(colour: .red)
        }
        setupColourButton(num: temporaryNum ?? 1)
    }
    
    // 버튼 둥글게 깍기 위한 정확한 시점
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 모든 버튼에 설정 변경
        sTbuttons.forEach { button in
            button.clipsToBounds = true
            button.layer.cornerRadius = button.bounds.height / 2
        }
    }
    
    
    @IBAction func sTcolourButtonTapped(_ sender: UIButton) {
        // 임시숫자 저장
        self.temporaryNum = Int64(sender.tag)
        
        let colour = MyColour(rawValue: Int64(sender.tag))
        setupColourTheme(colour: colour)
        
        clearButtonColours()
        setupColourButton(num: Int64(sender.tag))
    }
    
    // 텍스트뷰/저장(업데이트)버튼 색상 설정
    func setupColourTheme(colour: MyColour? = .red) {
        sTbackgroundView.backgroundColor = colour?.backgroundColour
        sTsaveButton.backgroundColor = colour?.buttonColour
    }
    
    // 버튼 색상 새롭게 셋팅
    func clearButtonColours() {
        sTredButton.backgroundColor = MyColour.red.backgroundColour
        sTredButton.setTitleColor(MyColour.red.buttonColour, for: .normal)
        sTgreenButton.backgroundColor = MyColour.green.backgroundColour
        sTgreenButton.setTitleColor(MyColour.green.buttonColour, for: .normal)
        sTblueButton.backgroundColor = MyColour.blue.backgroundColour
        sTblueButton.setTitleColor(MyColour.blue.buttonColour, for: .normal)
        sTpurpleButton.backgroundColor = MyColour.purple.backgroundColour
        sTpurpleButton.setTitleColor(MyColour.purple.buttonColour, for: .normal)
    }
    
    // 눌려진 버튼 색상 설정
    func setupColourButton(num: Int64) {
        switch num {
        case 1:
            sTredButton.backgroundColor = MyColour.red.buttonColour
            sTredButton.setTitleColor(.white, for: .normal)
        case 2:
            sTgreenButton.backgroundColor = MyColour.green.buttonColour
            sTgreenButton.setTitleColor(.white, for: .normal)
        case 3:
            sTblueButton.backgroundColor = MyColour.blue.buttonColour
            sTblueButton.setTitleColor(.white, for: .normal)
        case 4:
            sTpurpleButton.backgroundColor = MyColour.purple.buttonColour
            sTpurpleButton.setTitleColor(.white, for: .normal)
        default:
            sTredButton.backgroundColor = MyColour.red.buttonColour
            sTredButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        // 기존데이터가 있을때 ===> 기존 데이터 업데이트
        if let todoData = self.todoData {
            // 텍스트뷰에 저장되어 있는 메세지
            todoData.memoText = sTmainTextView.text
            todoData.colour = temporaryNum ?? 1
            todoManager.updateTodo(newTodoData: todoData) {
                print("업데이트 완료")
                // 다시 전화면으로 돌아가기
                self.navigationController?.popViewController(animated: true)
            }
            
        // 기존데이터가 없을때 ===> 새로운 데이터 생성
        } else {
            let memoText = sTmainTextView.text
            todoManager.saveTodoData(todoText: memoText, colorInt: temporaryNum ?? 1) {
                print("저장완료")
                // 다시 전화면으로 돌아가기
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    //🚩
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        // Declare Alert Message
        let alertMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        // Create OK Button with action handler
        let ok = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            print("Ok button tapped")
            //todoManager.deleteTodo(data: TodoData, completion: <#T##() -> Void#>)
            if let todoData = self.todoData {
                // 텍스트뷰에 저장되어 있는 메세지
                todoData.memoText = self.sTmainTextView.text
                todoData.colour = self.temporaryNum ?? 1
                self.todoManager.deleteTodo(data: todoData) {
                    print("삭제 완료")
                    // 다시 전화면으로 돌아가기
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        // Create Cancel Button with action handler
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }

        // Add OK and Cancel button to dialog message
        alertMessage.addAction(ok)
        alertMessage.addAction(cancel)

        // Present Alert Message to user
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    
    // 다른 곳을 터치하면 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
}

extension DetailViewController: UITextViewDelegate {
    // 입력을 시작할때
    // (텍스트뷰는 플레이스홀더가 따로 있지 않아서, 플레이스 홀더처럼 동작하도록 직접 구현)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "텍스트를 여기에 입력하세요." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 입력이 끝났을때
    func textViewDidEndEditing(_ textView: UITextView) {
        // 비어있으면 다시 플레이스 홀더처럼 입력하기 위해서 조건 확인
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "텍스트를 여기에 입력하세요."
            textView.textColor = .lightGray
        }
    }
}

