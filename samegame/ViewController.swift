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
        configure()
    }

    func configure() {
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

    func makeSquare(x: Int, y: Int, text: String, squareSize: Int) -> UIButton {
        let titleLabel = UIButton() // ラベルの生成
        titleLabel.frame = CGRect(x: x, y: y, width: squareSize, height: squareSize)
        titleLabel.setTitle(text, for: .normal)
        titleLabel.backgroundColor = .lightGray
        titleLabel.addTarget(self, action: #selector(tappedCard(_:)), for: UIControl.Event.touchUpInside)
        
        return titleLabel
    }

    @objc func tappedCard(_ sender: UIButton) {
        print(sender.titleLabel?.text)

    }
}

