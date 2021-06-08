//
//  ViewController.swift
//  samegame
//
//  Created by Kosuke Nagao on 2021/06/08.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // UILabelの設定
        let size = 30
        var x = 30
        var y = 200
        for _ in 0...7 {
            for _ in 0...7 {
                self.view.addSubview(makeSquare(x:x, y:y, text: "👽", squareSize: size))
                x = x + size + 5
            }
            x = 30
            y = y + size + 5

        }

    }


    func makeSquare(x: Int, y: Int, text: String, squareSize: Int) -> UILabel {
        let titleLabel = UILabel() // ラベルの生成
//        titleLabel.frame = CGRect(x: 30, y: 100, width: UIScreen.main.bounds.size.width, height: 40) // 位置とサイズの指定
        titleLabel.frame = CGRect(x: x, y: y, width: squareSize, height: squareSize)
        titleLabel.textAlignment = NSTextAlignment.center // 横揃えの設定
        titleLabel.text = "1" // テキストの設定
        titleLabel.textColor = UIColor.black // テキストカラーの設定
        titleLabel.font = UIFont(name: "HiraKakuProN-W6", size: 17) // フォントの設定
        titleLabel.backgroundColor = .lightGray
        return titleLabel

}
}

