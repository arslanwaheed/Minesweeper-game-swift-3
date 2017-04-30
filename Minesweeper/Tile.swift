//
//  Tile.swift
//  Minesweeper
//
//  Created by Arslan Waheed on 4/29/17.
//  Copyright © 2017 Arslan Waheed. All rights reserved.
//

import Foundation

class Tile {
    let row:Int
    let col:Int
    
    var numNeighboringMines = 0
    var isMineLocation = false
    var isRevealed = false
    var isFlagged = false
    
    init(row:Int, col:Int) {
        self.row = row
        self.col = col
    }
    
}
