//
//  ToDoTableViewController.swift
//  RecordNote
//
//  Created by coco j on 2018/12/06.
//  Copyright © 2018 coco j. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var todoItemArray = [TodoItem]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return todoItemArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        cell.textLabel?.text = todoItemArray[indexPath.row].title
        
        let item = todoItemArray[indexPath.row]
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        todoItemArray[indexPath.row].done = !todoItemArray[indexPath.row].done
        
        //saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
   
}
