//
//  ViewController.swift
//  ToDoList
//
//  Created by 남지훈 on 2021/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tapEditButton: UIBarButtonItem!
    
    var doneButton: UIBarButtonItem?
    
    var taskStruct = [TaskStruct]() {
        didSet {
            self.saveTask()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(doneButtonTap))
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTask()
        // Do any additional setup after loading the view.cx
    }
    
    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = self.tapEditButton
        self.tableView.setEditing(false, animated: true)
    }
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.taskStruct.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
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
    
    func saveTask() {
        let dataMapping = self.taskStruct.map{
            [
                "todo": $0.todo,
                "complete": $0.complete
            ]
        }
        UserDefaults.standard.set(dataMapping, forKey: "User_Default_Set_Key")
    }
    
    func loadTask() {
       guard let dataLoad = UserDefaults.standard.object(forKey: "User_Default_Set_Key") as? [[String: Any]] else { return }
        self.taskStruct = dataLoad.compactMap({
            guard let todo = $0["todo"] as? String else { return nil}
            guard let complete = $0["complete"] as? Bool else { return nil}
            return TaskStruct(todo: todo, complete: complete)
        })
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
        
        
        if task.complete {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.taskStruct.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if self.taskStruct.isEmpty {
            self.doneButtonTap()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var tasks = self.taskStruct
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        self.taskStruct = tasks
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       var task = self.taskStruct[indexPath.row]
        task.complete = !task.complete
        self.taskStruct[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
