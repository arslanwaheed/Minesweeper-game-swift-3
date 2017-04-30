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
                //1-in-6 chance of getting a mine
                if ((arc4random()%6) == 0) {
                    setMine(tiles[row][col])
                    totalBombs += 1
                }
            }
        }
        print(totalBombs)
    }

    func buttonClicked(_ sender : UIButton, buttons : [UIButton], isRecursive : Bool){
        
        let tag = sender.tag
        let row : Int = tag / 10
        let col = tag % 10
        var title = ""
        
        print(tag)

        if self.tiles[row][col].isRevealed == false {

            if self.tiles[row][col].isMineLocation {
                title = "💣"
            }else {
                title = "\(self.tiles[row][col].numNeighboringMines)"
            }
            
            if !isRecursive {
                sender.backgroundColor = UIColor.brown
                sender.isEnabled = false
                self.tiles[row][col].isRevealed = true
                sender.setTitle(title, for: .normal)
            }
            
            
            if title == "0" {
                sender.backgroundColor = UIColor.brown
                sender.isEnabled = false
                self.tiles[row][col].isRevealed = true
                sender.setTitle(title, for: .normal)
                
                let index = tag
                //var neighbors : [UIButton] = []
                let adjButtons = [-1,-10,1,10]
                
                for i in adjButtons {
                    if col == 0 && i == -1 {
                        continue
                    }
                    if col == 9 && i == 1{
                        continue
                    }
                    
                    if (index + i) < 100 && (index+i) >= 0 {
                        print("Tag: \(tag), \(index+i)")
                        for b in buttons {
                            if b.tag == (index+i) {
                                self.buttonClicked(b, buttons: buttons, isRecursive: true)
                                break
                            }
                        }
                        //self.buttonClicked(buttons[index+i] , buttons: buttons, isRecursive: true)
                    }
                }
                
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
}
