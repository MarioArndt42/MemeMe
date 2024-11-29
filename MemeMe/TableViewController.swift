//
//  TableViewController.swift
//  MemeMe
//
//  Created by Mario Arndt on 09.03.22.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    // Load saved memes
    var memes: [Meme]! {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            return appDelegate.memes
        }

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Height of table view cell
        tableView.rowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // Create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Set separator style
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemeCustomCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Concatenate top and bottom texts
        cell.memeLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        
        // Table view cells
        cell.memeView?.image = meme.originalImage
        cell.topLabel?.attributedText = NSAttributedString (string: meme.topText, attributes: memeTextAttributes)
        cell.bottomLabel?.attributedText = NSAttributedString (string: meme.bottomText, attributes: memeTextAttributes)
        
        return cell
    }
              
    // Select tapped meme and show it in detail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // call meme editor
     func showEditor(_ sender: Any) {
         
         let editController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
         self.present(editController, animated: true, completion: nil)
         
         // Editor closed -> Reload memes in table
         editController.isDismissed = { [weak self] in
             self?.tableView.reloadData()
         }
     }
}
    
    
