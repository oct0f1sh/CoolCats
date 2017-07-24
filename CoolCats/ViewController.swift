//
//  ViewController.swift
//  CoolCats
//
//  Created by Duncan MacDonald on 7/3/17.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var nextCat: UIButton!
    
    var allPosts = [Post]()
    var currentCat: Post? = nil
    var catIteration = 0
    var redditPage = Int(arc4random_uniform(100))
    var previousCats = [Post]()
    var previousCatsIteration = 0

    @IBOutlet weak var saveButtonText: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveButtonText.layer.cornerRadius = 6
        self.previousButton.layer.cornerRadius = 6
        self.nextButton.layer.cornerRadius = 6
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeftGesture.direction = .left
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRightGesture.direction = .right
        self.view.addGestureRecognizer(swipeRightGesture)
        
        getAllCats()
    }
    @IBAction func swipeLeft(_ sender: Any) {
        if self.catIteration == self.previousCatsIteration || self.previousCatsIteration == self.previousCats.count - 1 {
            self.loadNextCat()
        } else {
            self.currentCat = self.previousCats[previousCatsIteration + 1]
            self.loadCatPic(urlString: self.currentCat!.imageURL)
            self.previousCatsIteration += 1
            print("going forward to cat \(self.previousCatsIteration) of \(self.previousCats.count)")
        }
    }

    @IBAction func swipeRight(_ sender: Any) {
        if self.previousCatsIteration == self.previousCats.count {
            self.previousCatsIteration -= 1
            self.loadPreviousCat()
        } else {
            self.loadPreviousCat()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var catImageView: UIImageView!

    func loadCatPic(urlString: String) {
        catImageView.af_setImage(withURL: URL(string: urlString)!, placeholderImage: #imageLiteral(resourceName: "Loading Icon v2"))
    }
    
    @IBAction func nextCatTapped(_ sender: Any) {
        if self.catIteration == self.previousCatsIteration || self.previousCatsIteration == self.previousCats.count - 1 {
            self.loadNextCat()
        } else {
            self.currentCat = self.previousCats[previousCatsIteration + 1]
            self.loadCatPic(urlString: self.currentCat!.imageURL)
            self.previousCatsIteration += 1
            print("going forward to cat \(self.previousCatsIteration) of \(self.previousCats.count)")
        }
    }
    
    @IBAction func previousCatTapped(_ sender: Any) {
        if self.previousCatsIteration == self.previousCats.count {
            self.previousCatsIteration -= 1
            self.loadPreviousCat()
        } else {
        self.loadPreviousCat()
        }
    }
    
    func loadNextCat() {
        
        if catIteration == self.allPosts.count {
            self.redditPage += 1
            self.catIteration = 0
            getAllCats()
        }
        
        self.previousCatsIteration += 1
        
        self.currentCat = self.allPosts[catIteration]
        
        self.loadCatPic(urlString: self.currentCat!.imageURL)
        
        self.previousCats.append(currentCat!)
        
        print("Cat \(catIteration) of \(self.allPosts.count) on page \(self.redditPage)")
        
        self.catIteration += 1
    }
    
    func loadPreviousCat() {
        if previousCatsIteration > 0{
            self.currentCat = self.previousCats[previousCatsIteration - 1]
            self.loadCatPic(urlString: self.currentCat!.imageURL)
            self.previousCatsIteration -= 1
            print("going back to cat \(self.previousCatsIteration) of \(self.previousCats.count)")
        } else {
            return
        }
    }
    
    func getAllCats() {
        let apiToContact = "https://api.imgur.com/3/gallery/r/dankmemes/\(redditPage)"
        let parameters = ["Authorization" : "Client-ID \(Constants.ImgurAPI.clientID)"]
        
        Alamofire.request(apiToContact, headers: parameters).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let allPostsData = json["data"].arrayValue
                    self.allPosts = []
                    
                    for postIteration in allPostsData {
                        let post = Post(json: postIteration)
                        if !post.imageURL.contains(".jpg") {
                            continue
                        } else {
                            self.allPosts.append(post)
                        }
                    }
                    self.allPosts.shuffle()
                    self.loadNextCat()
                }
                
            case .failure(let error):
                print(error)
                debugPrint(response)
            }
        }

    }
    @IBAction func saveButtonTapped(_ sender: Any) {
//        UIImageWriteToSavedPhotosAlbum(self.catImageView.image!, nil, nil, nil)
//        self.currentCat!.isSaved = true
//        let alert = UIAlertController(title: "Nice Cat!", message: "That cool cat has been saved to your camera roll!", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Nice!", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        
        let image = self.catImageView.image!
        
        let objectsToShare = [ "Look at this cool cat!" , image ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.openInIBooks]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

