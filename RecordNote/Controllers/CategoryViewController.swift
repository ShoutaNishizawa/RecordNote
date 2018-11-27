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
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        selectedTitle = categoryArray[indexPath.row].name
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        destinationVC.itemNavigationTitle = selectedTitle
        
        if let indexPath = categoryTableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
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
            textField = addTextField    //このクロージャの中でしか使えないaddTextFieldをtextFieldに入れることで他の場所でも使えるようにする。
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
