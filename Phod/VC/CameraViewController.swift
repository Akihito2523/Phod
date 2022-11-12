//
//  CameraViewController.swift
//  Phod
//
//  Created by 鳥山彰仁 on 2022/11/09.
//

import UIKit
//import Foundation
import AVFoundation
import AuthenticationServices
import Alamofire
import KeychainAccess



class CameraViewController: UIViewController {
    
    
    
    //Constantsに格納しておいた定数を使うための用意
    let consts = Constants.shared
    //Webの認証セッションを入れておく変数
    var session: ASWebAuthenticationSession?
    //読み込んできたアクセストークンを格納しておく変数
    private var token = ""
    
    
    
    
    
    var articles: [Phod] = []
    var user: User!
    
    // カメラ表示用imageview
    @IBOutlet weak var CameraImageView: UIImageView!
    //カメラボタンプロパティ
    @IBOutlet weak var cameraButton: UIButton!
    //@IBOutlet weak var changeModeSegmentControl: UISegmentedControl!
    
    
    // デバイスからの入力と出力を管理するオブジェクトの作成
    var captureSession = AVCaptureSession()
    // メインカメラの管理オブジェクトの作成
    var mainCamera: AVCaptureDevice?
    // インカメの管理オブジェクトの作成(iPhoneのカメラデバイス)
    var innerCamera: AVCaptureDevice?
    // 現在使用しているカメラデバイスの管理オブジェクトの作成
    var currentDevice: AVCaptureDevice?
    // キャプチャーの出力データを受け付けるオブジェクト
    var photoOutput : AVCapturePhotoOutput?
    // プレビュー表示用のレイヤ
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    
    
    override func viewWillAppear(_ animated: Bool) {
//        requestIndex()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //token読み込み
        token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzIiwianRpIjoiY2IyMWVlY2YzNjY5M2E4NzRmOTM4ZDNkMTBlY2M3NDViN2NjZTFhYzE0MWY0NzY2NmNjZmYwZTY5NmM1YTliMGQxZjc5ODg2ZWVjMDIwN2UiLCJpYXQiOjE2NjgyMTY4MjIuNDIyMjM4LCJuYmYiOjE2NjgyMTY4MjIuNDIyMjQxLCJleHAiOjE2OTk3NTI4MjIuMzc1MDA0LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.NuWYdraNTzKQn2zzEtIfohdH0Agrj_yuzfqoHusIdu7JsX8Qs4eEMQIaUZrF2GrJxwNOofGJgeb8Rx97pp7BBLoT0111F3xK6u404yR_pcYuNCKczgivGWX_EyQ0QhSEGP4QAygSeTA9DzxTCH029NtH2pzMSyK8xfXrhng4dkSSQ_Z-jxpUVHYU19H1WNX0i5MPlXfAcGQC1x01tfLxI11Dwi0oON2eJNDxIT3T_tf8-gAAh9nhIrsUv0q4UuqOzTP5iOsfirqCyhyUosxNVF4-xQTpue1iYLJvXm2vBOhF8IEb2LB5cm_M02d2EOHiy8I2yaijHgsMud-bMqLWCNtyhLQFNV6IBg9ZqgBZVPYvwAv1oIBrDgYkAW6p0MNF4yQQmihPGtFzp-PH6MUVNLeGMd3Id4jyTD1ekfMOneKC3gF2kjlLqLrjfty1p1mpxKnop_6vaug3q2tVyB8K9cF-iykvJcTWcudYBE0GQVnMJNMi9zGQjb37dO0Pzq15cyYPZbqm1KTK6fv-Ymv9Urnw4__5IQutxRUxLxkLAGQIX18WRahLABsETsy6WZT4mKZmf9p3qNIEK8fU0sMhEQ4Z3YaIANzxgHrQlZ7dLZopay2tV88ehZUdDfVu2b7Bslq2WWWQaG52eJ8YZjxHqb1jYm54AzS0V66dnk7Z05s"
        
        
        self.styleCaptureButton()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
   
    
    
    
    @IBAction func cameraButtonTaped(_ sender: Any) {
        print("シャッターボタンが押されました。")
        let settings = AVCapturePhotoSettings()
        // フラッシュの設定
        settings.flashMode = .auto
        // カメラの手ぶれ補正
        //settings.isAutoStillImageStabilizationEnabled = true
        // 撮影された画像をdelegateメソッドで処理
        self.photoOutput?.capturePhoto(with: settings, delegate: self as! AVCapturePhotoCaptureDelegate)
        
        
//        if  CameraImageView.image != nil {
//            createRequest(token: token, image: CameraImageView.image!)
//            print("写真送信完了")
//        } else {
//            print("送信エラー")
//        }
        
    }
    
    
    //投稿のリクエスト
    func createRequest(token: String, image: UIImage) {
        guard let url = URL(string: consts.baseUrl + "/api/phods") else { return }
        //画像データを圧縮してデータ型に変換
        guard let imageData = image.jpegData(compressionQuality: 0.01) else {return}
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json"),
            .contentType("multipart/form-data")
        ]
        
        //文字情報と画像やファイルを送信するときは 「AF.upload(multipartFormData: …」 を使う
        AF.upload(
            //multipartFormDataにappendで送信したいデータを追加していく
            multipartFormData: { multipartFormData in
                //image,title,bodyを送信
                multipartFormData.append(imageData, withName: "image", fileName: ".jpg")
                //guard let titleTextData = self.titleTextField.text?.data(using: .utf8) else {return}
                multipartFormData.append("テストtitle".data(using: .utf8)!, withName: "title")
                multipartFormData.append("テストbody".data(using: .utf8)!, withName: "body")
            },
            to: url,
            //uploadはデフォルトがPOSTメソッドなので省略可能
            method: .post,
            headers: headers
        ).response { response in
            switch response.result {
            case .success:
                print("レスポンスきてます")
                
            case .failure(let err):
                print("ERROR:", err)
                // self.okAlert.showOkAlert(title: "エラー!", message: "\(err)", viewController: self)
            }
        }
    }
    
    
    
}


//MARK: AVCapturePhotoCaptureDelegateデリゲートメソッド
extension CameraViewController: AVCapturePhotoCaptureDelegate{
    // 撮影した画像データが生成されたときに呼び出されるデリゲートメソッド
    //キャプチャされた画像を受け取る
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        //fileDataRepresentation() を使用することでフォトライブラリに保存することができる
        if let imageData = photo.fileDataRepresentation() {
            // Data型をUIImageオブジェクトに変換
            guard let uiImage = UIImage(data: imageData) else {return}
            
            print("画像取得！")
//            createRequest(token: token, image: uiImage)

            // 写真ライブラリに画像を保存
            UIImageWriteToSavedPhotosAlbum(uiImage, nil,nil,nil)
        }
    }
}

//MARK: カメラ設定メソッド
extension CameraViewController{
    
    // ボタンのスタイルを設定
    func styleCaptureButton() {
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 5
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = min(cameraButton.frame.width, cameraButton.frame.height) / 2
    }
    
    // カメラの画質の設定
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    // デバイスの設定
    func setupDevice() {
        // カメラデバイスのプロパティ設定
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        // プロパティの条件を満たしたカメラデバイスの取得
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                mainCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                innerCamera = device
            }
        }
        // 起動時のカメラを設定
        currentDevice = mainCamera
        
        // 露出とISO感度の初期値設定
        //        do {
        //            try mainCamera!.lockForConfiguration()
        //            defer { mainCamera!.unlockForConfiguration() }
        //            mainCamera!.exposureMode = .autoExpose
        //            mainCamera!.setExposureModeCustom(duration: AVCaptureDevice.currentExposureDuration, iso: AVCaptureDevice.currentISO, completionHandler: nil)
        //        } catch {
        //            print("(error.localizedDescription)")
        //        }
    }
    
    // 入出力データの設定
    func setupInputOutput() {
        do {
            // 指定したデバイスを使用するために入力を初期化
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            // 指定した入力をセッションに追加
            captureSession.addInput(captureDeviceInput)
            // 出力データを受け取るオブジェクトの作成
            photoOutput = AVCapturePhotoOutput()
            // 出力ファイルのフォーマットを指定
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    // カメラのプレビューを表示するレイヤの設定
    func setupPreviewLayer() {
        // 指定したAVCaptureSessionでプレビューレイヤを初期化
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // プレビューレイヤが、カメラのキャプチャーを縦横比を維持した状態で、表示するように設定
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // プレビューレイヤの表示の向きを設定
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        self.cameraPreviewLayer?.frame = view.frame
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
    }
}
