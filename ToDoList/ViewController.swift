//
//  ViewController.swift
//  ToDoList
//
//  Created by 남지훈 on 2021/11/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    var taskStruct = [TaskStruct]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func tapEditBtn(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        
       let alert = UIAlertController(title: "오늘 뭐하지?", message: nil, preferredStyle: .alert)
        let registAlert = UIAlertAction(title: "등록", style: .default, handler: {[weak self] _ in
        guard let textFieldValue = alert.textFields?[0].text else { return }
        let task = TaskStruct(todo: textFieldValue, complete: false)
        self?.taskStruct.append(task)
        self?.tableView.reloadData()
       })
       let cancelAlert = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(cancelAlert)
        alert.addAction(registAlert)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "할 일을 입력해주세요!"
        })
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskStruct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = self.taskStruct[indexPath.row]
        cell.textLabel?.text = task.todo
        return cell
    }
}
