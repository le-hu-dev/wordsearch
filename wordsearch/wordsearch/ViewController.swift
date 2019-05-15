//
//  ViewController.swift
//  wordsearch
//
//  Created by Le Hu on 2019-05-13.
//  Copyright © 2019 Le Hu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var line0: [UIButton]!
    
    @IBOutlet var line1: [UIButton]!
    
    @IBOutlet var line2: [UIButton]!
    
    @IBOutlet var line3: [UIButton]!
    
    @IBOutlet var line4: [UIButton]!
    
    @IBOutlet var line5: [UIButton]!
    
    @IBOutlet var line6: [UIButton]!
    
    @IBOutlet var line7: [UIButton]!
    
    @IBOutlet var line8: [UIButton]!
    
    @IBOutlet var line9: [UIButton]!
    
    var matrixBtn = [[UIButton]]()
    
    typealias Point = (Int, Int)
    
    var mapPointToBtn = [UIButton:Point]()
    var data = dataSouce()
    
    var startPoint: UIButton?
    var endPoint: UIButton?
    
    @IBOutlet weak var wrongTimesLabel: UILabel!
    
    @IBOutlet weak var currentfoundWordLabel: UILabel!
    
    @IBOutlet weak var hasFoundWordsLabel: UILabel!
    
    @IBOutlet weak var congrLabel: UILabel!
    var foundWords = 0
    var wrongCounter = 0
    var isPlaying = false
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var counter = 0.0
    var timer = Timer()
    
    @IBAction func startAction(_ sender: UIButton) {
        
        if(isPlaying) {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        isPlaying = true
        startBtn.isEnabled = false
        
    }
    
    @objc func UpdateTimer() {
        counter = counter + 0.1
        timerLabel.text = String(format: "%.1f", counter)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        matrixBtn = [line0,line1,line2,line3,line4,line5,line6,line7,line8,line9]
        // ordered by tag value from 0 -> 99
        for index in 0..<matrixBtn.count {
            matrixBtn[index].sort() {
                $0.tag < $1.tag
            }
        }
        //        let matrixData = data.matrix
        for i in 0..<data.matrix.count {
            for j in 0..<data.matrix[i].count {
                matrixBtn[i][j].setTitle(data.matrix[i][j], for: .normal)
                mapPointToBtn[matrixBtn[i][j]]=(i,j)
            }
        }
        
    }
    
    
    @IBAction func playAgain(_ sender: UIButton) {
        isPlaying = false
        timerLabel.text = "0.0"
        timer.invalidate()
        
        data = dataSouce()
        for i in 0..<data.matrix.count {
            for j in 0..<data.matrix[i].count {
                matrixBtn[i][j].setTitle(data.matrix[i][j], for: .normal)
                matrixBtn[i][j].backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                //mapPointToBtn[matrixBtn[i][j]]=(i,j)
            }
        }
        
        wrongTimesLabel.text = "0"
        currentfoundWordLabel.text = ""
        hasFoundWordsLabel.text = "0"
        congrLabel.text = "good luck"
        startBtn.isEnabled = true
    }
    
    
    @IBAction func tapAction(_ sender: UIButton) {
        
        if(!isPlaying) {
            return
        }
        
        //print(sender.tag)
        if startPoint == nil {
            startPoint = sender
            startPoint?.backgroundColor = .random
            return
        }else if endPoint == nil {
            endPoint = sender
            
            guard startPoint != endPoint else {
                startPoint?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                startPoint = nil
                endPoint = nil
                return
            }
            
            endPoint?.backgroundColor = startPoint?.backgroundColor
            //TODO: check start -> end 's answer is correct?
            if let start=startPoint, let end=endPoint, let color=endPoint?.backgroundColor {
                checkAnswer(start: start, end: end, currentColor: color)
                startPoint = nil
                endPoint = nil
            }
        }
    }
    
    
    func checkAnswer(start startButton:UIButton, end endButton:UIButton, currentColor color:UIColor) -> Void {
        //check answer
        //right or wrong
//        var wrongCounter = 0
        var wordFound:String = ""
        var answerBtns:[(Int,Int)]=[]
        
        let startPoint = mapPointToBtn[startButton]
        let endPoint = mapPointToBtn[endButton]
        
        let absx = abs(startPoint!.0 - endPoint!.0)
        let absy = abs(startPoint!.1 - endPoint!.1)
        
        if  absx == absy { //diagnal / or \
            // 4 direction [1,1], [1,-1], [-1,-1], [-1,1]
            // [1,1]
            switch (startPoint!.0 - endPoint!.0, startPoint!.1 - endPoint!.1) {
            case let (x, y) where x>0 && y>0: // right,bottom => +,+
                //print("")
                var i = startPoint!.0
                var j = startPoint!.1
                
                while i>=endPoint!.0 && j>=endPoint!.1 {
                    wordFound += data.matrix[i][j]
                    answerBtns.append((i,j))
                    i-=1
                    j-=1
                }
                
            case let (x, y) where x<0 && y>0: // left, bottom => -,+
                var i = startPoint!.0
                var j = startPoint!.1
                
                while i<=endPoint!.0 && j>=endPoint!.1 {
                    wordFound += data.matrix[i][j]
                    answerBtns.append((i,j))
                    i+=1
                    j-=1
                }
            case let (x, y) where x>0 && y<0: // right,top => +,-
                //print()
                var i = startPoint!.0
                var j = startPoint!.1
                
                while i>=endPoint!.0 && j<=endPoint!.1 {
                    wordFound += data.matrix[i][j]
                    answerBtns.append((i,j))
                    i-=1
                    j+=1
                }
                
            case let (x, y) where x<0 && y<0: // left, top => -,-
                //print()
                var i = startPoint!.0
                var j = startPoint!.1
                
                while i<=endPoint!.0 && j<=endPoint!.1 {
                    wordFound += data.matrix[i][j]
                    answerBtns.append((i,j))
                    i+=1
                    j+=1
                }
            default :
                print("default : ==> nothing")
            }
            
            print("dignal => \(wordFound)")
            
        }else if startPoint?.0 == endPoint?.0 { // x axis -> or <-
            let diffv = startPoint!.1 - endPoint!.1
            if diffv > 0 { // <--- : from right to left
                //for index in startPoint!.1..>endPoint!.1
                for index in stride(from: startPoint!.1, through: endPoint!.1 , by: -1) {
                    wordFound += data.matrix[startPoint!.0][index]
                    answerBtns.append((startPoint!.0,index))
                }
                
            }else { // ---> from left to right
                for index in stride(from: startPoint!.1, through: endPoint!.1, by: 1) {
                    wordFound += data.matrix[startPoint!.0][index]
                    answerBtns.append((startPoint!.0,index))
                }
            }
        }else if startPoint?.1 == endPoint?.1 { // y axis  up or down
            let diffv = startPoint!.0 - endPoint!.0
            if diffv > 0 { // <--- : from right to left
                //for index in startPoint!.1..>endPoint!.1
                for index in stride(from: startPoint!.0, through: endPoint!.0 , by: -1) {
                    wordFound += data.matrix[index][startPoint!.1]
                    answerBtns.append((index,startPoint!.1))
                }
            }else { // ---> from left to right
                for index in stride(from: startPoint!.0, through: endPoint!.0, by: 1) {
                    wordFound += data.matrix[index][startPoint!.1]
                    answerBtns.append((index,startPoint!.1))
                }
            }
        }else {
            //do nothing
            self.startPoint?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.endPoint?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            print("wrong direction")
            wrongCounter+=1
        }
        // if answer is right , change btn's color
        if data.wordArr.contains(wordFound) {
            answerBtns.forEach(){ item in
                matrixBtn[item.0][item.1].backgroundColor = color
            }
            foundWords+=1
        }else {
            self.startPoint?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.endPoint?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            print("guess wrong word")
            wrongCounter+=1
        }
        
        wrongTimesLabel.text = String(wrongCounter)
        currentfoundWordLabel.text = String(wordFound)
        hasFoundWordsLabel.text = String(foundWords)
        
        if foundWords == 6 {
            congrLabel.text = "👍👍👍👍👍 You found all words!"
            isPlaying = false
            timer.invalidate()
            
        }
    }
    
    
}


extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 0.5)
    }
}
