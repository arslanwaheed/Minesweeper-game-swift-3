//
//  ViewController.swift
//  Minesweeper
//
//  Created by Arslan Waheed on 4/29/17.
//  Copyright © 2017 Arslan Waheed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var resetButton: UIButton!       //😃
    @IBOutlet weak var timerLabel: UILabel!         //timer
    @IBOutlet weak var movesLabel: UILabel!         //moves counter
    
    
    
    @IBOutlet var buttons: [UIButton]!              //all buttons
    var board : TilesArray = TilesArray()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0 ..< buttons.count {
            buttons[i].backgroundColor = UIColor.cyan
            buttons[i].setTitle("", for: .normal)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        board.buttonClicked(sender,buttons: buttons, isRecursive: false)
        
    }
    
    @IBAction func resetClicked(_ sender: UIButton) {
        resetButtons()
    }
    
    
    
    func resetButtons(){
        board = TilesArray()
        for i in 0 ..< buttons.count {
            buttons[i].setTitle("", for: .normal)
            buttons[i].isEnabled = true
            buttons[i].backgroundColor = UIColor.cyan
        }
    }

}
