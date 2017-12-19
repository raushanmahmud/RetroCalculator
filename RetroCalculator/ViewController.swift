//
//  ViewController.swift
//  RetroCalculator
//
//  Created by studentas on 18/12/2017.
//  Copyright © 2017 studentas. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var btnSound : AVAudioPlayer!
    
    @IBOutlet weak var outputLbl: UILabel!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation: Operation!
    
    var runningNumber: String!
    
    var leftValStr: String!
    
    var rightValStr: String!
    
    var result: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        clear()
        
    }
    
    @IBAction func numberPressed(sender: UIButton){
        playSound()
        
        if runningNumber == "0" {
            runningNumber = ""
        }
        runningNumber! += "\(sender.tag)"
        outputLbl.text = runningNumber
        
    }
    
    @IBAction func onDividePressed(sender: AnyObject){
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject){
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject){
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject){
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject){
        processOperation(operation: currentOperation)
        
    }
    
    @IBAction func clearPressed(sender: AnyObject){
        playSound()
        clear()
    }
    
    func playSound(){
        if btnSound.isPlaying{
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func clear(){
        currentOperation = Operation.Empty
        runningNumber = "0"
        leftValStr = ""
        rightValStr = ""
        result = ""
        outputLbl.text = "0"
    }
    
    func processOperation(operation: Operation){
        playSound()
        if currentOperation != Operation.Empty {
            
            // A user selected an operator, but then selected another operator without first entering a number
            if runningNumber != "" {
                
                rightValStr = runningNumber
                runningNumber = "0"
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    
                    let divider = Double(rightValStr)!
                    if divider != 0 {
                        result = "\(Double(leftValStr)! / divider)"
                    } else {
                        result = leftValStr
                    }
        
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }
            
            currentOperation = operation
            
        } else {
            // This is the first time operator has been pressed
            leftValStr = runningNumber
            runningNumber = "0"
            currentOperation = operation
        }
    }
}
