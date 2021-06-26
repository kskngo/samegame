import UIKit

struct Card<CardContent> {
    var value: CardContent
    var rowIndex: Int
    var columIndex: Int
    var isFixed: Bool = false
}

struct CardsState {
    static let numberOfRows = 3
    static let numberOfColumns = 3
    let cardValues = ["👻", "🐤"]
//    let cardValues = ["👻", "🐤", "🍄"]

    var cards = [[Card<String>]]()

    mutating func reset() {
        for _ in 0..<CardsState.numberOfRows {
            var row:[Card<String>] = []
            for j in 0..<CardsState.numberOfColumns {
                let value = cardValues.randomElement()!
                let card = Card(value: value, rowIndex: 0, columIndex: j)
                row.append(card)
            }
            cards.append(row)
        }

    }


    func printCards() {
        for cardRows in cards {
            var cardRow = ""
            for card in cardRows {
                cardRow += "[\(card.value)]"
            }
            print(cardRow)
        }
    }
}

struct Score {

    private (set) var totalValue: Int
    var value: Int {
        didSet {
            totalValue +=  value
        }
    }
}
enum GameState {
    case newGame
    case notSelected
    case selecded
    case gameOver
    case clear
}

func tapedCard(rowIndex: Int, coloumIndex: Int) {
    updateCard(rowIndex: rowIndex, coloumIndex: coloumIndex)
    updateScore()
}

func updateCard(rowIndex: Int, coloumIndex: Int) {
    let selectedCardValue = cardsState.cards[rowIndex][coloumIndex].value

    let isMatch = checkRightCard(selectedCardValue: selectedCardValue, rowIndex: rowIndex, coloumIndex: coloumIndex)

    print(isMatch)

//    cardsState.cards[rowIndex][coloumIndex].value = " "
//    cardsState.printCards()
}

// 右のカードがselectedCardValueと一致する場合trueを返す。一致しない場合falseを返す。
// 右のカードが存在しない場合はnilを返す。
func checkRightCard(selectedCardValue: String, rowIndex: Int, coloumIndex: Int) -> Bool? {

    let targetColoumIndex = coloumIndex + 1
    // 右のカードが存在するか確認
    guard targetColoumIndex < CardsState.numberOfColumns else {
        return nil
    }

    let rightCardValue = cardsState.cards[rowIndex][targetColoumIndex].value
    print("rightCardValue\(rightCardValue)")
    return selectedCardValue == rightCardValue
}

func updateScore() {
    score.value += 1
}

struct Game {
    var score: Score
    var cards: CardsState
//    var gameState: GameState

}
func startNewGame() {
    cardsState.reset()
    cardsState.printCards()
}




var cardsState = CardsState()
var score = Score(totalValue: 0, value: 0)
var game = Game(score: score, cards: cardsState)

startNewGame()

let selectedCardIndex = (0, 0)
tapedCard(rowIndex: 0, coloumIndex: 0)
tapedCard(rowIndex: 0, coloumIndex: 1)
tapedCard(rowIndex: 0, coloumIndex: 2)




