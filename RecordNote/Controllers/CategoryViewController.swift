//
//  CategoryViewController.swift
//  RecordNote
//
//  Created by coco j on 2018/11/26.
//  Copyright © 2018 coco j. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableViewの編集モードで複数選択を有効にする
        //categoryTableView.allowsMultipleSelectionDuringEditing = true
        
        loadCategories()
        
    }
    
    //MARK: - TableView Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MAEK: - Data Munipulation Methods
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category context, \(error)")
        }
        
        self.categoryTableView.reloadData()
    }
    
    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from category context \(error)")
        }
        
    }
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if categoryTableView.isEditing == true {
            //アラート表示
            var textField = UITextField()
            
            let alert = UIAlertController(title: "カテゴリ名を変更", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "保存", style: .default) { (action) in
                
                self.categoryArray[indexPath.row].name = textField.text
                self.saveCategories()
            }
            
            alert.addTextField { (addTextField) in
                addTextField.placeholder = "名前"
                textField = addTextField
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        } else {
            selectedTitle = categoryArray[indexPath.row].name
            
            performSegue(withIdentifier: "goToItems", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        destinationVC.itemNavigationTitle = selectedTitle
        
        if let indexPath = categoryTableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    
    //MARK: - edit methods
    @IBAction func startEditing(_ sender: Any) {
        isEditing = !isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        categoryTableView.setEditing(editing, animated: animated)
        if editing {
            // 編集開始
            self.editButton.title = "完了"
        } else {
            // 編集終了
            self.editButton.title = "編集"
            self.deleteRows()
        }
    }
    
    private func deleteRows() {
            guard let selectedIndexPaths = self.categoryTableView.indexPathsForSelectedRows else {
                return
            }
        
            // 配列の要素削除で、indexの矛盾を防ぐため、降順にソートする
            let sortedIndexPaths =  selectedIndexPaths.sorted { $0.row > $1.row }
            for indexPathList in sortedIndexPaths {
                categoryArray.remove(at: indexPathList.row) // 選択肢のindexPathから配列の要素を削除
            }
        
            // tableViewの行を削除
            categoryTableView.deleteRows(at: sortedIndexPaths, with: UITableView.RowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //セルの並び替え
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = categoryArray[sourceIndexPath.row]
        categoryArray.remove(at: sourceIndexPath.row)
        categoryArray.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 編集モードじゃない場合はreturn
        if categoryTableView.isEditing == true {
            if let _ = self.categoryTableView.indexPathsForSelectedRows {
                self.editButton.title = "削除"
            } else {
                // 何もチェックされていないときは完了を表示
                self.editButton.title = "完了"
            }
        }
    }
    
    //MARK: - Add New Categories
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //What will happen once the user clicks the Add Item button on our UIAlert
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Add a new category"
            textField = addTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func removeCategoryButton(_ sender: UIBarButtonItem) {
        isEditing = !isEditing
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
    }
}
