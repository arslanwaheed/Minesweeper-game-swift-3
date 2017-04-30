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

    func buttonClicked(_ sender : UIButton){
        
        sender.backgroundColor = UIColor.brown
        //sender.isEnabled = false
        
        let tag = sender.tag
        var row : Int
        let col = tag % 10
        
        switch tag {
        case 0...9 :
            row = 0
            setTitle(sender, row: row, col: col)
            
        case 10...19 :
            row = 1
            setTitle(sender, row: row, col: col)

        case 20...29 :
            row = 2
            setTitle(sender, row: row, col: col)

        case 30...39 :
            row = 3
            setTitle(sender, row: row, col: col)

        case 40...49 :
            row = 4
            setTitle(sender, row: row, col: col)

        case 50...59 :
            row = 5
            setTitle(sender, row: row, col: col)
            
        case 60...69 :
            row = 6
            setTitle(sender, row: row, col: col)
            
        case 70...79 :
            row = 7
            setTitle(sender, row: row, col: col)
            
        case 80...89 :
            row = 8
            setTitle(sender, row: row, col: col)
            
        case 90...99 :
            row = 9
            setTitle(sender, row: row, col: col)
            
        default : break
        }
    }
    
    private func setTitle(_ sender:UIButton, row:Int, col:Int){
        if self.tiles[row][col].isMineLocation {
            sender.setTitle("💣", for: .normal)
        }
        else {
            if self.tiles[row][col].numNeighboringMines == 0 {
                sender.setTitle("", for: .normal)
            }
            else{
                sender.setTitle(String(self.tiles[row][col].numNeighboringMines), for: .normal)
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
