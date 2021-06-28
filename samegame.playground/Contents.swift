import UIKit

struct Card<CardContent> {
    var value: CardContent
    var rowIndex: Int
    var columIndex: Int
    var isFixed: Bool = false
}

struct CardsState {
    static let numberOfRows =  5
    static let numberOfColumns = 5
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
                if card.isFixed {
                    cardRow += "[  ]"
                } else {
                    cardRow += "[\(card.value)]"
                }
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

    updateRightCards(selectedCardValue: selectedCardValue, rowIndex: rowIndex, coloumIndex: coloumIndex)
    updateLeftCards(selectedCardValue: selectedCardValue, rowIndex: rowIndex, coloumIndex: coloumIndex)
    cardsState.printCards()
}

func updateRightCards(selectedCardValue: String, rowIndex: Int, coloumIndex: Int) {
    if let isMatch = checkRightCard(selectedCardValue: selectedCardValue, rowIndex: rowIndex, coloumIndex: coloumIndex) {

        if isMatch {
            cardsState.cards[rowIndex][coloumIndex].isFixed = true
            cardsState.cards[rowIndex][coloumIndex + 1].isFixed = true
            // 右隣のカードに対して再起呼び出し
            updateRightCards(selectedCardValue: selectedCardValue, rowIndex: rowIndex, coloumIndex: coloumIndex + 1)
        }
    }
}

func updateLeftCards(selectedCardValue: String, rowIndex: Int, coloumIndex: Int) {
    if let isMatch = checkLeftCard(selectedCardValue: selectedCardValue, rowIndex: rowIndex, coloumIndex: coloumIndex) {

        if isMatch {
            cardsState.cards[rowIndex][coloumIndex].isFixed = true
            cardsState.cards[rowIndex][coloumIndex - 1].isFixed = true
            // 左隣のカードに対して再起呼び出し
            updateLeftCards(selectedCardValue: selectedCardValue, rowIndex: rowIndex, coloumIndex: coloumIndex - 1)
        }
    }
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
    print("rightCardValue:\(rowIndex):\(targetColoumIndex)=\(rightCardValue)")
    return selectedCardValue == rightCardValue
}

func checkLeftCard(selectedCardValue: String, rowIndex: Int, coloumIndex: Int) -> Bool? {

    let targetColoumIndex = coloumIndex - 1
    // 左のカードが存在するか確認
    guard targetColoumIndex < CardsState.numberOfColumns else {
        return nil
    }

    let leftCardValue = cardsState.cards[rowIndex][targetColoumIndex].value
    print("leftCardValue:\(rowIndex):\(targetColoumIndex)=\(leftCardValue)")
    return selectedCardValue == leftCardValue
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
tapedCard(rowIndex: 0, coloumIndex: 4)
//tapedCard(rowIndex: 0, coloumIndex: 1)
//tapedCard(rowIndex: 0, coloumIndex: 2)




