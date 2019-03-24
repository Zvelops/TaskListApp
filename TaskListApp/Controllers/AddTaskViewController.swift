//
//  AddTaskViewController.swift
//  TaskListApp
//
//  Created by Victor Zerefos on 23/03/19.
//  Copyright © 2019 Victor Zerefos 🦁. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var taskTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Task"
        
        let navigationItem = UINavigationItem(title: "Add Task")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationBar.items = [navigationItem]
        
        //Creating a toolbar button ontop of the keyboard
        let toolBarDone = UIToolbar.init()
        toolBarDone.sizeToFit()
        toolBarDone.barTintColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        
        let flexspace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let barButtonDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        
        barButtonDone.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        toolBarDone.items = [flexspace, barButtonDone, flexspace]
        
        taskTitle.inputAccessoryView = toolBarDone
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(finishedEnteringTask))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

    }
    
    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func finishedEnteringTask() {
        view.endEditing(true)
    }
    
    @objc func doneButtonTapped() {
        
        guard let realm = RealmDataBase.realm else {
            return
        }
        
        let newTask = Task()
        
        let id = (realm.objects(Task.self).max(ofProperty: "id") as Int? ?? 0) + 1
        
        newTask.id = id
        newTask.title = taskTitle.text!
        newTask.dateCreated = NSDate()
        newTask.isDone = false
        
        do {
            try realm.write {
                realm.add(newTask)
            }
        } catch let erro as NSError {
            print("Could not add task" + erro.localizedDescription)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.init("addTask"), object: nil)
        
        dismiss(animated: true, completion: nil)
        
    }


}
