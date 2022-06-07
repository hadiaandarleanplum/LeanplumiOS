//
//  ViewController.swift
//  leanplumios
//
//  Created by hadia.andar on 3/17/22.
//

import UIKit
import Leanplum

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var winBtn: UIButton!
    @IBOutlet weak var loseBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var gameTitle: UILabel! //connect text to leanplum variable
    @IBOutlet weak var gameBgImg: UIImageView!
    
    //define LP variables again in order to use them
    let lpGameBgImg = Var(name: "gameBgImg", file: "gamebgimg.jpeg") //Background image var
    let lpGameTitle = Var(name: "gameTitle", string: "Fun Game") // Label of the "Start" button String
    let lpPowerUp = Var(name: "powerUp", dictionary: [ //Dictionary that u can control values on dashboard
      "lpName": "Turbo Boost",
      "lpPrice": 150,
      "lpSpeed": 1.5,
      "lpTimeout": 15])
    
    //define project's variables
    var name: String = ""
    var price: Int = 0
    var speed: Float = 0
    var timeout: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //connect variable to elements on project
        Leanplum.onVariablesChanged { [self] in
            self.gameTitle.text = self.lpGameTitle.stringValue
            self.gameBgImg.image = self.lpGameBgImg.imageValue()
            
            self.name = (self.lpPowerUp.object(forKey: "lpName") as! NSString) as String
            self.price = (self.lpPowerUp.object(forKey: "lpPrice") as! NSNumber).intValue
            self.speed = (self.lpPowerUp.object(forKey: "lpSpeed") as! NSNumber).floatValue
            self.timeout = (self.lpPowerUp.object(forKey: "lpTimeout") as! NSNumber).intValue
            
        }
        
        print (name,price,speed,timeout)
    }
    
    
    
    @IBAction func winBtnClick(_ sender: Any) {
        //Leanplum.track("gameStatus", info: "Win")
        Leanplum.track("btnClick", params: ["gameStatus": "Win"])
    }
    
    
    @IBAction func loseBtnClick(_ sender: Any) {
        Leanplum.track("btnClick", params: ["gameStatus": "Lose"])
        
        //show a popup to offer the powerup to the user
       
    }
    
    
    @IBAction func resetBtnClick(_ sender: Any) {
        Leanplum.track("Reset")
        
        //maybe do a push notif if they press reset and then put the game on bg or dont play with it for a while
    }
    
  
    }

    



