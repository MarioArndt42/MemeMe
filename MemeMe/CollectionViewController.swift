//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Mario Arndt on 10.04.22.
//

import UIKit

class CollectionViewController: UICollectionViewController  {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // Load Saved Memes
    var memes: [Meme]! {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            return appDelegate.memes
        }
        
    @IBAction func buttonPressed(_ sender: UIButton) {
        showEditor(self)
    }
    
    // TextFields attributes white with a black outline
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
          .strokeColor: UIColor.black,
          .foregroundColor: UIColor.white,
          .font: UIFont(name: "HelveticaNeue-CondensedBlack", size:16)!,
          .strokeWidth: -4
      ]
       
       // MARK: lifecycle methods
       
       override func viewDidLoad() {
           super.viewDidLoad()
           collectionView.delegate = self
           collectionView.dataSource = self
                     
            // Number of cells/rows standard
            var numberOfCellsPerRow = 3.0
            if UIApplication.shared.statusBarOrientation.isLandscape {
                // Number of cells/rows landscape mode
                numberOfCellsPerRow = 5.0
            }
            
            // Organize layout of collection view
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1) * horizontalSpacing) / numberOfCellsPerRow
             
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
              
       override func viewWillAppear(_ animated: Bool) {
           collectionView!.reloadData()
           print("********CollectionView")
       }
    
       override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            collectionView?.reloadData()
       }
       
       // MARK: collection methods
       
       // Number of memes
       override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           print(memes.count)
           return memes.count
       }
       
       // Create a cell for each meme
       override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                  
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
           let meme = self.memes[(indexPath as NSIndexPath).row]
           
           // Collection view cells
           cell.imageView?.image = meme.originalImage
           cell.topLabel?.attributedText = NSAttributedString (string: meme.topText, attributes: memeTextAttributes)
           cell.bottomLabel?.attributedText = NSAttributedString (string: meme.bottomText, attributes: memeTextAttributes)
           
           return cell
       }
       
       // Select tapped meme and show it in detail
       override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
           let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
           detailController.meme = self.memes[(indexPath as NSIndexPath).row]
           self.navigationController!.pushViewController(detailController, animated: true)
       }
    
     // call meme editor
     func showEditor(_ sender: Any) {
         
         let editController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
         self.present(editController, animated: true, completion: nil)
         
         // Editor closed -> Reload memes in collection view
         editController.isDismissed = { [weak self] in
             self?.collectionView.reloadData()
         }
     }       
}

