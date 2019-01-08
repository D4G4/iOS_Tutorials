//
//  ViewController.swift
//  BullsEye
//
//  Created by Daksh Gargas on 01/01/19.
//  Copyright © 2019 Daksh Gargas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var _currentValue: Int = 0
    var currentSliderValue: Int {
        set {
            _currentValue = newValue
        }
        get {
            return Int(slider.value.rounded())
        }
    }
    var score = 0
    var targetValue: Int = 0
    var round = 0

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startNewRound()
        
        let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, for: .normal)
        
        let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
        let trackLeftResizeable = trackLeftImage.resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftResizeable, for: .normal)
        
        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
        let trackRightResizeable = trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightResizeable, for: .normal)
    }
    
    // MARK: Actions
    @IBAction func startNewGame() {
        score = 0
        round = 0
        startNewRound()
    }

    @IBAction func showAlert() {

        let difference = abs(targetValue - currentSliderValue)
        var points = 100 - difference
        let title: String
        switch difference {
        case 0:
            title = "Perfect! 🥳 \n+100 points"
            points += 100
        case _ where difference <= 5:
            title = "You almost had it 😅"
            if(difference == 1) {
                points += 50
            }
        case _ where difference <= 10:
            title = "Pretty good! ☺️"
        default:
            title = "Not even close! 😒"
        }
        
        score += points

        let message = "You scored \(points) points"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: {
            _ in
            self.startNewRound()
        })
        alert.addAction(action)

        present(alert, animated: true, completion: {
            print("present completed")
        })
    }

    @IBAction func sliderMoved(_ slider: UISlider) {
        let roundedValue = slider.value.rounded()
        currentSliderValue = Int(roundedValue)
    }

    //MARK: Private methods
    func startNewRound() {
        round += 1
        targetValue = Int.random(in: 1...100)
        currentSliderValue = 50
        slider.value = Float(_currentValue)
        updateLabels()
    }

    func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }

    
}

