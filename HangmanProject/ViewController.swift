//
//  ViewController.swift
//  HangmanProject
//
//  Created by Pallavi on 23/06/21.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var letterBankLabel: UILabel!
    @IBOutlet weak var inputxtx: UITextField!
    @IBOutlet weak var ReamingGuessLable: UILabel!
    @IBOutlet weak var wordGuessLabel: UILabel!
    @IBOutlet weak var HintLabel: UILabel!
    @IBOutlet weak var NewWordTouchUp: UIButton!
    @IBOutlet weak var buttonNewWord: UIButton!
    
  
    let List_of_Word:[String] = ["hello","goodbye","postive","coffee","hangman"]
    let List_of_Hints:[String] = ["welocme","farewell","think postive","morning freshness","word think game"]
    var wordtoGuess:String!
    var hint :String!
    var wordAsUnderScope :String = ""
    var MaxNumberOfGucess:Int = 5
    var reamingGucess:Int!
    var oldRandomNumber:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        inputxtx.delegate = self
        inputxtx.becomeFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedChater = NSCharacterSet.letters
        let startinglenth = textField.text?.count ?? 0
        let lenthtoadd = string.count
        let lengthtoReplace = range.length
        let newLenght = startinglenth + lenthtoadd - lengthtoReplace
        if string.isEmpty{
            return true

        }
        else if newLenght == 1 {
            if let _ = string.rangeOfCharacter(from: allowedChater, options: .caseInsensitive){
                return true
            }
        }
        return false
    }
    @IBAction func newWordTouchUp(_ sender: Any) {
        inputxtx.isEnabled = true

        let index = chooseRandomNumber()
        wordtoGuess = List_of_Word[index]
        //wordGuessLabel.text = wordtoGuess
        
        hint = List_of_Hints[index]
        HintLabel.text = "Hint: \(hint ?? ""),  \(wordtoGuess.count) letter"
        
        for _ in 1...wordtoGuess.count {
            wordAsUnderScope.append("_")
        }
        wordGuessLabel.text = wordAsUnderScope
       
    }
    func chooseRandomNumber() -> Int{
        reset()
        var NewrandomNumber : Int = Int (arc4random_uniform(UInt32(List_of_Word.count)))

        if NewrandomNumber == oldRandomNumber{
            NewrandomNumber = chooseRandomNumber()
        }else{
            oldRandomNumber = NewrandomNumber
        }
        return NewrandomNumber
        
    }
    func reset(){
        inputxtx.text?.removeAll()
        reamingGucess = MaxNumberOfGucess
        ReamingGuessLable.text = "\(reamingGucess!) Gucess left."
        wordAsUnderScope = ""
        letterBankLabel.text?.removeAll()
        inputxtx.isEnabled = true

    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let lettertoGucess = textField.text else {return}
        inputxtx.text?.removeAll()
        let currentLetterBank :String = letterBankLabel.text ?? ""
        if currentLetterBank.contains(lettertoGucess) {
            return
        }else{
        if wordtoGuess.contains(lettertoGucess){
            processCorrectGuess(letter: lettertoGucess)
        }else{
            processIncorrectGucess()
        }
            letterBankLabel.text?.append("\(lettertoGucess), ")
        }
        
         
    }
    func processCorrectGuess(letter:String){
        
       let chaterGucessed = Character(letter)
        
        for index in wordtoGuess.indices {
            if wordtoGuess[index] == chaterGucessed{
                let endIndex = wordtoGuess.index(after: index)
                let chaterRange = index ..< endIndex
                wordAsUnderScope = wordAsUnderScope.replacingCharacters(in: chaterRange, with: letter)
                wordGuessLabel.text = wordAsUnderScope
            }
        }
        if !(wordAsUnderScope.contains("_")){
            ReamingGuessLable.text = "You win! :)"
            inputxtx.isEnabled = false
        }
        
        
        
        
    }
    func processIncorrectGucess(){
        
        reamingGucess! -= 1
        if reamingGucess == 0 {
            ReamingGuessLable.text = "You loose! :("
            inputxtx.isEnabled = false
        }else{
            ReamingGuessLable.text = "\(reamingGucess!) gucess left"
            
        }
        
    }

}

