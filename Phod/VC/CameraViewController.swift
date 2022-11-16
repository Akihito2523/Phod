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
    
    //タブ
    @IBOutlet weak var tagView: UILabel!
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
        
        tagView.text = ""
        //スワイプ
        swipe()
        
        self.styleCaptureButton()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
    }
    
    //スワイプ時に実行されるメソッド
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        //スワイプ方向による実行処理をcase文で指定
        switch sender.direction {
        case .up:
            tagView.text = ""
            print("上スワイプ")
        case .down:
            tagView.text = "デフォルトタグ"
            print("下スワイプ")
        default:
            break
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //シャッターボタン
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
        //            createRequest(token: consts.token, image: CameraImageView.image!)
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
                multipartFormData.append("Swiftのtitle".data(using: .utf8)!, withName: "title")
                multipartFormData.append("Swiftのplace".data(using: .utf8)!, withName: "place")
                multipartFormData.append("Swiftのbody".data(using: .utf8)!, withName: "body")
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
            createRequest(token: consts.token, image: uiImage)
            
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
    
    //スワイプ
    func swipe(){
        //上スワイプ用のインスタンスを生成する
        let upSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(CameraViewController.didSwipe(_:))
        )
        upSwipe.direction = .up
        self.view.addGestureRecognizer(upSwipe)
        
        //下スワイプ用のインスタンスを生成する
        let downSwipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(CameraViewController.didSwipe(_:))
        )
        downSwipe.direction = .down
        self.view.addGestureRecognizer(downSwipe)
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


