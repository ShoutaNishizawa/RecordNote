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
    var exampleArray = ["aa", "bb", "cc"]
    
    var selectedItemForToDoTableView : Item? {
        didSet{
            loadTodoItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("selectedItemForTodo(ViewdidLoadのtodolist)は？ : \(todoItemArray[0])")
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("\(todoItemArray.count)")
        return todoItemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        cell.textLabel?.text = todoItemArray[indexPath.row].title
        print("\(todoItemArray[indexPath.row].title)")
        let item = todoItemArray[indexPath.row]

        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        todoItemArray[indexPath.row].done = !todoItemArray[indexPath.row].done
        
        saveTodoItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "新しいToDoを追加する", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "追加", style: .default) { (action) in
            
            let newTodoItem = TodoItem(context: self.context)
            newTodoItem.title = textField.text!
            newTodoItem.done = false
            newTodoItem.parentItemForTodo = self.selectedItemForToDoTableView
            print("ContainerVIewのselectedItemは(add内)？：\(self.selectedItemForToDoTableView?.title)")
            print("ContainerViewのparentItemForTodoは(add内)? : \(newTodoItem.parentItemForTodo?.title)")
            self.todoItemArray.append(newTodoItem)
            
            self.saveTodoItems()
        }
        
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Create new item"
            textField = addTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
 
    
    func saveTodoItems() {
        do {
            try context.save()
            print("TodoItem was correctly saved!")
            
        } catch {
            print("Error saving todoItem context, \(error)")
        }
        

    }
    
    func loadTodoItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate : NSPredicate? = nil) {
        
        print("todoTableViewでのselectedItemForTodo、\(selectedItemForToDoTableView?.title)")
        let itemPredicate = NSPredicate(format: "parentItemForTodo.title MATCHES %@", selectedItemForToDoTableView!.title!)

        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [itemPredicate, addtionalPredicate])
        } else {
            request.predicate = itemPredicate
        }
        
        do {
            self.todoItemArray = try context.fetch(request)
            
            print("load completed and todoArray was inserted")
            print("todoitemArray インサートできてる？：\(todoItemArray[0].title)")
    
        } catch {
            print("Error fetching data from todoItem context \(error)")
        }
        
    }
    
}
