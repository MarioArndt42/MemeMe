//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Mario Arndt on 25.03.22.
//

import UIKit

class DetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var detailImage: UIImageView!
    
    // Show selected meme
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailImage!.image = meme.memedImage
    }
}
