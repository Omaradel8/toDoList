//
//  ViewController.swift
//  toDoList
//
//  Created by z510 on 11/1/19.
//  Copyright © 2019 z510. All rights reserved.
//

import UIKit
import CoreData

class toDo: UITableViewController {
    
    var dolist = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category?{
        didSet{
            loaditems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dolist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "doCell")
        let item = dolist[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell . accessoryType = item.checked ?  .checkmark :  .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        dolist[indexPath.row].checked = !dolist[indexPath.row].checked
        
        saveData()
    }

    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new to Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            let item = Item(context: self.context)
            item.title = textfield.text!
            item.checked = false
            item.parentCategory = self.selectedCategory
            self.dolist.append(item)
            
            self.saveData()
            
        }
        
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Enter New Item"
            textfield = alerttextfield
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print("error in saving data\(error)")
        }
        tableView.reloadData()
    }
    
    

    func loaditems(with request: NSFetchRequest<Item> = Item.fetchRequest() ,predicate : NSPredicate? = nil){

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate {request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , addtionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            dolist = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
}


extension toDo: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loaditems(with: request, predicate: predicate
        )
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loaditems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

