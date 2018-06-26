//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Place your instance variables here
    
    let allQuestions = QBank()
    var pickedAnswer :Bool = false
    var currQuestion: Int = 0;
    var score : Int = 0;
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }


    @IBAction func answerPressed(_ sender: AnyObject) {
        if(sender.tag == 1){
            pickedAnswer = true;
        }else if (sender.tag == 2){
            pickedAnswer = false;
        }
        checkAnswer();
        currQuestion = currQuestion + 1
        nextQuestion();
    }
    
    
    func updateUI() {
        updateScore()
        displayQuestion()
        progressBar.frame.size.width = (view.frame.size.width / 13) * CGFloat(currQuestion+1);
    }
    

    func nextQuestion() {
        if(currQuestion < 13){
            updateUI();
        } else {
            startOver();
        }
    }
    
    
    func checkAnswer() {
        if(pickedAnswer == allQuestions.list[currQuestion].answer){
            ProgressHUD.showSuccess("You're a Champ!!!")
            score = 1 + score
        } else {
            ProgressHUD.showError("You got it Wrong!!! You Dense @$$");
        }
    }
    
    
    func startOver() {
        currQuestion=0
        let endOfQuiz = UIAlertController(title: "Finished", message: "You Have Scored \(score)", preferredStyle:.alert)
        let quitAction = UIAlertAction(title: "Quit", style: .cancel, handler:{(UIAlertAction) in self.leaveApp()})
        let redo = UIAlertAction(title: "Re Take", style: .default, handler:{(UIAlertAction) in self.updateUI()})
        
        endOfQuiz.addAction(quitAction)
        endOfQuiz.addAction(redo)
        present(endOfQuiz, animated : true, completion: nil)
        progressLabel.text = "\(currQuestion+1)/13"
    }
    
    func leaveApp() {
        exit(0);
    }
    func displayQuestion(){
        let question = allQuestions.list[currQuestion];
        questionLabel.text = question.question
    }
    func updateScore()  {
        scoreLabel.text = "Score : \(score)"
        progressLabel.text = "\(currQuestion+1)/13"
    }
    
}
