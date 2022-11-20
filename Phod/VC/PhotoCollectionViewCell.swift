//
//  PhotoCollectionViewCell.swift
//  CollectionViews
//
//  Created by 鳥山彰仁 on 2022/11/08.
//

import UIKit
import AVFoundation
import AuthenticationServices
import Alamofire
import KeychainAccess


class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    let consts = Constants.shared
    var user: User!
    var phods: [Phod] = []
    
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        let images = [
        UIImage(named: "1"),
        UIImage(named: "2"),
        UIImage(named: "3"),
        UIImage(named: "4"),
        UIImage(named: "5"),
        UIImage(named: "6"),
        ].compactMap({ $0 })
        imageView.image = images.randomElement()
    }
    
    
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //スクロールしても画像のトップがおさまる
        //imageView.image = nil
    }
    
    
}
