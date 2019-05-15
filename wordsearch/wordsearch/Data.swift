//
//  Data.swift
//  wordsearch
//
//  Created by mobileapps on 2019-05-09.
//  Copyright © 2019 mobileapps. All rights reserved.
//

import Foundation



enum Direction {
    case north
    case south
    case east
    case west
    case en
    case es
    case ws
    case wn
}


struct dataSouce {
    var wordArr:[String] = ["Swift", "Kotlin", "Objectc", "Variable", "Java", "Mobile"]
    var matrix:[[String]] = Array(repeating: Array(repeating: "0", count: 10), count: 10)
    
    let zero = "0"
    
    init() {
        suffle()
    }
    
    mutating func suffle() -> Void {
        //Todo: random matrix
        var direction = randomDirection()
        var locationRandomX = Int.random(in: 0..<10)
        var locationRandomy = Int.random(in: 0..<10)
        
        wordArr.sort() {
            $0.count > $1.count
        }
        
        var i = 0
        while i<wordArr.count {
            var isSet = false
            var timesOfTried = 0
            while(!isSet) {
                isSet = arrangeWord(location: (locationRandomX,locationRandomy), direction:direction, word:wordArr[i])
                locationRandomX = Int.random(in: 0..<10)
                locationRandomy = Int.random(in: 0..<10)
                direction = randomDirection()
                
                if i == (wordArr.count - 1) && isSet {
                    timesOfTried+=1
                }
                if i == (wordArr.count - 1) && timesOfTried == 25 {
                    //clear matrix, reset it.
                    i = -1
                    timesOfTried = 0
                    resetMatrix()
                    break;
                }
            }
            i+=1
        }
        // fillup rest grid
        
        for i in 0..<matrix.count {
            for j in 0..<matrix[i].count {
                if matrix[i][j] == zero {
                    matrix[i][j] = randomString(length: 1)
                }
            }
        }
        
        
        //todo: test
        //        print( arrangeWord(location: (0,0), direction: .east, word:"java") )// east
        //        print( arrangeWord(location: (0,2), direction: .south, word:"var") )// south
        //        print( arrangeWord(location: (0,2), direction: .west, word:"var") )// weat -> bug1 ->draw line
        //        print( arrangeWord(location: (9,0), direction: .north, word:"mobile") ) //north
        //        print( arrangeWord(location: (9,0), direction: .en, word:"mobile") )
        //        print( arrangeWord(location: (0,3), direction: .es, word:"mobile") )
        //        print( arrangeWord(location: (9,9), direction: .wn, word:"mobile") ) //ws
        //        print( arrangeWord(location: (0,2), direction: .ws, word:"mobile") ) //north
        
        
        //        matrix =
        //            [
        //                ["s", "w", "i", "f", "t", "0", "0", "0", "0", "0"],
        //                ["0", "0", "j", "a", "v", "a", "0", "0", "0", "0"],
        //                ["o", "b", "j", "e", "c", "t", "c", "0", "0", "0"],
        //                ["0", "0", "v", "a", "r", "0", "0", "v", "0", "0"],
        //                ["v", "0", "0", "0", "0", "0", "0", "0", "a", "0"],
        //                ["a", "k", "o", "t", "l", "i", "n", "0", "0", "r"],
        //                ["r", "0", "0", "0", "0", "0", "0", "0", "0", "0"],
        //                ["0", "m", "o", "b", "i", "l", "e", "0", "0", "0"],
        //                ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0"],
        //                ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        //        ]
        
        printMatrix()
        
    }
    
    mutating func resetMatrix() {
        matrix = Array(repeating: Array(repeating: zero, count: 10), count: 10)
    }
    
    mutating func arrangeWord(location: (x:Int,y:Int), direction: Direction, word: String) -> Bool {
        let letters = word.map { String($0) }
        var fillupedGridArr = [(Int,Int)]()
        var isArranged = true
        
        switch direction {
        case .north:
            let distance = location.x - letters.count + 1
            if distance >= 0 {
                for i in 0..<letters.count {
                    if matrix[location.x-i][location.y] == zero || matrix[location.x-i][location.y] == letters[i] {
                        if matrix[location.x-i][location.y] == zero {
                            fillupedGridArr.append((location.x-i,location.y))
                        }
                        matrix[location.x-i][location.y] = letters[i]
                       
                    }else{
                        isArranged = false
                        break
                    }
                }
            } else {
                isArranged = false
            }
            // clear ocupied grid to "0"
            if !isArranged {
                for item in fillupedGridArr {
                    matrix[item.0][item.1] = zero
                }
            }
        case .east:
            //print("east")
            let distance = location.y + letters.count - 1
            //            var fillupedGridArr = [(Int,Int)]()
            if distance <= 9 {
                for i in 0..<letters.count {
                    if matrix[location.x][i+location.y] == "0" || matrix[location.x][i+location.y] == letters[i] {
                        if matrix[location.x][i+location.y] == zero {
                            fillupedGridArr.append((location.x,i+location.y))
                        }
                        matrix[location.x][i+location.y] = letters[i]
                        
                    }else{
                        isArranged = false
                        break
                    }
                }
            }else {
                isArranged = false
            }
            // clear ocupied grid to "0"
            if !isArranged {
                for item in fillupedGridArr {
                    matrix[item.0][item.1] = zero
                }
            }
            
        case .south:
            let tmp = location.x + letters.count - 1
            
            if tmp <= 9 {
                for i in 0..<letters.count {
                    if matrix[location.x+i][location.y] == "0" || matrix[location.x+i][location.y] == letters[i] {
                        if matrix[location.x+i][location.y] == zero {
                            fillupedGridArr.append((location.x+i,location.y))
                        }
                        matrix[location.x+i][location.y] = letters[i]
                        
                    }else{
                        isArranged = false
                        break
                    }
                }
            }else {
                isArranged = false
            }
            // clear ocupied grid to "0"
            if !isArranged {
                for item in fillupedGridArr {
                    matrix[item.0][item.1] = zero
                }
            }
        case .west:
            let tmp = location.y - letters.count + 1
            
            if tmp >= 0 {
                for i in 0..<letters.count {
                    if matrix[location.x][location.y-i] == "0" || matrix[location.x][location.y-i] == letters[i] {
                        if matrix[location.x][location.y-i] == zero {
                            fillupedGridArr.append((location.x,location.y-i))
                        }
                        matrix[location.x][location.y-i] = letters[i]
                        
                    }else{
                        isArranged = false
                        break
                    }
                }
            }else {
                isArranged = false
            }
            // clear ocupied grid to "0"
            if !isArranged {
                for item in fillupedGridArr {
                    matrix[item.0][item.1] = zero
                }
            }
        case .en:
            let distanceX = location.y + letters.count - 1
            let distanceY = location.x - letters.count + 1
            
            if distanceX <= 9 && distanceY >= 0 {
                for i in 0..<letters.count {
                    if matrix[location.x-i][location.y+i] == "0" || matrix[location.x-i][location.y+i] == letters[i] {
                        if matrix[location.x-i][location.y+i] == zero {
                            fillupedGridArr.append((location.x-i,location.y+i))
                        }
                        matrix[location.x-i][location.y+i] = letters[i]
                        
                    }else{
                        isArranged = false
                        break
                    }
                }
            }else {
                isArranged = false
            }
            // clear ocupied grid to "0"
            if !isArranged {
                for item in fillupedGridArr {
                    matrix[item.0][item.1] = zero
                }
            }
            
        case .es:
            let distanceX = location.y + letters.count - 1
            let distanceY = location.x + letters.count - 1
            
            if distanceX <= 9 && distanceY <= 9 {
                for i in 0..<letters.count {
                    if matrix[location.x+i][location.y+i] == "0" || matrix[location.x+i][location.y+i] == letters[i] {
                        if matrix[location.x+i][location.y+i] == zero {
                            fillupedGridArr.append((location.x+i,location.y+i))
                        }
                        matrix[location.x+i][location.y+i] = letters[i]
                        
                    }else{
                        isArranged = false
                        break
                    }
                }
            }else {
                isArranged = false
            }
            // clear ocupied grid to "0"
            if !isArranged {
                for item in fillupedGridArr {
                    matrix[item.0][item.1] = zero
                }
            }
        case .ws:
            let distanceX = location.y - letters.count + 1
            let distanceY = location.x + letters.count - 1
            
            if distanceX >= 0 && distanceY <= 9 {
                for i in 0..<letters.count {
                    if matrix[location.x+i][location.y-i] == "0" || matrix[location.x+i][location.y-i] == letters[i] {
                        if matrix[location.x+i][location.y-i] == zero {
                            fillupedGridArr.append((location.x+i,location.y-i))
                        }
                        matrix[location.x+i][location.y-i] = letters[i]
                        
                    }else{
                        isArranged = false
                        break
                    }
                }
            }else {
                isArranged = false
            }
            // clear ocupied grid to "0"
            if !isArranged {
                for item in fillupedGridArr {
                    matrix[item.0][item.1] = zero
                }
            }
        case .wn:
            let distanceX = location.y - letters.count + 1
            let distanceY = location.x - letters.count + 1
            if distanceX >= 0 && distanceY >= 0 {
                for i in 0..<letters.count {
                    if matrix[location.x-i][location.y-i] == "0" || matrix[location.x-i][location.y-i] == letters[i] {
                        if matrix[location.x-i][location.y-i] == zero {
                            fillupedGridArr.append((location.x-i,location.y-i))
                        }
                        matrix[location.x-i][location.y-i] = letters[i]
                        
                    }else{
                        isArranged = false
                        break
                    }
                }
            } else {
                isArranged = false
            }
            // clear ocupied grid to "0"
            if !isArranged {
                for item in fillupedGridArr {
                    matrix[item.0][item.1] = zero
                }
            }
        }
        return isArranged
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func printMatrix() {
        for line in matrix {
            print(line,terminator:"\n")
        }
    }
    
    func randomDirection() -> Direction {
        let randomNumber = Int.random(in: 1..<9)
        
        switch randomNumber {
        case 1:
            return Direction.east
        case 2:
            return Direction.south
        case 3:
            return Direction.west
        case 4:
            return  Direction.north
        case 5:
            return  Direction.en
        case 6:
            return Direction.es
        case 7:
            return  Direction.ws
        default:
            return  Direction.wn
        }
    }
    
}
