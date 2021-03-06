//
//  ViewController.swift
//  InteractiveStory
//
//  Created by Jon Bachelor on 6/6/16.
//  Copyright © 2016 Jon Bachelor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    enum Error: ErrorType {
        case NoName
    }

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("ViewController.viewDidLoad")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("ViewController.prepareForSegue(segue: \(segue.destinationViewController), sender: \(sender.debugDescription)")
        if segue.identifier == "startAdventure" {
            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw Error.NoName
                    }
                    if let pageController = segue.destinationViewController as? PageController {
                        pageController.page = Adventure.story(name)
                    }
                }
            } catch Error.NoName {
                let alertController = UIAlertController(title: "Name Not Provided", message: "Provide a name to start your story", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(action)
                presentViewController(alertController, animated: true, completion: nil)
            } catch let error {
                fatalError("\(error)")
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("ViewController.keyboardWillShow")
        if let userInfoDict = notification.userInfo, keyboardframeValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardframeValue.CGRectValue()
            UIView.animateWithDuration(0.8) {
                self.textFieldBottomConstraint.constant += keyboardFrame.size.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("ViewController.keyboardWillHide")
        if let userInfoDict = notification.userInfo, keyboardframeValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardframeValue.CGRectValue()
            UIView.animateWithDuration(0.8) {
                self.textFieldBottomConstraint.constant -= (keyboardFrame.size.height)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    // Only necessary for iOS 8 and below. This is automatically handled in iOS 9:
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("ViewController.textFieldShouldReturn(textField: \(textField.text))")
        textField.resignFirstResponder()
        return true
    }


}

