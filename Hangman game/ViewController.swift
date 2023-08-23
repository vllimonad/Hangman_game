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
    var usedChars = Set<Character>()
    
    var wordLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(writeCharacter))
        
        readWords()
        getRandomWord()
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.text = String(questions)
        wordLabel.font = UIFont.systemFont(ofSize: 32)
        wordLabel.textAlignment = .center
        view.addSubview(wordLabel)
        
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 80),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func readWords(){
        if let url = Bundle.main.url(forResource: "start", withExtension: ".txt"){
            if let words = try? String(contentsOf: url) {
                AllWords = words.components(separatedBy: "\n")
            }
        }
    }
    
    func getRandomWord(){
        var word = AllWords.randomElement()
        currentWord = Array(word!)
        print(currentWord)
        for _ in 0..<currentWord.count {
            questions += "?"
        }
    }


    @objc func writeCharacter(){
        let ac = UIAlertController(title: "Write your character", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let action = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] _ in
            if let char = ac?.textFields?[0].text?.lowercased() {
                if char.count == 1 {
                    self?.checkForCharacter(Character(char))
                } else if char.count == self?.currentWord.count {
                    
                }
            }
        }
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    func checkForCharacter(_ char: Character) {
        if currentWord.contains(char){
            for (index, element) in currentWord.enumerated(){
                if element == char {
                    questions[index] = char
                    usedChars.insert(char)
                }
            }
            wordLabel.text = String(questions)
        }
    }
}

