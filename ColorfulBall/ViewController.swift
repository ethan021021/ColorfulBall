//
//  ViewController.swift
//  ColorfulBall
//
//  Created by Ethan Thomas on 5/31/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import ChameleonFramework
import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var circleView: UIView!
    var circleViewModel: CircleViewModel!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
    }

    func setup() {
        // Add circle view
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100, height: 100)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = UIColor.greenColor()
        view.addSubview(circleView)

        circleViewModel = CircleViewModel()

        circleView
            .rx_observe(CGPoint.self, "center")
            .bindTo(circleViewModel.centerVariable)
            .addDisposableTo(disposeBag)

        circleViewModel.backgroundColorObservable
            .subscribeNext { (backgroundColor) in
                UIView.animateWithDuration(0.1) {
                    self.circleView.backgroundColor = backgroundColor

                    let viewBackgroundColor = UIColor.init(complementaryFlatColorOf: backgroundColor, withAlpha: 1.0)

                    if viewBackgroundColor != backgroundColor {
                        self.view.backgroundColor = viewBackgroundColor
                    }
                }
        }
        .addDisposableTo(disposeBag)

        // Add gesture recognizer
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }

    func circleMoved(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.locationInView(view)
        UIView.animateWithDuration(0.1) { 
            self.circleView.center = location
        }
    }
}

