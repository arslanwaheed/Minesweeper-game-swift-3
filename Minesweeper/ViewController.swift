//
//  ViewController.swift
//  Minesweeper
//
//  Created by Arslan Waheed on 4/29/17.
//  Copyright © 2017 Arslan Waheed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //labels
    @IBOutlet weak var resetButton: UIButton!       //😵😃😎
    @IBOutlet weak var timerLabel: UILabel!         //timer
    @IBOutlet weak var totalBombsLabel: UILabel!
    @IBOutlet weak var bestTimeLabel: UILabel!
    
    //all buttons and switch mode button
    @IBOutlet var buttons: [UIButton]!              //all buttons
    @IBOutlet weak var switchButton: UIButton!      //switch mode button
    
    //variables needed
    var bTime = UserDefaults().integer(forKey: "BESTTIME")      //persistent time label
    var bestTime = 999
    var time = 0
    
    //create instance of TilesArray which will automatically populate all cells
    var board : TilesArray = TilesArray()
    
    //This is the timer object for running a function intervally
    var gameTimer : Timer!
    
    //Alert to pop-up in case of win or lose
    var myAlert = UIAlertController(title: "OK", message: "Press OK", preferredStyle: UIAlertControllerStyle.alert)
    
    //viewDidLoad function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(bTime == 0){
            UserDefaults.standard.set(999, forKey: "BESTTIME")
        }
        bestTime = bTime
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        resetButtons()
        //myAlert = UIAlertController(title: "You Lose!", message: "Press  😵  to play again", preferredStyle: UIAlertControllerStyle.alert)
        //myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    }

    //this method is called if any cell of game is clicked
    @IBAction func buttonClicked(_ sender: UIButton) {
        let prevTitle = sender.currentTitle
        self.board.buttonClicked(sender,buttons: self.buttons)
        if sender.currentTitle != "🏳️" && prevTitle != "🏳️" {
            let isDead = self.board.isMineClicked(sender, buttons: buttons)
            if isDead {
                resetButton.setTitle("😵", for: .normal)
                gameTimer.invalidate()
                myAlert = UIAlertController(title: "You Lose!", message: "Press  😵  to play again", preferredStyle: UIAlertControllerStyle.alert)
                myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(myAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func resetClicked(_ sender: UIButton) {
        resetButtons()
    }
    
    @IBAction func switchButton(_ sender: UIButton) {
        board.flagButtonChecked(sender)
    }
    
    
    
    //helping functions for view controller
    //reset and timer
    
    func resetButtons(){
        board = TilesArray()
        totalBombsLabel.text = "Bombs: \(board.totalBombs)"
        for i in 0 ..< buttons.count {
            buttons[i].setTitle("", for: .normal)
            buttons[i].isEnabled = true
            buttons[i].backgroundColor = UIColor.darkGray
        }
        time = 0
        timerLabel.text = "Time: \(time)"
        bestTimeLabel.text = "Best Time: \(bestTime)"
        
        resetButton.setTitle("😃", for: .normal)
        gameTimer.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        //set the flag mode off
        board.isFlagSelected = false
        switchButton.backgroundColor = UIColor.red
    }
    
    //timer controlled function
    func runTimedCode() {
        time += 1
        timerLabel.text = "Time: \(time)"
        if board.isFinished() {
            gameTimer.invalidate()
            board.showAllMines(buttons)
            resetButton.setTitle("😎", for: .normal)
            
            //updating persistent variable
            if(time < bestTime){
                bestTime = time
                UserDefaults.standard.set(bestTime, forKey: "BESTTIME")
                bestTimeLabel.text = "Best Time: \(bestTime)"
            }
            myAlert = UIAlertController(title: "Game Won!!\n", message: "\nTime Taken: \(time) seconds\n\nBest Time: \(bestTime) seconds\n\nPress  😎  to play again\n", preferredStyle: UIAlertControllerStyle.alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(myAlert, animated: true, completion: nil)
        }
    }
}
