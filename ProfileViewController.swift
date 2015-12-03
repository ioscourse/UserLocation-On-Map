//
//  ProfileViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Diego H. Tobon on 11/30/15.
//  Copyright © 2015 Parse. All rights reserved.
//
import Parse
import UIKit

class ProfileViewController: UIViewController {
          var blnExist:Bool = false
    @IBAction func btnBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBOutlet weak var txtusername: UITextField!
    
    @IBAction func btnSave(sender: AnyObject) {
        un = txtusername.text
        if blnExist == false && un != ""
        {
            user()
            newuser = true
           let testObject = PFObject(className: "MapLocation")
        testObject["fullname"] = un
        testObject["longitude"] = ""
        testObject["latitude"] = ""
        testObject["lastupdate"] = ""
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
             self.user()
             self.dismissViewControllerAnimated(false, completion: nil)
        }
            
        }
        else
        {
            if blnExist == true
            {
                let alertView = UIAlertController(title: "FullName Already Given",
                    message: "Cannot Update FullName, Go Back", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                
            }
            else
            {
                let alertView = UIAlertController(title: "FullName Required",
                    message: "Please Enter Your FullName", preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertView.addAction(OKAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                self.txtusername.becomeFirstResponder()
            }

            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtusername.enabled = true
         self.blnExist = false
        if  un != "" && un != nil {
            self.txtusername.text = un
            let query = PFQuery(className:"MapLocation")
            query.whereKey("fullname", equalTo: txtusername.text!)
            query.findObjectsInBackgroundWithBlock { (object: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if object!.count > 0 {
                        if let object = object! as? [PFObject] {
                            for object in object {
                                self.blnExist = true
                                self.txtusername.text = (object["fullname"] as! String)
                                self.txtusername.enabled = false
                            }
                        }
                    }
                    
                    
                }
            }
        }
        else
        {
            
            self.txtusername.becomeFirstResponder()
        }
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
func user()
{
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setObject(self.txtusername.text, forKey: "fullname")
  
    
    defaults.synchronize()
    }


}
