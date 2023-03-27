//
//  ViewController.swift
//  Concurrency
//
//  Created by Rita Marrano on 27/03/23.
//

import Foundation
import UIKit
import FirebaseStorage



class ViewController: UIViewController {

    // Reference to Firebase Storage
    let storage = Storage.storage()

    // Array to store downloaded images
    var images = [UIImage]()

    // Create a scroll view to display images
    let scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the scroll view
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)

        // Fetch images from Firebase Storage folder
        let reference = storage.reference(withPath: "images/")
        reference.listAll { [weak self] (result, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching images: \(error.localizedDescription)")
                return
            }
            for item in result!.items {
                // Download image using GCD to prevent blocking the main thread
                DispatchQueue.global(qos: .userInitiated).async {
                    item.getData(maxSize: 10 * 1024 * 1024) { [weak self] (data, error) in
                        guard let self = self, let data = data, error == nil else { return }
                        if let image = UIImage(data: data) {
                            // Append downloaded image to array
                            self.images.append(image)
                            // Update UI on the main thread
                            DispatchQueue.main.async {
                                self.updateScrollView()
                            }
                        }
                    }
                }
            }
        }
    }

    // Helper method to update the scroll view with downloaded images
    func updateScrollView() {
        for i in 0..<images.count {
            let imageView = UIImageView(image: images[i])
            let x = CGFloat(i) * scrollView.frame.width
            imageView.frame = CGRect(x: x, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(images.count), height: scrollView.frame.height)
    }
}
