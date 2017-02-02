//
//  ImageViewController.swift
//  Cassini
//
//  Created by Phaniteja Nunna on 2/1/17.
//  Copyright © 2017 Phaniteja Nunna. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    var imageURL: NSURL?{
        didSet{
            image = nil
            if view.window != nil{
                fetchImage()
            }
        }
    }
    private func fetchImage(){
        if let url = imageURL{
            spinner.startAnimating()
            let globalQueue = DispatchQueue.global(qos: .userInitiated)
            globalQueue.async {
                let contentsOfURL = NSData(contentsOf: url as URL)
                DispatchQueue.main.async {
                    if url == self.imageURL{
                        if let imageData =  contentsOfURL {
                            self.image = UIImage(data:imageData as Data)
                            self.spinner?.stopAnimating()
                        }
                        else{
                            print("ignored data from url \(url)")

                        }
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var imageView = UIImageView()
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0

        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    private var image: UIImage?{
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(image == nil){
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
       // imageURL = NSURL(string:DemoURL.Stanford)

        // Do any additional setup after loading the view.
    }

   
}
