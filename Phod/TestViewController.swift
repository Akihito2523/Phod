////
////  TestViewController.swift
////  Phod
////
////  Created by 鳥山彰仁 on 2022/11/12.
////
//
//import UIKit
//import Alamofire
//import KeychainAccess
//
//class TestViewController: UIViewController {
//
//    private var token = ""
//    let consts = Constants.shared
//
//    @IBOutlet weak var imageView: UIImageView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //token読み込み
//        token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiY2IyMWVlY2YzNjY5M2E4NzRmOTM4ZDNkMTBlY2M3NDViN2NjZTFhYzE0MWY0NzY2NmNjZmYwZTY5NmM1YTliMGQxZjc5ODg2ZWVjMDIwN2UiLCJpYXQiOjE2NjgyMTY4MjIuNDIyMjM4LCJuYmYiOjE2NjgyMTY4MjIuNDIyMjQxLCJleHAiOjE2OTk3NTI4MjIuMzc1MDA0LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.NuWYdraNTzKQn2zzEtIfohdH0Agrj_yuzfqoHusIdu7JsX8Qs4eEMQIaUZrF2GrJxwNOofGJgeb8Rx97pp7BBLoT0111F3xK6u404yR_pcYuNCKczgivGWX_EyQ0QhSEGP4QAygSeTA9DzxTCH029NtH2pzMSyK8xfXrhng4dkSSQ_Z-jxpUVHYU19H1WNX0i5MPlXfAcGQC1x01tfLxI11Dwi0oON2eJNDxIT3T_tf8-gAAh9nhIrsUv0q4UuqOzTP5iOsfirqCyhyUosxNVF4-xQTpue1iYLJvXm2vBOhF8IEb2LB5cm_M02d2EOHiy8I2yaijHgsMud-bMqLWCNtyhLQFNV6IBg9ZqgBZVPYvwAv1oIBrDgYkAW6p0MNF4yQQmihPGtFzp-PH6MUVNLeGMd3Id4jyTD1ekfMOneKC3gF2kjlLqLrjfty1p1mpxKnop_6vaug3q2tVyB8K9cF-iykvJcTWcudYBE0GQVnMJNMi9zGQjb37dO0Pzq15cyYPZbqm1KTK6fv-Ymv9Urnw4__5IQutxRUxLxkLAGQIX18WRahLABsETsy6WZT4mKZmf9p3qNIEK8fU0sMhEQ4Z3YaIANzxgHrQlZ7dLZopay2tV88ehZUdDfVu2b7Bslq2WWWQaG52eJ8YZjxHqb1jYm54AzS0V66dnk7Z05s"
//    }
//
//    //写真送信
//    @IBAction func photoSend(_ sender: Any) {
//        if  imageView.image != nil {
//            createRequest(token: token, image: imageView.image!)
//            print("写真送信完了")
//        } else {
//            print("写真送信エラー")
//        }
//    }
//
//
//    //投稿のリクエスト
//    func createRequest(token: String, image: UIImage) {
//        guard let url = URL(string: consts.baseUrl + "/api/phods") else { return }
//        //画像データを圧縮してデータ型に変換
//        guard let imageData = image.jpegData(compressionQuality: 0.01) else {return}
//
//        let headers: HTTPHeaders = [
//            .authorization(bearerToken: token),
//            .accept("application/json"),
//            .contentType("multipart/form-data")
//        ]
//
//        //文字情報と画像やファイルを送信するときは 「AF.upload(multipartFormData: …」 を使う
//        AF.upload(
//            //multipartFormDataにappendで送信したいデータを追加していく
//            multipartFormData: { multipartFormData in
//                //image,title,bodyを送信
//                multipartFormData.append(imageData, withName: "image", fileName: ".jpg")
//                //guard let titleTextData = self.titleTextField.text?.data(using: .utf8) else {return}
//                multipartFormData.append("本番title".data(using: .utf8)!, withName: "title")
//                multipartFormData.append("テストbody".data(using: .utf8)!, withName: "body")
//            },
//            to: url,
//            //uploadはデフォルトがPOSTメソッドなので省略可能
//            method: .post,
//            headers: headers
//        ).response { response in
//            switch response.result {
//            case .success:
//                print("レスポンスきてます")
//
//            case .failure(let err):
//                print("ERROR:", err)
//                // self.okAlert.showOkAlert(title: "エラー!", message: "\(err)", viewController: self)
//            }
//        }
//    }
//}
