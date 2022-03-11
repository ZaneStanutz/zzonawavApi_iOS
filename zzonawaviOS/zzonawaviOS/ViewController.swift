//
//  ViewController.swift
//  zzonawaviOS
//
//  Created by ZZ on 2022-02-24.
//

import UIKit

class ViewController: UIViewController {
	let gradient = CAGradientLayer()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var ellipsis1: UILabel!
    @IBOutlet weak var ellipsis2: UILabel!
    @IBOutlet weak var ellipsis3: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient.frame = self.view.bounds
        gradient.colors = [
            UIColor(red: 25/255.0, green: 25/255.0, blue: 120/255.0,
                alpha: 1.0).cgColor,
            UIColor(red: 100/255.0, green: 10/255.0, blue: 150/255.0, alpha: 1.0).cgColor
        ]
        
        gradient.startPoint = CGPoint(x: 0 , y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(self.gradient)
        imageView.layer.opacity = 0
        ellipsis1.layer.opacity = 0
        ellipsis2.layer.opacity = 0
        ellipsis3.layer.opacity = 0
        loadingText.layer.opacity = 0
        view.addSubview(imageView)
        view.addSubview(loadingText)
        view.addSubview(ellipsis1)
        view.addSubview(ellipsis2)
        view.addSubview(ellipsis3)
        animateLogoOpacityShow()
        animateLoading()

        } // viewDidLoad()
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradient.frame = view.layer.bounds
    }
    
    func animateLoading(){
        UIView.animate(withDuration: 1.0, animations: {
            self.loadingText.layer.opacity = 1
        }) { (done) in
            if done {
                self.animateEllipsis1()
            }
        }
    }
    func animateEllipsis1(){
        UIView.animate(withDuration: 1.0, animations: {
            self.ellipsis1.layer.opacity = 1
        }) { (done) in
            if done {
                self.animateEllipsis2()
            }
        }
    }
    func animateEllipsis2(){
        UIView.animate(withDuration: 1.0, animations:{
            self.ellipsis2.layer.opacity = 1
        }) { (done) in
            if done {
                self.animateEllipsis3()
            }
        }
    }
    func animateEllipsis3(){
        UIView.animate(withDuration: 1.0, animations: {
            self.ellipsis3.layer.opacity = 1
        }) { (done) in
            if done {
                self.animateFadeEllipsis()
            }
        }
    }
    func animateFadeEllipsis(){
        UIView.animate(withDuration: 1, animations: {
            self.ellipsis1.layer.opacity = 0
            self.ellipsis2.layer.opacity = 0
            self.ellipsis3.layer.opacity = 0
            self.loadingText.layer.opacity = 0
        }) { (done) in
            if done {
                self.animateLoading()
            }
        }
    }
    func animateLogoOpacityShow(){
        UIView.animate(withDuration: 3.0, animations: {
            self.imageView.layer.opacity = 1
        }){ (done) in
            if done {
                self.animationLogoOpacityHide()
                }
            }
        }
    func animationLogoOpacityHide(){
        UIView.animate(withDuration: 3.0, animations: {
            self.imageView.layer.opacity = 0.7
        }){ (done) in
            if done {
                self.animateLogoOpacityShow()
                }
            }
        }

} // class

