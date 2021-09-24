import UIKit

struct Card {
    var value: String
    var isFixed: Bool



}

class Game {

    static let numberOfRows =  4
    static let numberOfColumns = 4
    static let cardValues = ["👻", "🐤"]

    var cards = [Card]()

    var numberOfDeletedCards = 0

    var totalScore = 0

    func resetCards() {
//        for _ in 0..<Game.numberOfRows {
//            for _ in 0..<Game.numberOfColumns {
//                let value = Game.cardValues.randomElement()!
//                let card = Card(value: value, isFixed: false)
//                cards.append(card)
//            }
//        }

        let 👻 = Card(value: "👻", isFixed: false)
        let 🐤 = Card(value: "🐤", isFixed: false)

        cards = [👻, 🐤, 🐤, 🐤,
                 👻, 🐤, 👻, 👻,
                 🐤, 🐤, 👻, 👻,
                 👻, 👻, 👻, 👻,]

//        cards = [Card(value: "0"), Card(value: "1"), Card(value: "2"),
//                 Card(value: "3"), Card(value: "4"), Card(value: "5"),
//                 Card(value: "6"), Card(value: "7"), Card(value: "8")]

    }
    func printCards() {
        for rowIndex in 0..<Game.numberOfRows {
            var cardRow = ""
            for columnsIndex in 0..<Game.numberOfColumns {
                let index = rowIndex * Game.numberOfColumns + columnsIndex

                if cards[index].isFixed {
                    cardRow += "[  ]"
                } else {
                    cardRow += "[\(cards[index].value)]"
                }
            }
            print(cardRow)
        }
        print("---------")
    }

    func tapedCard(rowIndex: Int, columnsIndex: Int) {
        print("tapped at \(rowIndex)-\(columnsIndex)")
        numberOfDeletedCards = 0
        let tappedIndex = getCardsIndex(rowIndex: rowIndex, columnsIndex: columnsIndex)
        let tappedCardValue = cards[tappedIndex].value
        deleteCards(tappedCardValue: tappedCardValue, tappedIndex: tappedIndex)
        moveCards()
    }

    func isGameRunning() -> Bool {
        // 消せるカードが存在するかチェック
        for index in 0..<cards.count {

            if cards[index].isFixed {
                continue
            }
            if let card = getTopCard(index: index) {
                if !card.isFixed && card.value == cards[index].value {
                    return true
                }
            }
            if let card = getBottomCard(index: index) {
                if !card.isFixed && card.value == cards[index].value {
                    return true
                }
            }
            if let card = getLeftCard(index: index) {
                if !card.isFixed && card.value == cards[index].value {
                    return true
                }
            }
            if let card = getRightCard(index: index) {
                if !card.isFixed && card.value == cards[index].value {
                    return true
                }
            }
        }

        return false
    }

    func calculateScore() -> Int {
        // (消したカード,点数) = (2,1), (3,3), (4,6), (5,10), (6,15),...
        (numberOfDeletedCards * numberOfDeletedCards - numberOfDeletedCards) / 2
    }

    func moveCards() {
        moveCardsFromTopToBottom()
        printCards()
        moveCardsFromRightToLeft()
    }

    func moveCardsFromTopToBottom() {
        var arriveCards = [[Card]]()
        for columnsIndex in 0..<Game.numberOfColumns {
            var arriveCardsOneColumns = [Card]()
            for i in columnsIndex..<cards.count where i % Game.numberOfColumns - columnsIndex == 0 {
                if !cards[i].isFixed {
                    arriveCardsOneColumns.append(cards[i])
                }
            }
            arriveCards.append(arriveCardsOneColumns)
        }
        for columnsIndex in 0..<Game.numberOfColumns {
            var arriveCardsOneColumns = arriveCards[columnsIndex]
            for i in (columnsIndex..<cards.count).reversed() where i % Game.numberOfColumns - columnsIndex == 0 {
                if let newCard = arriveCardsOneColumns.popLast() {
                    cards[i] = newCard
                } else {
                    cards[i] = Card(value: "", isFixed: true)
                }
            }
        }
    }

    func moveCardsFromRightToLeft() {

        // たて１列が空の列がないか調べる
        var fixedColumnsIndexList = [Int]()
        for columnsIndex in 0..<Game.numberOfColumns {
            var isFixed = true
            for index in columnsIndex..<cards.count where index % Game.numberOfColumns - columnsIndex == 0 {
                if !cards[index].isFixed {
                    isFixed = false
                    break
                }
            }
            if isFixed {
                fixedColumnsIndexList.append(columnsIndex)
            }
        }

        // １行毎に詰めた行リストをつくる
        var arriveCards = [[Card]]()
        for rowIndex in 0..<cards.count where rowIndex % Game.numberOfColumns == 0 {
            var arriveCardsOneRow = [Card]()
            for i in rowIndex..<cards.count where i < rowIndex + Game.numberOfColumns {

                if !fixedColumnsIndexList.contains(i % Game.numberOfColumns){
                    arriveCardsOneRow.append(cards[i])
                }
            }
            arriveCards.append(arriveCardsOneRow)
        }

        for (rowIndex, arriveCardsOneRow) in arriveCards.enumerated() {
            for index in Game.numberOfColumns * rowIndex..<Game.numberOfColumns * rowIndex + Game.numberOfColumns {
                if index % Game.numberOfColumns < arriveCardsOneRow.count {
                    cards[index] = arriveCardsOneRow[index % Game.numberOfColumns]
                } else {
                    cards[index] = Card(value: "", isFixed: true)
                }
            }
        }
    }

    func deleteCards(tappedCardValue: String, tappedIndex: Int) {
        // タップされたカードの上下左右を消す
        deleteCardsOnFourDirections(tappedCardValue: tappedCardValue, index: tappedIndex)
    }

    // 対象となるカードの上下左右にあるカードを消す
    func deleteCardsOnFourDirections(tappedCardValue: String, index: Int) {

        //上にあるカードを消す
        var isFixedCardTop = false
        if let card = getTopCard(index: index) {
            if !card.isFixed && card.value == tappedCardValue {
                cards[getTopCardIndex(index: index)].isFixed = true
                isFixedCardTop = true
                numberOfDeletedCards += 1
            }
        }
        // 下にあるカードを消す
        var isFixedCardBottom = false
        if let card = getBottomCard(index: index) {
            if !card.isFixed && card.value == tappedCardValue {
                cards[getBottomCardIndex(index: index)].isFixed = true
                isFixedCardBottom = true
                numberOfDeletedCards += 1
            }
        }
        // 左にあるカードを消す
        var isFixedCardLeft = false
        if let card = getLeftCard(index: index) {
            if !card.isFixed && card.value == tappedCardValue {
                cards[getLeftCardIndex(index: index)].isFixed = true
                isFixedCardLeft = true
                numberOfDeletedCards += 1
            }
        }
        // 右にあるカードを消す
        var isFixedCardRight = false
        if let card = getRightCard(index: index) {
            if !card.isFixed && card.value == tappedCardValue {
                cards[getRightCardIndex(index: index)].isFixed = true
                isFixedCardRight = true
                numberOfDeletedCards += 1
            }
        }

        // １つでも消したカードがあれば対象カードも消す
        if !cards[index].isFixed && (isFixedCardTop || isFixedCardBottom || isFixedCardLeft || isFixedCardRight) {
            cards[index].isFixed = true
            numberOfDeletedCards += 1
        }

        if isFixedCardTop && getTopCard(index: index) != nil {
            // 対象を上に移動して再起呼び出し
            deleteCardsOnFourDirections(tappedCardValue: tappedCardValue, index: getTopCardIndex(index: index))
        }

        if isFixedCardBottom && getBottomCard(index: index) != nil {
            // 対象を下に移動して再起呼び出し
            deleteCardsOnFourDirections(tappedCardValue: tappedCardValue, index: getBottomCardIndex(index: index))
        }

        if isFixedCardLeft && getLeftCard(index: index) != nil {
            // 対象を左に移動して再起呼び出し
            deleteCardsOnFourDirections(tappedCardValue: tappedCardValue, index: getLeftCardIndex(index: index))
        }

        if isFixedCardRight && getRightCard(index: index) != nil {
            // 対象を右に移動して再起呼び出し
            deleteCardsOnFourDirections(tappedCardValue: tappedCardValue, index: getRightCardIndex(index: index))
        }
    }

    func getCardsIndex(rowIndex: Int, columnsIndex: Int) -> Int {
        return rowIndex * Game.numberOfColumns + columnsIndex
    }

    func getLeftCard(index: Int) -> Card? {
        if index % Game.numberOfColumns == 0 {
            return nil
        } else {
            return cards[getLeftCardIndex(index: index)]
        }
    }
    func getRightCard(index: Int) -> Card? {
        if (index + 1) % Game.numberOfColumns == 0 {
            return nil
        } else {
            return cards[getRightCardIndex(index: index)]
        }
    }
    func getTopCard(index: Int) -> Card? {
        if index < Game.numberOfColumns {
            return nil
        } else {
            return cards[getTopCardIndex(index: index)]
        }
    }
    func getBottomCard(index: Int) -> Card? {
        if index + Game.numberOfColumns >= Game.numberOfColumns * Game.numberOfRows {
            return nil
        } else {
            return cards[getBottomCardIndex(index: index)]
        }
    }
    func getTopCardIndex(index: Int) -> Int {
        index - Game.numberOfColumns
    }
    func getBottomCardIndex(index: Int) -> Int {
        index + Game.numberOfColumns
    }
    func getLeftCardIndex(index: Int) -> Int {
        index - 1
    }
    func getRightCardIndex(index: Int) -> Int {
        index + 1
    }
}

let game = Game()
game.resetCards()
game.printCards()
game.tapedCard(rowIndex: 1, columnsIndex: 1)
game.printCards()
print("GameRunning is \(game.isGameRunning())")
print("Score:\(game.calculateScore())")

