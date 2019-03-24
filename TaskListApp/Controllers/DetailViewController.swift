//
//  DetailViewController.swift
//  TaskListApp
//
//  Created by Victor Zerefos on 23/03/19.
//  Copyright © 2019 Victor Zerefos 🦁. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateCreated: UILabel!
    @IBOutlet weak var isComplete: UISwitch!
    
    var selectedTask: Task!
    var index: Int!
    
    weak var delegate: TaskDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = selectedTask.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        let dateFormatted = formatter.string(from: selectedTask.dateCreated as Date)
        dateCreated.text = dateFormatted
        
        if selectedTask.isDone {
            
            isComplete.isOn = true
        }
        else {
            
            isComplete.isOn = false
        }

    }
    
    @objc func editButtonTapped() {
        
    }
    
    @IBAction func changeStatus(_ sender: Any) {
        
        delegate?.update()
        
        guard let realm = RealmDataBase.realm else { return }
        
        do {

            if isComplete.isOn {
                
                try realm.write {
                    
                    selectedTask.isDone = true
                }
                
            }
            else {
                
                try realm.write {
                    
                    selectedTask.isDone = false
                }
            }
            
        } catch let erro as NSError {
            
            print("Could not update task" + erro.localizedDescription)
        }
        
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Edit " + selectedTask.title, message: "", preferredStyle: .alert)
        
        let edit = UIAlertAction(title: "Edit", style: .default) { (action) in
            
            let textfield = alert.textFields![0] as UITextField
            
            guard let realm = RealmDataBase.realm else { return }
            
            do {
                
                try realm.write {
                    
                    self.selectedTask.title = textfield.text!
                }
                
            }catch {
                
                print("Could not edit task title")
            }
            
            self.titleLbl.text = self.selectedTask.title
            self.delegate?.update()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (inTextField) in
            
            inTextField.text = self.selectedTask.title
        }
        
        alert.addAction(edit)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
        
    }
    

}
