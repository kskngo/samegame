//
//  ViewController.swift
//  samegame
//
//  Created by Kosuke Nagao on 2021/06/08.
//

import UIKit

class ViewController: UIViewController {

//    var cards = Array(repeating: Card(), count: 16)
    let numberOfCards = 64
    let cardSize = 30
    let x = 30
    let y = 200
    let cardMargin = 5

    var cards = [[UILabel]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }

    func configure() {
        // UILabelの設定

        var x = 30
        var y = 200

        for i in 0...7 {
            var cardsWork = [UILabel]()
            for _ in 0...7 {
                let card = makeCard(x:x, y:y, squareSize: cardSize)
                cardsWork.append(card)
//                cards[i].append(card)
                self.view.addSubview(card)
                x = x + cardSize + cardMargin
            }
            cards.append(cardsWork)
            x = 30
            y = y + cardSize + cardMargin

        }
    }



    func makeCard(x: Int, y: Int, squareSize: Int) -> UILabel {
        let emojis = ["1","2","3"]
        let emoji = emojis[Int.random(in: 0..<emojis.count)]
        let titleLabel = UILabel() // ラベルの生成
        titleLabel.frame = CGRect(x: x, y: y, width: squareSize, height: squareSize)
        titleLabel.text = emoji
        titleLabel.backgroundColor = .lightGray
        titleLabel.textAlignment = .center
        return titleLabel
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches.first!.location(in: view))

        let position = touches.first!.location(in: view)
        let selectedColumn: Int?
        let selectedRow: Int?

        switch position.x {
        case cards[0][0].frame.minX...cards[0][0].frame.maxX:
            print("col1")
            selectedColumn = 0
        case cards[0][1].frame.minX...cards[0][1].frame.maxX:
            print("col2")
            selectedColumn = 1
        case cards[0][2].frame.minX...cards[0][2].frame.maxX:
            print("col3")
            selectedColumn = 2
        case cards[0][3].frame.minX...cards[0][3].frame.maxX:
            print("col4")
            selectedColumn = 3
        case cards[0][4].frame.minX...cards[0][4].frame.maxX:
            print("col5")
            selectedColumn = 4
        case cards[0][5].frame.minX...cards[0][5].frame.maxX:
            print("col6")
            selectedColumn = 5
        case cards[0][6].frame.minX...cards[0][6].frame.maxX:
            print("col7")
            selectedColumn = 6
        case cards[0][7].frame.minX...cards[0][7].frame.maxX:
            print("col8")
            selectedColumn = 7
        default:
            selectedColumn = nil
        }

        switch position.y {
        case cards[0][0].frame.minY...cards[0][0].frame.maxY:
            print("r1")
            selectedRow = 0
        case cards[1][0].frame.minY...cards[1][0].frame.maxY:
            print("r2")
            selectedRow = 1
        case cards[2][0].frame.minY...cards[2][0].frame.maxY:
            print("r3")
            selectedRow = 2
        case cards[3][0].frame.minY...cards[3][0].frame.maxY:
            print("r4")
            selectedRow = 3
        case cards[4][0].frame.minY...cards[4][0].frame.maxY:
            print("r5")
            selectedRow = 4
        case cards[5][0].frame.minY...cards[5][0].frame.maxY:
            print("r6")
            selectedRow = 5
        case cards[6][0].frame.minY...cards[6][0].frame.maxY:
            print("r7")
            selectedRow = 6
        case cards[7][0].frame.minY...cards[7][0].frame.maxY:
            print("r8")
            selectedRow = 7
        default:
            print("none")
            selectedRow = nil
        }

        // 選択されたセルに対する処理
        if let selectedColumn = selectedColumn, let selectedRow = selectedRow {
//            cards[selectedRow][selectedColumn].isHidden = true
            updateCard(selectedRow: selectedRow, selectedColumn: selectedColumn)
        }


        //

        //
//           if _startButton.alpha != 0 {
//               return
//           }
//           //タッチ位置からピースの列番号と行番号を求める(3)
//           let pos = touches.first!.location(in: _gameView)
//                   if 30 < pos.x && pos.x < 330 && 180 < pos.y && pos.y < 480 {
//                       let tx = Int((pos.x-30)/75)
//                       let ty = Int((pos.y-180)/75)
//                       movePiece(tx: tx, ty: ty)
//                   }
       }

    func updateCard(selectedRow: Int, selectedColumn: Int) {

        // 隣り合う同じカードを消す処理
        deleteCard(selectedRow: selectedRow, selectedColumn: selectedRow)
        // カードを動かす



    }

    func deleteCard(selectedRow: Int, selectedColumn: Int) {

        let selectedEmoji = cards[selectedRow][selectedColumn].text!
        let targetRow = selectedRow + 1
        // 縦方向の判定
        for i in targetRow..<7 {
            print(selectedEmoji + " " + cards[i][selectedColumn].text!)
            if selectedEmoji == cards[i][selectedColumn].text {
                cards[i][selectedColumn].isHidden = true
//                cards[selectedRow + 1][selectedColumn].isHidden = true
            }
        }





    }



    func moveVertical(selectedRow: Int, selectedColumn: Int) {


    }



}

