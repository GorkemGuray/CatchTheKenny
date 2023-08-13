//
//  ViewController.swift
//  CatchTheKenny
//
//  Created by Görkem Güray on 13.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var yMin:Float = 0
    var yMax:Float = 0
    var xMin:Float = 0
    var xMax:Float = 0
    var kennyWidth:Float = 0
    var kennyHeight:Float = 0.0
    
    var score:Int = 0
    var highestScore:Int = 0
    
    var timer = Timer()
    var timer2 = Timer()
    var countDown = 10
    
    @IBOutlet weak var remainTime: UILabel!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var highScore: UILabel!
    
    @IBOutlet weak var kenny: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //kenny'nin hareket alanı belirleniyor:
        yMin = Float(currentScore.frame.maxY)
        yMax = Float(highScore.frame.minY)
        xMin = 0
        xMax = Float(view.frame.maxX)
        
        //kenny'nin ölçüleri bulunuyor.
        kennyWidth = Float(kenny.frame.width)
        kennyHeight = Float(kenny.frame.height)
    
        kenny.frame = rastgeleKonumKenny()
        
        //kenny gesture tanımlaması
        kenny.isUserInteractionEnabled = true
        let gestureReco = UITapGestureRecognizer(target: self, action: #selector(kennyYakalandi))
        kenny.addGestureRecognizer(gestureReco)
        
        score = 0
        currentScore.text = "Score : \(score)"
        
        highestScore = UserDefaults.standard.integer(forKey: "highscore")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        remainTime.text = "\(countDown)"
        highScore.text = "Highscore : \(highestScore)"
        
        startTheGame()
    }
    
    
    
    func rastgeleKonumKenny() -> CGRect {
        
        let xKonum = CGFloat(Float.random(in: xMin...(xMax-kennyWidth)))
        let yKonum = CGFloat(Float.random(in: yMin...(yMax-kennyHeight)))
        let wKonum = CGFloat(kennyWidth)
        let hKonum = CGFloat(kennyHeight)
        
        let frame = CGRect(x: xKonum, y: yKonum, width: wKonum, height: hKonum)
        return frame
    }
    
    @objc func kennyYakalandi() {
        
        if timer.isValid {
            score += 1
            currentScore.text = "Score : \(score)"
        }
        
        
    }
    
    @objc func timerTrigged() {
        kenny.frame = rastgeleKonumKenny()
        
        
    }
    
    @objc func timerCountdown() {
        countDown -= 1
        remainTime.text = "\(countDown)"
        
        var alertTitle = "Time's Up"
        var alertMessage = "Your Score : \(score)"
        
        if countDown <= 0 {
            timer2.invalidate()
            timer.invalidate()
            playButton.isHidden = false
            
            if score > highestScore {
                highestScore = score
                UserDefaults.standard.set(highestScore, forKey: "highscore")
                highScore.text = "Highscore : \(highestScore)"
                
                alertTitle = "High Score!!!"
                alertMessage = "Weldone! Best score ever. Score : \(score)"
                
            }
            
            
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            let newGame = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { (UIAlertAction) in
                self.startTheGame()
                
            }
            alert.addAction(okButton)
            alert.addAction(newGame)
            self.present(alert, animated: true)
        }
        
    }
    
    
    func startTheGame() {
        playButton.isHidden = true
        score = 0
        countDown = 10
        remainTime.text = "\(countDown)"
        currentScore.text = "Score : \(score)"
        kenny.frame = rastgeleKonumKenny()
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(timerTrigged), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCountdown), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func highScoreDeleteButton(_ sender: UIButton) {
        
        highestScore = 0
        
        UserDefaults.standard.removeObject(forKey: "highscore")
        highScore.text = "Highscore : \(highestScore)"
        
    }
    
    @IBAction func PlayButtonClicked(_ sender: UIButton) {
        startTheGame()
        
    }
}
