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
        
        // ViewControllerの背景色
        self.view.backgroundColor = UIColor.init(
            red:0.71, green: 1.0, blue: 0.95, alpha: 1)
        
        // スクリーンの横縦幅
        let screenWidth:CGFloat = self.view.frame.width
        let screenHeight:CGFloat = self.view.frame.height
       
        // ボタンのインスタンス生成
        let button = UIButton()
        // ボタンの位置とサイズを設定
        button.frame = CGRect(x:screenWidth/1.22, y:screenHeight/1.22,
                              width:65, height:65)
        
        let image = UIImage(named: "todoAddButton")
        
        button.setImage(image, for: .normal)
        //button.layer.cornerRadius = 30
        // タップされたときのaction
        button.addTarget(self,action: #selector(buttonTapped(sender:)),for: .touchUpInside)
        
        // Viewにボタンを追加
        self.view.addSubview(button)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("\(todoItemArray.count)")
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
        
        saveTodoItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func buttonTapped(sender : AnyObject) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "新しいToDoを追加する", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "追加", style: .default) { (action) in
            
            let newTodoItem = TodoItem(context: self.context)
            newTodoItem.title = textField.text!
            newTodoItem.done = false
            newTodoItem.parentItemForTodo = self.selectedItemForToDoTableView
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
        self.tableView.reloadData()
    }
    
    func loadTodoItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let itemPredicate = NSPredicate(format: "parentItemForTodo.title MATCHES %@", selectedItemForToDoTableView!.title!)

        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [itemPredicate, addtionalPredicate])
        } else {
            request.predicate = itemPredicate
        }
        
        do {
            self.todoItemArray = try context.fetch(request)
            
            print("load completed and todoArray was inserted")
    
        } catch {
            print("Error fetching data from todoItem context \(error)")
        }
        
    }
    
}
