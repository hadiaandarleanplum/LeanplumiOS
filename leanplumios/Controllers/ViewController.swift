//
//  ViewController.swift
//  leanplumios
//
//  Created by hadia.andar on 3/17/22.
//

import UIKit
import Leanplum

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var userButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userTextField?.delegate = self
        userButton?.isUserInteractionEnabled = false
        userButton?.alpha = 0.5 //keep text field gray until user enters name
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string) //text is the textfield string

            //if textfield is filled, let user interact with button. if not, keep it gray
            if !text.isEmpty{
                userButton?.isUserInteractionEnabled = true
                userButton?.alpha = 1.0
            } else {
                userButton?.isUserInteractionEnabled = false
                userButton?.alpha = 0.5
            }
            return true
        }

    //add to cart
    @IBAction func userButtonClick(_ sender: Any) {
        //get name from userTextField
        let userName : String = userTextField.text ?? ""
        print (userName)
    
        //Event: User entered name, show Alert_Name_Entered campaign
        // Leanplum.track("Name_Entered")
        
        Leanplum.track("Add to cart", params:["Product":"Beer"])
        
       
        
        
      
    }
    
    //purchase function
    //Leanplum.track("Purchase")
    

}

