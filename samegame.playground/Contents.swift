import UIKit

struct Card<CardContent> {
    var value: CardContent
    var isFixed: Bool = false
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

func updateScore() {
    score.value += 1
}

class Game {

    init() {
    }

    static let numberOfRows =  5
    static let numberOfColumns = 5
//    var score: Score

    let cardValues = ["👻", "🐤"]
    //    let cardValues = ["👻"]
    //    let cardValues = ["👻", "🐤", "🍄"]

    var cards = [[Card<String>]]()



    func reset() {
        for _ in 0..<Game.numberOfRows {
            var row:[Card<String>] = []
            for _ in 0..<Game.numberOfColumns {
                let value = cardValues.randomElement()!
                let card = Card(value: value)
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
        print("---------")
    }


    func startNewGame() {
        reset()
//        cards.printCards()
    }

    // カードがタップされたときの処理
    func tapedCard(rowIndex: Int, coloumIndex: Int) {
        print("tapped at \(rowIndex):\(coloumIndex)")
        printCards()
        updateCards(rowIndex: rowIndex, coloumIndex: coloumIndex)
        updateScore()
        printCards()
    }

    func updateCards(rowIndex: Int, coloumIndex: Int) {
        let selectedCardValue = cards[rowIndex][coloumIndex].value
        // カードを消す
        deleteCards(selectedCardValue: selectedCardValue, rowIndex: rowIndex, coloumIndex: coloumIndex)
//        printCards()
        // カードを移動
        moveCards()
    }

    func deleteCards(selectedCardValue: String, rowIndex: Int, coloumIndex: Int) {
        // タップされたカードの上下左右を消す
        deleteCardsOnFourDirections(selectedCardValue: selectedCardValue, rowIndex: rowIndex, coloumIndex: coloumIndex)

    }
    // 対象となるカードの上下左右にあるカードを消す
    func deleteCardsOnFourDirections(selectedCardValue: String, rowIndex: Int, coloumIndex: Int) {

        //上にあるカードを消す
        let isFixedCardTop = deleteCard(selectedCardValue: selectedCardValue, targetRowIndex: rowIndex - 1, targetColoumIndex: coloumIndex)
        // 下にあるカードを消す
        let isFixedCardBottom = deleteCard(selectedCardValue: selectedCardValue, targetRowIndex: rowIndex + 1, targetColoumIndex: coloumIndex)
        // 左にあるカードを消す
        let isFixedCardLeft = deleteCard(selectedCardValue: selectedCardValue, targetRowIndex: rowIndex, targetColoumIndex: coloumIndex - 1)
        // 右にあるカードを消す
        let isFixedCardRight = deleteCard(selectedCardValue: selectedCardValue, targetRowIndex: rowIndex, targetColoumIndex: coloumIndex + 1)

        // １つでも消したカードがあれば対象カードも消す
        if isFixedCardTop || isFixedCardBottom || isFixedCardLeft || isFixedCardRight {
            cards[rowIndex][coloumIndex].isFixed = true
        }

        if isFixedCardTop {
            // 対象を上に移動して再起呼び出し
            deleteCardsOnFourDirections(selectedCardValue: selectedCardValue, rowIndex: rowIndex - 1, coloumIndex: coloumIndex)
        }

        if isFixedCardBottom {
            // 対象を下に移動して再起呼び出し
            deleteCardsOnFourDirections(selectedCardValue: selectedCardValue, rowIndex: rowIndex + 1, coloumIndex: coloumIndex)
        }

        if isFixedCardLeft {
            // 対象を左に移動して再起呼び出し
            deleteCardsOnFourDirections(selectedCardValue: selectedCardValue, rowIndex: rowIndex, coloumIndex: coloumIndex - 1)
        }

        if isFixedCardRight {
            // 対象を右に移動して再起呼び出し
            deleteCardsOnFourDirections(selectedCardValue: selectedCardValue, rowIndex: rowIndex, coloumIndex: coloumIndex + 1)
        }
    }

    func deleteCard(selectedCardValue: String, targetRowIndex: Int, targetColoumIndex: Int) -> Bool {

        if existsIndex(targetRowIndex: targetRowIndex, targetColoumIndex: targetColoumIndex) {

            if !cards[targetRowIndex][targetColoumIndex].isFixed {
                if isMatchCard(selectedCardValue: selectedCardValue, targetRowIndex: targetRowIndex, targetColoumIndex: targetColoumIndex) {
                    cards[targetRowIndex][targetColoumIndex].isFixed = true
                    return true
                }
            }
        }
        return false
    }

    // カードがselectedCardValueと一致する場合trueを返す。一致しない場合falseを返す。
    func isMatchCard(selectedCardValue: String, targetRowIndex: Int, targetColoumIndex: Int) -> Bool {

        // カードインデックスが存在するか確認
        guard existsIndex(targetRowIndex: targetRowIndex, targetColoumIndex: targetColoumIndex) else {
            fatalError("存在しないインデックス指定されています")
        }
        let targetCardValue = cards[targetRowIndex][targetColoumIndex].value
        return selectedCardValue == targetCardValue
    }

    func existsIndex(targetRowIndex: Int, targetColoumIndex: Int) -> Bool {
        0 <= targetColoumIndex && targetColoumIndex < Game.numberOfColumns
            && 0 <= targetRowIndex && targetRowIndex < Game.numberOfRows
    }

    func moveCards()  {
        moveCardsFromTopToBottom()
        moveCardsFromRightToLeft()
    }

    func moveCardsFromTopToBottom() {
        for columnIndex in 0..<Game.numberOfColumns {
            moveOneColoumOfCardsFromTopToBottom(columnIndex: columnIndex)
        }
    }

    // １列に対する移動処理
    func moveOneColoumOfCardsFromTopToBottom(columnIndex: Int) {

        for rowIndex in (0..<Game.numberOfRows).reversed() {

            if existsIndex(targetRowIndex: rowIndex, targetColoumIndex: columnIndex) &&
                cards[rowIndex][columnIndex].value == "" {
                let isMoved = moveCardsFromTopToBottom(rowIndex: rowIndex ,columnIndex: columnIndex)
                if isMoved && existsTargetCard(targetRowIndex: rowIndex, targetColoumIndex: columnIndex)  {
                    moveOneColoumOfCardsFromTopToBottom(columnIndex: columnIndex)
                }
            }
        }
    }

    // 上のカードを下に移動する
    func moveCardsFromTopToBottom(rowIndex: Int, columnIndex: Int) -> Bool {
        var targetRowIndex = rowIndex
        var isMoved = false
        while existsIndex(targetRowIndex: targetRowIndex, targetColoumIndex: columnIndex) {
            if existsIndex(targetRowIndex: targetRowIndex - 1, targetColoumIndex: columnIndex) {
                cards[targetRowIndex][columnIndex].value = cards[targetRowIndex - 1][columnIndex].value
                isMoved = true
            } else {
                cards[targetRowIndex][columnIndex].value = ""
            }
            targetRowIndex = targetRowIndex-1
        }
        return isMoved
    }


    // targetRowIndexより上にカードが存在するか
    func existsTargetCard(targetRowIndex: Int, targetColoumIndex: Int) -> Bool {
        for rowIndex in (0..<targetRowIndex) {
            if existsIndex(targetRowIndex: rowIndex, targetColoumIndex: targetColoumIndex)
                && cards[rowIndex][targetColoumIndex].value != "" {
                return true
            }
        }
        return false
    }

    func isBlankColumn(columnIndex: Int) -> Bool {
        for rowIndex in 0..<Game.numberOfRows {
            if cards[rowIndex][columnIndex].value != "" {
                return false
            }
        }
        return true
    }

    func moveCardsFromRightToLeft() {
        for columnIndex in 0..<Game.numberOfColumns {
            // １列ブランクかつ右の列に値が存在する場合
            if isBlankColumn(columnIndex: columnIndex) &&
                existsIndex(targetRowIndex: 0, targetColoumIndex: columnIndex + 1) &&
                !isBlankColumn(columnIndex: columnIndex + 1) {
                moveOneColumnOfCardsFromRightToLeft(columnIndex: columnIndex)
            }
        }

    }

    // 指定した空の1列から全体を左に移動する
    func moveOneColumnOfCardsFromRightToLeft(columnIndex: Int) {
        for rowIndex in 0..<Game.numberOfRows {
            var currentColumnIndex = columnIndex
            while true {
                if existsIndex(targetRowIndex: rowIndex, targetColoumIndex: currentColumnIndex + 1) {
                    cards[rowIndex][currentColumnIndex].value = cards[rowIndex][currentColumnIndex + 1].value
                    currentColumnIndex += 1
                } else {
                    cards[rowIndex][currentColumnIndex].value = ""
                    break
                }

            }
        }
    }

}

var score = Score(totalValue: 0, value: 0)
var game = Game()
game.startNewGame()

game.tapedCard(rowIndex: 2, coloumIndex: 2)



