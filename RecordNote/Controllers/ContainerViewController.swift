////
////  ContainerViewController.swift
////  RecordNote
////
////  Created by coco j on 2018/12/25.
////  Copyright © 2018 coco j. All rights reserved.
////
//
//import UIKit
//
//class ContainerViewController: UIViewController {
//    
//    var selectedItemForToDoTableView : Item? {
//        didSet{
//            //loadTodoItems()
//        }
//    }
//    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    
//    let singleton = ToDoTableViewController()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        print("ContainerVIewのselectediTemは？\(selectedItemForToDoTableView)")
//    }
//    
//    
//    @IBAction func addButtonPressed(_ sender: UIButton) {
//        
//        var textField = UITextField()
//        
//        let alert = UIAlertController(title: "新しいToDoを追加する", message: "", preferredStyle: .alert)
//        
//        let action = UIAlertAction(title: "追加", style: .default) { (action) in
//            
//            let newTodoItem = TodoItem(context: self.context)
//            newTodoItem.title = textField.text!
//            newTodoItem.done = false
//            newTodoItem.parentItemForTodo = self.selectedItemForToDoTableView
//            print("ContainerVIewのselectedItemは(add内)？：\(self.selectedItemForToDoTableView?.title)")
//            print("ContainerViewのparentItemForTodoは(add内)? : \(newTodoItem.parentItemForTodo?.title)")
//            self.singleton.todoItemArray.append(newTodoItem)
//            
//            
//            self.saveTodoItems()
//        }
//        
//        alert.addTextField { (addTextField) in
//            addTextField.placeholder = "Create new item"
//            textField = addTextField
//        }
//        
//        alert.addAction(action)
//        
//        present(alert, animated: true, completion: nil)
//    }
//    
//    
//    
//    func saveTodoItems() {
//        do {
//            try context.save()
//            print("TodoItem was correctly saved!")
//            
//        } catch {
//            print("Error saving todoItem context, \(error)")
//        }
//        //self.tableView.reloadData()
//        
//    }
//    
//    
//}
