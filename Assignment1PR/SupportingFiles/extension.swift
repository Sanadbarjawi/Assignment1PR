//
//  extension.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }

}
extension UINavigationController {
    
    ///Get previous view controller of the navigation stack
    func previousViewController() -> UIViewController?{
        
        let lenght = self.viewControllers.count
        
        let previousViewController: UIViewController? = lenght >= 2 ? self.viewControllers[lenght-2] : nil
        
        return previousViewController
    }
    
}
extension UIViewController{
    ///configuration for activity indicator
    func configureActivityIndicator(animating:Bool){
        if animating{
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = UIColor.black
            activityIndicator.accessibilityIdentifier = "activityIndicator"
            self.view.addSubview(activityIndicator)
            NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
            activityIndicator.startAnimating()
        }else{
            for view in self.view.subviews{
                if view.accessibilityIdentifier == "activityIndicator"{
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    func displayAlertWithDone(msg:String,completion:@escaping ()->()){
        let alert = UIAlertController(title: "Success!", message: msg, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Done", style: .default) { (alert) in
            completion()
        }
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
    }

   
}
extension Bool {
    mutating func toggle() {
        self = !self
    }
}
