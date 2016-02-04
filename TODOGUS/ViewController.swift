//
//  ViewController.swift
//  TODOGUS
//
//  Created by Agus Cahyono on 2/4/16.
//  Copyright © 2016 Agus Cahyono. All rights reserved.
//

import UIKit
import Realm


class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    var data = realm.objects(Dataku).sorted("createdAt", ascending: false)
    var isEditingMode = false
    
    
    @IBOutlet weak var txName: UITextField!
    @IBOutlet weak var txEmail: UITextField!
    @IBOutlet weak var txAge: UITextField!
    @IBOutlet weak var txId: UITextField!
    
    
    @IBOutlet weak var btnAction: UIButton!
    
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    /**
     ViewDidload
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txId.enabled = false
        txId.hidden = true
        
        if isEditingMode == isEditingMode {
            self.btnAction.setTitle("Save", forState: .Normal)
            btnCancel.enabled = false
        }
        else {
            self.btnAction.setTitle("Update", forState: .Normal)
            btnCancel.enabled = true
        }
        
    }
    
    /**
     ViewWill Appear
     
     - parameter animated: true
     */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tblView.reloadData()
        print(data)
    }

    
    /**
     Save Button Action
     
     - parameter sender: UIButton
     */
    @IBAction func simpanAction(sender: AnyObject) {
        
        if self.txName.text == "" || self.txEmail.text == "" {
            
            let refreshAlert = UIAlertView()
            refreshAlert.title = "Please fill all fields"
            refreshAlert.message = "Please input name and email before saving your data"
            refreshAlert.addButtonWithTitle("OK")
            refreshAlert.show()
            
        }
        
        if isEditingMode == false {
            
            if self.txName.text?.characters.count > 0 {
                
                let datakuItem = Dataku()
                
                datakuItem.id = datakuItem.IncrementID()
                datakuItem.name = self.txName.text!
                datakuItem.email = self.txEmail.text!
                datakuItem.age = Int(self.txAge.text!)!
                datakuItem.createdAt = NSDate()
                
                try! realm.write {
                    realm.add(datakuItem)
                }
                
                self.txName.text = ""
                self.txEmail.text = ""
                self.txAge.text = ""
                
            }
            isEditingMode = false
        }
        else {
            
            let theData = realm.objects(Dataku).filter("id == \(self.txId.text!) ").first
            
            try! realm.write {
                theData!.name = self.txName.text!
                theData!.email = self.txEmail.text!
                theData!.age = Int(self.txAge.text!)!
            }
            isEditingMode = false
        }
        clearAllForm()
        self.tblView.reloadData()
    }
    
    /**
     Count rows cell
     
     - parameter tableView: number rows in section
     - parameter section:   section table
     
     - returns: count data
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    /**
     Sett cell for row index
     
     - parameter tableView: cell rows index
     - parameter indexPath: indexpath rows
     
     - returns: cell
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DatakuCell
        
        let dataku = self.data[indexPath.row]
        
        cell.txNama.text = dataku.name
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
    }
    
    /**
     Edit action on swipe tablecell
     
     - parameter tableView: swipe edit action
     - parameter indexPath: indexPath rows
     
     - returns: return button action
     */
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        /// Delete action
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            // Deleting action will go here
            
            let alert = UIAlertController(title: "Confirmation Action", message: "Are you sure want to delete this data ?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    let dataDelete = self.data[indexPath.row]
                    try! realm.write {
                        realm.delete(dataDelete)
                    }
                    self.tblView.reloadData()
                case .Cancel:
                    print("cancel")
                case .Destructive:
                    print("destructive")
                }
            }))
            
        }
        
        /// Edit Action
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            self.isEditingMode = true
            
            self.txId.text = String(self.data[indexPath.row].id)
            self.txName.text = self.data[indexPath.row].name
            self.txEmail.text = self.data[indexPath.row].email
            self.txAge.text = String(self.data[indexPath.row].age)
            self.btnAction.setTitle("Update", forState: .Normal)
            self.btnCancel.enabled = true
            
        }
        
        return [deleteAction, editAction]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = self.data[indexPath.row]
        print(data)
    }
    
    /**
     Clear form data and back to save mode
     */
    func clearAllForm() {
        
        self.txId.text = ""
        self.txName.text = ""
        self.txEmail.text = ""
        self.txAge.text = ""
        self.btnAction.setTitle("Save", forState: .Normal)
        self.btnCancel.enabled = false
    }
    
    
    
    //MARK: Button action
    
    /**
    Button edit data
    
    - parameter sender: UIButton
    */
    @IBAction func editDataAction(sender: AnyObject) {
        isEditingMode = !isEditingMode
        self.tblView.setEditing(isEditingMode, animated: true)
    }
    
    
    /**
     Button Cancel when editing
     
     - parameter sender: UIButton
     */
    @IBAction func clearAllForm(sender: AnyObject) {
        clearAllForm()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

