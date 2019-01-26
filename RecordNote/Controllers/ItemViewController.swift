//
//  ItemViewController.swift
//  RecordNote
//
//  Created by coco j on 2018/11/26.
//  Copyright © 2018 coco j. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var itemTableView: UITableView!
    
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //遷移後のタブバー画面で表示するタイトルをtableViewCellから取得するための変数
    var selectedTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
        
    }
    
    //MARK: - Tableview Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTitle = itemArray[indexPath.row].title
        
        performSegue(withIdentifier: "goToTab", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TabBarController

        //destinationAudioVC.navigationItem = selectedTitle
        
        if let indexPath = itemTableView.indexPathForSelectedRow {
            destinationVC.selectedItem = itemArray[indexPath.row]
        }
        
    }
    
    //MARK: - Add New Items
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen once the user clicks the Add Item button on our UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            //固有の数字(アイテム追加日時)をロードする際のパスとするため、現在時刻を取得
            let now = NSDate()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            
            let dateStringPath = formatter.string(from: now as Date)
            //現在時刻をnewItemのloadPathに入れる
            newItem.loadPath = dateStringPath
            //紐付けされたnewItemをitemArrayに追加
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Create new item"
            //このクロージャの中でしか使えないaddTextFieldをtextFieldに入れることで他の場所でも使えるようにする。
            textField = addTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        do {
            try context.save()
            print("savecomplete")
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.itemTableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
            print("loadconplete")
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
}


