//
//  InventoryTableCell.swift
//  lifeline
//
//  Created by iSteer on 27/03/17.
//  Copyright © 2017 iSteer. All rights reserved.
//

import UIKit

class InventoryTableCell: UITableViewCell {

    @IBOutlet weak var collectionViewInventory: UICollectionView!
     var post:[String]?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionViewInventory.register(UINib(nibName : "InventoryCell",bundle : nil), forCellWithReuseIdentifier: "InventoryCell")
        
        collectionViewInventory.delegate = self
        collectionViewInventory.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension InventoryTableCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        
        cell.lblInventoryData.text = post?[indexPath.row]
        if ( indexPath.row % 2 != 0)
        {
           cell.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}

