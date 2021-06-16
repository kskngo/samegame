//
//  Card.swift
//  samegame
//
//  Created by Kosuke Nagao on 2021/06/11.
//

import Foundation
import UIKit

class Card {
    var emoji: String = ""
    var disabled = false


    init() {
//        super.init()
    }

    func Card(x: Int, y: Int, emoji: String, squareSize: Int) -> UILabel {
        let titleLabel = UILabel() // ラベルの生成
        titleLabel.frame = CGRect(x: x, y: y, width: squareSize, height: squareSize)
        titleLabel.text = emoji
        titleLabel.backgroundColor = .lightGray
        titleLabel.textAlignment = .center
//        titleLabel.addTarget(self, action: #selector(tappedCard(_:)), for: UIControl.Event.touchUpInside)

        return titleLabel
    }
}
