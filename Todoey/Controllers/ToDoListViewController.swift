//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    
    var itemArray = [Item]()
    var seletedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        print("data, \(context)")
        loadItems()
        // Do any additional setup after loading the view.
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.praentCategory = self.seletedCategory
            self.itemArray.append(newItem)
            self.saveItems()
        }
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create New Item"
        textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            try self.context.save()
        } catch {
            print("error")
        }
        self.tableView.reloadData()
    }
    func  loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    //    let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPridecate = NSPredicate(format: "praentCategory.name MATCHES %@", seletedCategory!.name!)
        
        if let additionaPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPridecate, additionaPredicate])
        } else {
            request.predicate = categoryPridecate
        }
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error,\(error)")
        }
        self.tableView.reloadData()
    }
    
    
}

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
   
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request, predicate: predicate)
    
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
}
