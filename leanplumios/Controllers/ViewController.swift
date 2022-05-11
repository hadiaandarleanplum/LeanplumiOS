//
//  ViewController.swift
//  leanplumios
//
//  Created by hadia.andar on 3/17/22.
//

import UIKit
import Leanplum

class ViewController: UIViewController, UITextFieldDelegate {

    enum Turn { //defines common type for a group of related variables
        case Nought
        case Cross
    }
    
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    var firstTurn = Turn.Cross //keep track of who's turn it is to go first in each game. will flip flog every a game ends
    var currentTurn = Turn.Cross //current turn. will flip flop each time a tile is placed
    
    var NOUGHT = "O"
    var CROSS = "X"
    var board = [UIButton]() //array of buttons
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initBoard()
    }
    
    func initBoard(){
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    

    @IBAction func boardTapAction(_ sender: UIButton) {
        addToBoard(sender)
        
        if (fullBoard()){
            resultAlert(title: "Draw")
        }
    }
    
    func resultAlert(title: String){
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: {(_) in self.resetBoard()}))
    }
    
    func resetBoard(){
        for button in board{
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if (firstTurn == Turn.Nought){ //if the first turn was nought, then change it to cross with resetting board
            firstTurn = Turn.Cross
            turnLabel.text = CROSS
        }
        else if (firstTurn == Turn.Cross){ //if the first turn was nought, then change it to cross with resetting board
            firstTurn = Turn.Nought
            turnLabel.text = NOUGHT
        }
        currentTurn = firstTurn
        
    }
    
    func fullBoard() -> Bool {
        for button in board {
            if button.title(for: .normal) == nil{ //found an empty space
                return false
            }
        }
        return true
    }
    
    func addToBoard(_ sender: UIButton) {
        if(sender.title(for: .normal) == nil) { //if there's nothing in the button title
            if(currentTurn == Turn.Nought){
                sender.setTitle(NOUGHT, for: .normal) //set text to be O
                currentTurn = Turn.Cross
                turnLabel.text = CROSS
            }
            else if(currentTurn == Turn.Nought){
                sender.setTitle(CROSS, for: .normal) //set text to be X
                currentTurn = Turn.Nought
                turnLabel.text = NOUGHT
            }
            sender.isEnabled = false //remove animation when you click a button that already has a Nought or Cross placed
            
        }
    }
        
        
      
    }

    



