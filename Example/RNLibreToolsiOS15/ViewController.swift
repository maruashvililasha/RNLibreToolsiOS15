//
//  ViewController.swift
//  RNLibreToolsiOS15
//
//  Created by maruashvililasha@gmail.com on 12/14/2021.
//  Copyright (c) 2021 maruashvililasha@gmail.com. All rights reserved.
//
import RNLibreToolsiOS15
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let s = RNLibreToolsiOS.shared
        s.startSession { result in
            switch result {
            case .success(let gluecose):
                DispatchQueue.main.async {
                    print("\(gluecose)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

