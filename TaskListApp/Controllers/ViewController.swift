//
//  ViewController.swift
//  TaskListApp
//
//  Created by Victor Zerefos on 23/03/19.
//  Copyright © 2019 Victor Zerefos 🦁. All rights reserved.
//

import UIKit
import RealmSwift

protocol TaskDelegate: class {
    func update()
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var taskItems: Results<Task>? {
        get {
            
            guard let realm = RealmDataBase.realm else { return nil }
            
            return realm.objects(Task.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Task List"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTask(_ :)), name: NSNotification.Name.init("addTask"), object: nil)

    }
    
    @objc func addNewTask(_ notification: NSNotification) {
        
        tableView.reloadData()
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("com.addTask"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexpath) in
            
            guard let realm = RealmDataBase.realm else { return }
            
            let selectedTask = self.taskItems![indexPath.row]
            
            do {
                try realm.write {
                    
                    realm.delete(selectedTask)
                }
            }catch let erro as NSError {
                
                print(erro.localizedDescription)
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = taskItems![indexPath.row]
        let taskTuple = (task, indexPath.row)
        
        performSegue(withIdentifier: "toDetail", sender: taskTuple)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail" {
            
            guard let destination = segue.destination as? DetailViewController else { return }
            guard let task = sender as? (Task, Int) else { return }
            destination.selectedTask = task.0
            destination.index = task.1
            
            destination.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! TaskItemTableViewCell
        
        let taskItem = taskItems![indexPath.row]
        
        _ = cell.cellData(task: taskItem)
        
        return cell
    }


}

extension ViewController: TaskDelegate {
    func update() {
        
        tableView.reloadData()
    }
    
    
}

