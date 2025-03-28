//
//  LoginViewController.swift
//  leanplumios
//
//  Created by Hadia Andar on 5/9/22.
//

import UIKit
import Leanplum

class LoginViewController: UIViewController, UITextFieldDelegate {

    //IB Outlets
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var nameButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Leanplum.setUserId("hadiaAugust12")
        usernameTextField?.delegate = self
        loginButton?.isUserInteractionEnabled = false
        loginButton?.alpha = 0.5 //keep text field gray until user enters name
        
     
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string) //text is the textfield string

            //if textfield is filled, let user interact with button. if not, keep it gray
            if !text.isEmpty{
                loginButton?.isUserInteractionEnabled = true
                loginButton?.alpha = 1.0
             
            } else {
                loginButton?.isUserInteractionEnabled = false
                loginButton?.alpha = 0.5
         
            }
            return true
        }


    //set player name attribute
    @IBAction func nameButtonClick(_ sender: UIButton) {
        let playerName: String = playerNameTextField.text ?? ""
        Leanplum.setUserAttributes(["playerName": playerName])
        print (playerName)
        
        Leanplum.forceContentUpdate()
    }
    
    
    //send userID if user clicks on the login button
    @IBAction func loginButtonClick(_ sender: UIButton) {
        //get userID from userTextField
        let userID : String = usernameTextField.text ?? ""
        Leanplum.setUserId(userID)
        print (userID)
        
        Leanplum.forceContentUpdate()
        
        //segue to next main view controller
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
