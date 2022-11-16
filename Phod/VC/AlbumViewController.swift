//
//  AlbumViewController.swift
//  Phod
//
//  Created by 鳥山彰仁 on 2022/11/09.
//


import UIKit
import Alamofire
import Kingfisher
import KeychainAccess


//class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    class AlbumViewController: UIViewController {
    
    let consts = Constants.shared
    var user: User!
    var phods: [Phod] = []
    

    var imageArray : Array<UIImage> = []

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private let collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
//        collectionView.delegate = self
//        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        // 画像を配列に格納
        while let attackImage = UIImage(named: "\(imageArray.count+1)") {
            imageArray.append(attackImage)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //APIのユーザー情報を取得
        getUser()
        //APIのカメラ情報を取得
        requestIndex()

    }
    
    
    //==================== API始まり ====================//
    
    //user情報
    func getUser() {
        let url = URL(string: consts.baseUrl + "/api/user")!
        let headers: HTTPHeaders = [
            .authorization(bearerToken: consts.token),
            .accept("application/json")
        ]
        AF.request(
            url,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: User.self){ response in
            switch response.result {
            case .success(let user):
                self.user = user
                print("ログインユーザー(\(self.user.name))")
//                self.label.text = self.user.name
            case .failure(let err):
                print(err)
            }
        }
    }
    
    
    //phodos情報
    func requestIndex(){
        let url = URL(string: consts.baseUrl + "/api/phods")!
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .accept("application/json"),
            .authorization(bearerToken: consts.token)
        ]
        print("Alamofireでリクエスト")
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: Album.self) { response in
            switch response.result {
            case .success(let phods):
                print("レスポンス")
                if let phod = phods.data {
                    self.phods = phod
                    print(self.phods)
//                    print(self.phods.first?.place)
                    //self.collectionView.reloadData()
                    print(phods.data?.count)
                    self.imageView.kf.setImage(with: URL(string: "self.phods.first!.imageUrl"))
                    
//                    self.imageView.kf.setImage(with: URL(string: self.phods.))
                  
                } else {
                    print("データが入っていません")
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    //==================== API終わり ====================//
    
   
    
   
    
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionView.frame = view.bounds
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imageArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath)
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(
//            width: (view.frame.size.width/3)-3,
//            height: (view.frame.size.width/3)-3
//        )
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
//        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
//    }
//
//    //画像をタップ
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        print("Selected section \(indexPath.section) and row \(indexPath.row)")
//    }
    
}

