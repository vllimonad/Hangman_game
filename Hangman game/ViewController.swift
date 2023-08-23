//
//  ViewController.swift
//  Hangman game
//
//  Created by Vlad Klunduk on 23/08/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var AllWords = [String]()
    var currentWord = [Character]()
    var questions = [Character]()
    var attempt = 0
    
    var wordLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(writeCharacter))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.font = UIFont.systemFont(ofSize: 32)
        wordLabel.textAlignment = .center
        view.addSubview(wordLabel)
        
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 80),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        readWords()
    }
    
    @objc func restartGame(){
        attempt = 0
        questions = []
        getRandomWord()
    }
    
    func readWords(){
        if let url = Bundle.main.url(forResource: "start", withExtension: ".txt"){
            if let words = try? String(contentsOf: url) {
                AllWords = words.components(separatedBy: "\n")
            }
        }
        getRandomWord()
    }
    
    func getRandomWord(){
        var word = AllWords.randomElement()
        currentWord = Array(word!)
        for _ in 0..<currentWord.count {
            questions += "?"
        }
        wordLabel.text = String(questions)
    }

    @objc func writeCharacter(){
        let ac = UIAlertController(title: "Write your character or full word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let action = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] _ in
            
            if let text = ac?.textFields?[0].text?.lowercased() {
                self?.checkCorrectnessOfWord()
                switch(text.count) {
                case 1:
                    self?.checkForCharacter(Character(text))
                case self?.currentWord.count:
                    self?.checkForFullWord(text)
                default:
                    self?.showMessageAlert("Incorrect input", "You can input one character or full word. \n You have \(7 - self!.attempt) attempt(s) left")
                }
            }
        }
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    func checkCorrectnessOfWord() {
        attempt += 1
        if attempt >= 7{
            if questions == currentWord {
                showMessageAlert("Congratulations!", "It is correct word")
            } else {
                showMessageAlert("Try again!", "You don't have more attempts for this word")
            }
        }
    }
    
    func checkForCharacter(_ char: Character) {
        if currentWord.contains(char){
            for (index, element) in currentWord.enumerated(){
                if element == char {
                    questions[index] = char
                }
            }
            wordLabel.text = String(questions)
            showMessageAlert("Congratulations!", "It is correct word")
            return
        }
        
        showMessageAlert("Incorrect character", "This word doesn't contain '\(char)'. \n You have \(7 - attempt) attempt(s) left")
    }
    
    func checkForFullWord(_ word: String) {
        var candidate = Array<Character>(word)
        for i in 0..<currentWord.count {
            if candidate[i] != currentWord[i] {
                showMessageAlert("Incorrect input", "You can input one character or full word. \n You have \(7 - attempt) attempt(s) left")
                return
            }
        }

        showMessageAlert("Congratulations!", "It is correct word")
    }
    
    func showMessageAlert(_ title: String, _ message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

