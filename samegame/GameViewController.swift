//
//  ViewController.swift
//  samegame
//
//  Created by Kosuke Nagao on 2021/06/08.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var highestScoreLabel: UILabel!
    @IBOutlet weak var endOfGameLabel: UILabel!

    var game = GameModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setusp after loading the view.

        NotificationCenter.default.addObserver(
            forName: .gameModelDidChangeCards,
            object: nil,
            queue: OperationQueue.main,
            using: { [weak self] _ in
                self?.updateCardUI()
            }
        )

        game.startNewGame()
        updateCardUI()

    }
    @IBAction func tappedCard(_ sender: UIButton) {
        if let restorationIdentifier = sender.restorationIdentifier {
            let tappedCardIndex = Int(restorationIdentifier)!
            game.tapedCard(tappedCardIndex: tappedCardIndex)
        }

    }

    @IBAction func tappedResetButton(_ sender: Any) {
        game.resetGame()
        updateCardUI()
    }

    @IBAction func tappedNewGameButton(_ sender: Any) {
        game.startNewGame()
        updateCardUI()
    }

    @IBAction func tappedUndoButton(_ sender: Any) {
        game.undo()
        updateCardUI()

    }
    func updateCardUI() {
        for (index, card) in game.cards.enumerated(){
            if card.isFixed {
                cardButtons[index].setTitle("", for: .normal)
                cardButtons[index].backgroundColor = .none
            } else {
                cardButtons[index].setTitle(card.value, for: .normal)
                cardButtons[index].backgroundColor = .opaqueSeparator
            }
        }

        currentScoreLabel.text = String(game.gameScenes.last!.score)

        if game.gameScenes.last!.isGameOver {

            if game.numberOfEnableCards == 0 {
                endOfGameLabel.text = "よくできました！（ボーナス50点）"
            } else {
                endOfGameLabel.text = "ゲームオーバー..."
            }

            highestScoreLabel.text = String(game.gameScenes.last!.bestScore)
            
            endOfGameLabel.isHidden = false

        } else {
            endOfGameLabel.isHidden = true
        }

    }




}

