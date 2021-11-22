//
//  ViewController.swift
//  ToDoList
//
//  Created by 남지훈 on 2021/11/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tapEditBtn(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        
       let alert = UIAlertController(title: "오늘 뭐하지?", message: nil, preferredStyle: .alert)
       let registAlert = UIAlertAction(title: "등록", style: .default, handler: {_ in})
       let cancelAlert = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(cancelAlert)
        alert.addAction(registAlert)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "할 일을 입력해주세요!"
        })
        self.present(alert, animated: true, completion: nil)
        
    }
}

