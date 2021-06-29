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
//    let cardValues = ["👻", "🐤"]
    let cardValues = ["👻"]
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
    updateCards(rowIndex: rowIndex, coloumIndex: coloumIndex)
    updateScore()
}

func updateCards(rowIndex: Int, coloumIndex: Int) {
    let selectedCardValue = cardsState.cards[rowIndex][coloumIndex].value

    // タップされたカードの右側にあるカードを消す
    deleteMatchCards(selectedCardValue, rowIndex, coloumIndex, getNextColoumIndex: { (coloumIndex: Int) -> Int in coloumIndex + 1})
    // タップされたカードの左側にあるカードを消す
    deleteMatchCards(selectedCardValue, rowIndex, coloumIndex, getNextColoumIndex: { (coloumIndex: Int) -> Int in coloumIndex - 1})


    cardsState.printCards()
}

// 隣り合う同じカードを消す
func deleteMatchCards(_ selectedCardValue: String, _ rowIndex: Int, _ coloumIndex: Int, getNextColoumIndex: (Int) -> Int) {
    if let isMatch = isMatchCard(selectedCardValue: selectedCardValue, rowIndex: rowIndex, coloumIndex: coloumIndex, getNextColoumIndex: getNextColoumIndex) {

        // 隣のカードが同じ場合
        if isMatch {
            cardsState.cards[rowIndex][coloumIndex].isFixed = true
            cardsState.cards[rowIndex][getNextColoumIndex(coloumIndex)].isFixed = true
            // 隣のカードに対して再起呼び出し
            deleteMatchCards(selectedCardValue, rowIndex, getNextColoumIndex(coloumIndex),  getNextColoumIndex: getNextColoumIndex)
        }
    }
}

// getNextColoumIndexのカードがselectedCardValueと一致する場合trueを返す。一致しない場合falseを返す。
// getNextColoumIndexのカードが存在しない場合はnilを返す。
func isMatchCard(selectedCardValue: String, rowIndex: Int, coloumIndex: Int, getNextColoumIndex: (Int) -> Int) -> Bool? {

    let targetColoumIndex = getNextColoumIndex(coloumIndex)
    // カードインデックスが存在するか確認
    guard existsIndex(targetColoumIndex: targetColoumIndex, indexSize: CardsState.numberOfColumns) else {
        return nil
    }
    let targetCardValue = cardsState.cards[rowIndex][targetColoumIndex].value
    return selectedCardValue == targetCardValue
}

func existsIndex(targetColoumIndex: Int, indexSize: Int) -> Bool {
    0 <= targetColoumIndex && targetColoumIndex < indexSize
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

//tapedCard(rowIndex: 0, coloumIndex: 0)
//tapedCard(rowIndex: 0, coloumIndex: 1)
tapedCard(rowIndex: 0, coloumIndex: 2)




