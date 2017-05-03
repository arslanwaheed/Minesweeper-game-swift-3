//
//  ViewController.swift
//  Minesweeper
//
//  Created by Arslan Waheed on 4/29/17.
//  Copyright © 2017 Arslan Waheed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //😵
    @IBOutlet weak var resetButton: UIButton!       //😃
    @IBOutlet weak var timerLabel: UILabel!         //timer
    @IBOutlet weak var totalBombsLabel: UILabel!
    
    var gameTimer : Timer!
    var time = 0
    
    @IBOutlet var buttons: [UIButton]!              //all buttons
    var board : TilesArray = TilesArray()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        resetButtons()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        self.board.buttonClicked(sender,buttons: self.buttons)
        self.board.isMineClicked(sender, buttons: buttons)

    }
    
    @IBAction func resetClicked(_ sender: UIButton) {
        resetButtons()
    }
    
    
    
    func resetButtons(){
        board = TilesArray()
        totalBombsLabel.text = "Bombs: \(board.totalBombs)"
        for i in 0 ..< buttons.count {
            buttons[i].setTitle("", for: .normal)
            buttons[i].isEnabled = true
            buttons[i].backgroundColor = UIColor.cyan
        }
        time = 0
        timerLabel.text = "Time: \(time)"
        gameTimer.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    //timer controlled function
    func runTimedCode() {
        time += 1
        timerLabel.text = "Time: \(time)"
        
    }

}
