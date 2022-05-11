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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
    }
    
    @IBAction func winBtnClick(_ sender: Any) {
        Leanplum.track("Win")
    }
    
    
    @IBAction func loseBtnClick(_ sender: Any) {
        Leanplum.track("Lose")
    }
    
    
    @IBAction func resetBtnClick(_ sender: Any) {
        Leanplum.track("Reset")
    }
    
  
    }

    



