//
//  ViewController.swift
//  Stickies
//
//  Created by Dowon Kim on 02/09/2023.
//

import UIKit

final class ViewController: UIViewController {

    
    @IBOutlet weak var sTtableView: UITableView!
    
    // 모델(저장 데이터를 관리하는 코어데이터)
    let todoManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupTableView()
    }
    
    // 화면에 다시 진입할때마다 테이블뷰 리로드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sTtableView.reloadData()
    }
    
    func setupNaviBar() {
        self.title = "Stickies!"
        
        // 네비게이션바 우측에 Plus 버튼 만들기
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
    }

    func setupTableView() {
        sTtableView.dataSource = self
        // 테이블뷰의 선 없애기
        sTtableView.separatorStyle = .none
    }
    
    @objc func plusButtonTapped() {
        performSegue(withIdentifier: "TodoCell", sender: nil)
    }
    
    // (세그웨이를 실행할때) 실제 데이터 전달 (TodoData전달)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TodoCell" {
            let detailVC = segue.destination as! DetailViewController
            
            guard let indexPath = sender as? IndexPath else { return }
            detailVC.todoData = todoManager.getTodoListFromCoreData()[indexPath.row]
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoManager.getTodoListFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        print("실행돠ㅣㅁ??")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        // 셀에 모델(TodoData) 전달
        let todoData = todoManager.getTodoListFromCoreData()
        cell.todoData = todoData[indexPath.row]
        
        // 셀위에 있는 버튼이 눌렸을때 (뷰컨트롤러에서) 어떤 행동을 하기 위해서 클로저 전달
        cell.sTupdateButtonPressed = { [weak self] (sender) in
            // 뷰컨트롤러에 있는 세그웨이의 실행
            self?.performSegue(withIdentifier: "TodoCell", sender: indexPath)
        }
        print("나ㅣ미럴")
        
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TodoCell", sender: indexPath)
    }
    

    
    // 테이블뷰의 높이를 자동적으로 추청하도록 하는 메서드
    // (ToDo에서 메세지가 길때는 셀의 높이를 더 높게 ==> 셀의 오토레이아웃 설정도 필요)
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//extension ViewController: UpdateButtonTap {
//    func updateButtonTapped(cell: TodoCell) {
//        todoManager.updateTodo(newTodoData: TodoData, completion: nil)
//    }
//    
//}
