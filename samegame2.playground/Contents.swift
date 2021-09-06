import UIKit

struct Card<CardContent> {
    var value: CardContent
    var isFixed: Bool = false
}

class Game {

    static let numberOfRows =  4
    static let numberOfColumns = 5
    static let cardValues = ["👻", "🐤"]

    var cards = [Card<String>]()

    func resetCards() {
        for _ in 0..<Game.numberOfRows {
            for _ in 0..<Game.numberOfColumns {
                let value = Game.cardValues.randomElement()!
                let card = Card(value: value)
                cards.append(card)
            }
        }
    }
    func printCards() {
        for rowIndex in 0..<Game.numberOfRows {
            var cardRow = ""
            for columnsIndex in 0..<Game.numberOfColumns {
                let index = rowIndex * Game.numberOfColumns + columnsIndex

                if cards[index].value == "" {
                    cardRow += "[  ]"
                } else {
                    cardRow += "[\(cards[index].value)]"
                }
            }
            print(cardRow)
        }
        print("---------")
    }

}

let game = Game()
game.resetCards()
game.printCards()


