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
    
    lazy var sTbuttons: [UIButton] = {
        return [sTredButton, sTgreenButton, sTblueButton, sTpurpleButton]
    }()
    
    @IBOutlet weak var sTmainTextView: UITextView!
    @IBOutlet weak var sTbackgroundView: UIView!
    @IBOutlet weak var sTsaveButton: UIButton!
    //🚩
    @IBOutlet weak var sTdeleteButton: UIButton!
    
    var temporaryNum: Int64? = 1
    
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
        if let todoData = self.todoData {
            self.title = "Update the Sticky"
            
            guard let text = todoData.memoText else { return }
            sTmainTextView.text = text
            sTmainTextView.textColor = .black
            sTsaveButton.setTitle("UPDATE", for: .normal)
            //🚩
            sTdeleteButton.isEnabled = true
            sTmainTextView.becomeFirstResponder()
            let colour = MyColour(rawValue: todoData.colour)
            setupColourTheme(colour: colour)
            
        } else {
            self.title = "Create a new Sticky"
            
            sTmainTextView.text = "Type Text Here."
            sTmainTextView.textColor = .lightGray
            sTsaveButton.setTitle("SAVE", for: .normal)
            //🚩
            sTdeleteButton.backgroundColor = .gray
            sTdeleteButton.isEnabled = false
            setupColourTheme(colour: .red)
        }
        setupColourButton(num: temporaryNum ?? 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sTbuttons.forEach { button in
            button.clipsToBounds = true
            button.layer.cornerRadius = button.bounds.height / 2
        }
    }
    
    
    @IBAction func sTcolourButtonTapped(_ sender: UIButton) {
        self.temporaryNum = Int64(sender.tag)
        
        let colour = MyColour(rawValue: Int64(sender.tag))
        setupColourTheme(colour: colour)
        
        clearButtonColours()
        setupColourButton(num: Int64(sender.tag))
    }
    
    func setupColourTheme(colour: MyColour? = .red) {
        sTbackgroundView.backgroundColor = colour?.backgroundColour
        sTsaveButton.backgroundColor = colour?.buttonColour
    }
    
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
        
        if let todoData = self.todoData {
            todoData.memoText = sTmainTextView.text
            todoData.colour = temporaryNum ?? 1
            todoManager.updateTodo(newTodoData: todoData) {
                print("Update Complete")
                self.navigationController?.popViewController(animated: true)
            }
            
        } else {
            let memoText = sTmainTextView.text
            todoManager.saveTodoData(todoText: memoText, colorInt: temporaryNum ?? 1) {
                print("Save Complete")
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
            if let todoData = self.todoData {
                self.todoManager.deleteTodo(data: todoData) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type Text Here." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Type Text Here."
            textView.textColor = .lightGray
        }
    }
}

