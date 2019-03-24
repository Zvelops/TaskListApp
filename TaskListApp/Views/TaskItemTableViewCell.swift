//
//  TaskItemTableViewCell.swift
//  TaskListApp
//
//  Created by Victor Zerefos on 23/03/19.
//  Copyright © 2019 Victor Zerefos 🦁. All rights reserved.
//

import UIKit

class TaskItemTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var status: UILabel!
    
    func cellData(task: Task) -> [Task] {
        
        title.text = task.title
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        createdAt.text = formatter.string(from: task.dateCreated as Date)
        status.text = task.isDone ? "Complete" : "Incomplete"
        
        return [task]
    }
    

}
