//
//  CategoryViewController.swift
//  Todoey
//
//  Created by apple on 07/04/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()

    }

    
// MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return categories.count
       }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
         let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
         let category = categories[indexPath.row]
          cell.textLabel?.text = category.name
          return cell
       }
    // MARK: - Table view delegate
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.seletedCategory = categories[indexPath.row]
        }
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
              
              
              let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
              let action = UIAlertAction(title: "Add Category", style: .default) { (action) in

                  let newCategory = Category(context: self.context)
                  newCategory.name = textField.text!
                  self.categories.append(newCategory)
                  self.saveCategory()
              }
              alert.addTextField{ (alertTextField) in
              alertTextField.placeholder = "Create New Category"
              textField = alertTextField
              }
              alert.addAction(action)
              present(alert, animated: true, completion: nil)
    }
    
    func saveCategory() {
           let encoder = PropertyListEncoder()
           
           do {
               try self.context.save()
           } catch {
               print("error")
           }
           self.tableView.reloadData()
       }
       func  loadCategory() {
          let request : NSFetchRequest<Category> = Category.fetchRequest()
           do {
            categories = try context.fetch(request)
           } catch {
               print("error,\(error)")
           }
           self.tableView.reloadData()
       }
       
    
    
}
