//
//  Spinner.swift
//  DietPlanner
//
//  Created by Eric Zacharia on 5/3/21.
//

import UIKit

fileprivate var aView: UIView?

extension UIViewController{
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red:0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
        
        Timer.scheduledTimer(withTimeInterval: 20.0, repeats: false) { (t) in
            self.removeSpinner()
        }
    }
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
}
