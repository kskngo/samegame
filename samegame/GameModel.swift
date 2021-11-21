//
//  Game.swift
//  samegame
//
//  Created by Kosuke Nagao on 2021/09/26.
//
import Foundation

struct Card {
    var value: String
    var isFixed: Bool
}



class GameModel {

    struct ScoreState {
        var currentScore: Int
        var bestScore: Int
    }

    enum GameState {
        case idle
        case running(ScoreState)
        case gameOver(ScoreState)
    }

    var gameState: GameState = .idle

    private static let numberOfRows =  6
    private static let numberOfColumns = 6
    private static let cardValues = ["👻", "🐤", "❤️"]

    private(set)var cards = [Card]()
    private(set)var originalCards = [Card]()
//    private(set) var totalScore = 0
    private(set) var currentScore = 0
    private(set) var earnedScore = 0
    private(set) var isGameOver = false
    var numberOfEnableCards: Int {
        cards.filter{$0.isFixed == false}.count
    }

    func startNewGame() {
        gameState = .running(ScoreState(currentScore: 0, bestScore: 0))
        
        makeCards()
        originalCards = cards
        currentScore = 0
        isGameOver = false
    }

    func resetGame() {
        cards = originalCards
        currentScore = 0
        isGameOver = false
    }

    private func makeCards() {
        cards = [Card]()
//        for _ in 0..<GameModel.numberOfRows {
//            for _ in 0..<GameModel.numberOfColumns {
//                let value = GameModel.cardValues.randomElement()!
//                let card = Card(value: value, isFixed: false)
//                cards.append(card)
//            }
//        }


//        let stringCards = [
//            "❤️", "👻", "❤️", "👻", "❤️", "❤️",
//            "🐤", "❤️", "🐤", "❤️", "🐤", "👻",
//            "👻", "👻", "👻", "❤️", "❤️", "❤️",
//            "🐤", "🐤", "👻", "🐤", "❤️", "🐤",
//            "❤️", "👻", "❤️", "❤️", "🐤", "❤️",
//            "🐤", "👻", "🐤", "👻", "❤️", "👻"]
        let stringCards = [
            "❤️", "❤️", "❤️", "❤️", "❤️", "❤️",
            "🐤", "❤️", "🐤", "❤️", "🐤", "❤️",
            "❤️", "❤️", "❤️", "❤️", "❤️", "❤️",
            "❤️", "🐤", "❤️", "🐤", "❤️", "🐤",
            "❤️", "👻", "❤️", "❤️", "❤️", "❤️",
            "🐤", "👻", "🐤", "❤️", "❤️", "❤️"]
        cards = stringCards.map {Card(value: $0, isFixed: false)}


    }
    func printCards() {
        for rowIndex in 0..<GameModel.numberOfRows {
            var cardRow = ""
            for columnsIndex in 0..<GameModel.numberOfColumns {
                let index = rowIndex * GameModel.numberOfColumns + columnsIndex

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

    func tapedCard(tappedCardIndex: Int) {
        let numberOfDeletedCards = deleteCards(tappedCardIndex: tappedCardIndex)
        print("\(numberOfDeletedCards) deleted")
        earnedScore = calculateEarnedScore(numberOfDeletedCards: numberOfDeletedCards)
        currentScore += earnedScore
        moveCardsFromTopToBottom()
        moveCardsFromRightToLeft()
        isGameOver = !canDeleteCard()
        if isGameOver && numberOfEnableCards == 0 {
            currentScore += 50
        }
        notify()
    }

    func canDeleteCard() -> Bool {
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

    private func calculateEarnedScore(numberOfDeletedCards: Int) -> Int {
        // (消したカード,点数) = (2,1), (3,3), (4,6), (5,10), (6,15),...
        (numberOfDeletedCards * numberOfDeletedCards - numberOfDeletedCards) / 2
    }

    func deleteCards(tappedCardIndex: Int) -> Int {
        let tappedCardValue = cards[tappedCardIndex].value
        // タップされたカードの上下左右を消す
        let numberOfDeletedCards = deleteCardsOnFourDirections(tappedCardValue: tappedCardValue, index: tappedCardIndex, numberOfDeletedCards: 0)
        return numberOfDeletedCards
    }

     func moveCardsFromTopToBottom() {
        var arriveCards = [[Card]]()
        for columnsIndex in 0..<GameModel.numberOfColumns {
            var arriveCardsOneColumns = [Card]()
            for i in columnsIndex..<cards.count where i % GameModel.numberOfColumns - columnsIndex == 0 {
                if !cards[i].isFixed {
                    arriveCardsOneColumns.append(cards[i])
                }
            }
            arriveCards.append(arriveCardsOneColumns)
        }
        for columnsIndex in 0..<GameModel.numberOfColumns {
            var arriveCardsOneColumns = arriveCards[columnsIndex]
            for i in (columnsIndex..<cards.count).reversed() where i % GameModel.numberOfColumns - columnsIndex == 0 {
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
        for columnsIndex in 0..<GameModel.numberOfColumns {
            var isFixed = true
            for index in columnsIndex..<cards.count where index % GameModel.numberOfColumns - columnsIndex == 0 {
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
        for rowIndex in 0..<cards.count where rowIndex % GameModel.numberOfColumns == 0 {
            var arriveCardsOneRow = [Card]()
            for i in rowIndex..<cards.count where i < rowIndex + GameModel.numberOfColumns {

                if !fixedColumnsIndexList.contains(i % GameModel.numberOfColumns){
                    arriveCardsOneRow.append(cards[i])
                }
            }
            arriveCards.append(arriveCardsOneRow)
        }

        for (rowIndex, arriveCardsOneRow) in arriveCards.enumerated() {
            for index in GameModel.numberOfColumns * rowIndex..<GameModel.numberOfColumns * rowIndex + GameModel.numberOfColumns {
                if index % GameModel.numberOfColumns < arriveCardsOneRow.count {
                    cards[index] = arriveCardsOneRow[index % GameModel.numberOfColumns]
                } else {
                    cards[index] = Card(value: "", isFixed: true)
                }
            }
        }
    }

    // 対象となるカードの上下左右にあるカードを消す
    private func deleteCardsOnFourDirections(tappedCardValue: String, index: Int, numberOfDeletedCards: Int) -> Int {

        var resultNumberOfDeletedCards = numberOfDeletedCards
        //上にあるカードを消す
        var isFixedCardTop = false
        if let card = getTopCard(index: index) {
            if !card.isFixed && card.value == tappedCardValue {
                cards[getTopCardIndex(index: index)].isFixed = true
                isFixedCardTop = true
                resultNumberOfDeletedCards += 1
            }
        }
        // 下にあるカードを消す
        var isFixedCardBottom = false
        if let card = getBottomCard(index: index) {
            if !card.isFixed && card.value == tappedCardValue {
                cards[getBottomCardIndex(index: index)].isFixed = true
                isFixedCardBottom = true
                resultNumberOfDeletedCards += 1
            }
        }
        // 左にあるカードを消す
        var isFixedCardLeft = false
        if let card = getLeftCard(index: index) {
            if !card.isFixed && card.value == tappedCardValue {
                cards[getLeftCardIndex(index: index)].isFixed = true
                isFixedCardLeft = true
                resultNumberOfDeletedCards += 1
            }
        }
        // 右にあるカードを消す
        var isFixedCardRight = false
        if let card = getRightCard(index: index) {
            if !card.isFixed && card.value == tappedCardValue {
                cards[getRightCardIndex(index: index)].isFixed = true
                isFixedCardRight = true
                resultNumberOfDeletedCards += 1
            }
        }

        // １つでも消したカードがあれば対象カードも消す
        if !cards[index].isFixed && (isFixedCardTop || isFixedCardBottom || isFixedCardLeft || isFixedCardRight) {
            cards[index].isFixed = true
            resultNumberOfDeletedCards += 1
        }

        if isFixedCardTop && getTopCard(index: index) != nil {
            // 対象を上に移動して再起呼び出し
            resultNumberOfDeletedCards = deleteCardsOnFourDirections(tappedCardValue: tappedCardValue, index: getTopCardIndex(index: index), numberOfDeletedCards: resultNumberOfDeletedCards)
        }

        if isFixedCardBottom && getBottomCard(index: index) != nil {
            // 対象を下に移動して再起呼び出し
            resultNumberOfDeletedCards = deleteCardsOnFourDirections(tappedCardValue: tappedCardValue, index: getBottomCardIndex(index: index), numberOfDeletedCards: resultNumberOfDeletedCards)
        }

        if isFixedCardLeft && getLeftCard(index: index) != nil {
            // 対象を左に移動して再起呼び出し
            resultNumberOfDeletedCards = deleteCardsOnFourDirections(tappedCardValue: tappedCardValue, index: getLeftCardIndex(index: index), numberOfDeletedCards: resultNumberOfDeletedCards)
        }

        if isFixedCardRight && getRightCard(index: index) != nil {
            // 対象を右に移動して再起呼び出し
            resultNumberOfDeletedCards = deleteCardsOnFourDirections(tappedCardValue: tappedCardValue, index: getRightCardIndex(index: index), numberOfDeletedCards: resultNumberOfDeletedCards)
        }
        return resultNumberOfDeletedCards
    }

    private func getCardsIndex(rowIndex: Int, columnsIndex: Int) -> Int {
        return rowIndex * GameModel.numberOfColumns + columnsIndex
    }

    private func getLeftCard(index: Int) -> Card? {
        if index % GameModel.numberOfColumns == 0 {
            return nil
        } else {
            return cards[getLeftCardIndex(index: index)]
        }
    }
    private func getRightCard(index: Int) -> Card? {
        if (index + 1) % GameModel.numberOfColumns == 0 {
            return nil
        } else {
            return cards[getRightCardIndex(index: index)]
        }
    }
    private func getTopCard(index: Int) -> Card? {
        if index < GameModel.numberOfColumns {
            return nil
        } else {
            return cards[getTopCardIndex(index: index)]
        }
    }
    private func getBottomCard(index: Int) -> Card? {
        if index + GameModel.numberOfColumns >= GameModel.numberOfColumns * GameModel.numberOfRows {
            return nil
        } else {
            return cards[getBottomCardIndex(index: index)]
        }
    }
    private func getTopCardIndex(index: Int) -> Int {
        index - GameModel.numberOfColumns
    }
    private func getBottomCardIndex(index: Int) -> Int {
        index + GameModel.numberOfColumns
    }
    private func getLeftCardIndex(index: Int) -> Int {
        index - 1
    }
    private func getRightCardIndex(index: Int) -> Int {
        index + 1
    }

}

extension Notification.Name {
    static let gameModelDidChangeCards = Notification.Name(rawValue:"GameModel.didChangeCards")
}

private func notify() {
    NotificationCenter.default.post(
        name: .gameModelDidChangeCards,
        object: nil
    )
}

