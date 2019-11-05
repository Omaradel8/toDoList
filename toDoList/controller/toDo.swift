//
//  ViewController.swift
//  toDoList
//
//  Created by z510 on 11/1/19.
//  Copyright © 2019 z510. All rights reserved.
//

import UIKit
import RealmSwift

class toDo: UITableViewController {
    
    let realm = try! Realm()
    var dolist: Results<Item>?

    var selectedCategory : Category?{
        didSet{
            loaditems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dolist?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "doCell")
        if let item = dolist?[indexPath.row]{
        cell.textLabel?.text = item.title
        
            cell . accessoryType = item.checked ?  .checkmark :  .none
        }else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = dolist?[indexPath.row]{
            do{
                try realm.write {
                    item.checked = !item.checked
                }
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
    }

    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new to Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                try self.realm.write {
                    let item = Item()
                    item.title = textfield.text!
                    item.dateCreated = Date()
            currentCategory.items.append(item)
                    }}catch{
                        print(error)
                }
            
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Enter New Item"
            textfield = alerttextfield
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    

    
    

    func loaditems(){
        dolist = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
}


extension toDo: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        dolist = dolist?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

