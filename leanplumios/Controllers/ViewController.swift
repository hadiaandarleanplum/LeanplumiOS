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
    
    //define variables again in order to use them
    let lpGameBgImg = Var(name: "gameBgImg", file: "gameBgImg") //Background image var
    let lpGameTitle = Var(name: "gameTitle", string: "Start") // Label of the "Start" button String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //connect variable to elements on project
        Leanplum.onVariablesChanged {
            self.gameTitle.text = self.lpGameTitle.stringValue
            self.gameBgImg.image = self.lpGameBgImg.imageValue()
        }
  
      
    }
    
    @IBAction func winBtnClick(_ sender: Any) {
        //Leanplum.track("gameStatus", info: "Win")
        Leanplum.track("btnClick", params: ["gameStatus": "Win"])
    }
    
    
    @IBAction func loseBtnClick(_ sender: Any) {
        Leanplum.track("btnClick", params: ["gameStatus": "Lose"])
    }
    
    
    @IBAction func resetBtnClick(_ sender: Any) {
        Leanplum.track("Reset")
    }
    
  
    }

    



