//
//  ViewController.swift
//  toDoList
//
//  Created by z510 on 11/1/19.
//  Copyright © 2019 z510. All rights reserved.
//

import UIKit

class toDo: UITableViewController {
    
    var dolist = [Item]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let item1 = Item()
        item1.title = "a"
        dolist.append(item1)
        
        let item2 = Item()
        item2.title = "b"
        dolist.append(item2)
        
        if let items = defaults.array(forKey: "dolist") as? [Item]{
            return dolist = items
        }
        
        
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
        
        
        tableView.reloadData()
    }

    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new to Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let item = Item()
            item.title = textfield.text!
            self.dolist.append(item)
            self.defaults.set(self.dolist, forKey: "dolist")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Enter New Item"
            textfield = alerttextfield
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    

}

