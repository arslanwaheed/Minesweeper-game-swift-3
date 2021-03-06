//
//  TilesArray.swift
//  Minesweeper
//
//  Created by Arslan Waheed on 4/29/17.
//  Copyright © 2017 Arslan Waheed. All rights reserved.
//

import Foundation
import UIKit

class TilesArray {
    
    let rows = 10
    let cols = 10
    var totalBombs = 0
    var isFlagSelected = false
    
    var tiles:[[Tile]] = [] // a 2d array of tiles , indexed by [row][column]
    
    init() {
        //initialize array
        for row in 0 ..< rows {
            var tilesRow : [Tile] = []
            for col in 0 ..< cols {
                let tile = Tile(row: row,col: col)
                tilesRow.append(tile)
            }
            tiles.append(tilesRow)
        }

        //set mines randomly
        for row in 0 ..< rows {
            for col in 0 ..< cols {
                //1-in-5 chance of getting a mine
                if ((arc4random()%5) == 0 && totalBombs < 20) {
                    setMine(tiles[row][col])
                    totalBombs += 1
                }
            }
        }
    }

    func buttonClicked(_ sender : UIButton, buttons : [UIButton]){
        
        let tag = sender.tag
        let row : Int = Int(tag / 10)
        let col = Int(tag % 10)
        var title = ""
        
        if !isFlagSelected && sender.currentTitle == "🏳️" {
            return
        }
        
        if isFlagSelected {
            if sender.currentTitle == "🏳️" {
                title = ""
                sender.setTitle(title, for: .normal)
                return
            }
            title = "🏳️"
            sender.setTitle(title, for: .normal)
            return
        }

        if self.tiles[row][col].isRevealed == false {

            if self.tiles[row][col].isMineLocation {
                title = "💣"
            }else {
                title = "\(self.tiles[row][col].numNeighboringMines)"
                if title == "0" {
                    title = ""
                }
            }
            sender.backgroundColor = UIColor.brown
            sender.isEnabled = false
            self.tiles[row][col].isRevealed = true
            sender.setTitle(title, for: .normal)
            
            if title == "" {
                sender.backgroundColor = UIColor.brown
                sender.isEnabled = false
                self.tiles[row][col].isRevealed = true
                sender.setTitle(title, for: .normal)
                
                let index = tag
                //var neighbors : [UIButton] = []
                let adjButtons = [-1,-9,-10,-11,1,9,10,11]
                
                for i in adjButtons {
                    if col == 0 && (i == -1 || i == -11 || i == 9) {
                        continue
                    }
                    if col == 9 && (i == 1 || i == 11 || i == -9){
                        continue
                    }
                    
                    if (index + i) < 100 && (index+i) >= 0 {
                        for b in buttons {
                            if b.tag == (index+i) {
                                self.buttonClicked(b, buttons: buttons)
                                break
                            }
                        }
                    }
                }
            }
        }
    }
    
    func flagButtonChecked(_ sender : UIButton){
        if !isFlagSelected {
            isFlagSelected = true
            sender.backgroundColor = UIColor.green
        }else {
            isFlagSelected = false
            sender.backgroundColor = UIColor.red
        }
    }
    
    func isMineClicked(_ sender : UIButton, buttons : [UIButton]) -> Bool{
        let tag = sender.tag
        let row : Int = Int(tag / 10)
        let col = Int(tag % 10)
        let title = "💣"
        
        if self.tiles[row][col].isMineLocation {
            sender.backgroundColor = UIColor.red
            sender.setTitle(title, for: .normal)
            showAllMines(buttons)
            return true
        }
        return false
    }
    
    func showAllMines(_ buttons : [UIButton]){
        let title = "💣"
        for button in buttons {
            button.isEnabled = false
            let tag = button.tag
            let row = tag / 10
            let col = tag % 10
            if self.tiles[row][col].isMineLocation {
                button.setTitle(title, for: .normal)
            }
        }
    }
    

    func getNeighborTiles(_ tile : Tile) -> [Tile] {
        var neighbors : [Tile] = []
        let adjacentBlocks = [(-1,-1),(-1,0),(-1,1),
                              (0,-1),(0,1),             //(0,0) is self tile
                              (1,-1),(1,0),(1,1)]

        for (r,c) in adjacentBlocks {
            let optionalNeighbor: Tile? = self.getTile(row: tile.row + r, col: tile.col + c)
            if let neighbor = optionalNeighbor{
                neighbors.append(neighbor)
            }
            
        }
        return neighbors
    }
    
    func getTile(row : Int, col : Int) -> Tile? {
        if row >= 0 && row < 10 && col >= 0 && col < 10 {
            return tiles[row][col]
        } else {
            return nil
        }
    }
    
    func setMine(_ tile : Tile){
        tile.isMineLocation = true
        
        let neighbors = self.getNeighborTiles(tile)
        
        for n in neighbors {
            n.numNeighboringMines += 1
        }
    }
    
    func isFinished() -> Bool{
        var count = 0
        for row in 0 ..< rows {
            for col in 0 ..< cols {
                if self.tiles[row][col].isRevealed {
                    count += 1
                }
            }
        }
        return (count == 100-self.totalBombs)
    }
}
