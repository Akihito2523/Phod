//
//  AddListViewController.swift
//  TableViewApp
//
//  Created by 鳥山彰仁 on 2022/10/16.
//

import UIKit

class AddListViewController: UIViewController {
    
    //テキスト
    @IBOutlet weak var addText: UITextField!
    //空テキスト
    @IBOutlet weak var emptyText: UILabel!
    //入力したリストを格納する配列
    var taskArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let userDefaults = UserDefaults.standard
//        //"add"というキーで保存された値がなにかある -> 値をtaskArrayへ
//        if userDefaults.object(forKey: "add") != nil {
//            taskArray = userDefaults.object(forKey: "add") as! [String]
//        }
        
    }
    
    //追加ボタン
    @IBAction func addTask(_ sender: Any) {
//        //(UserDefaults.standard)小さなデータベース
//        let userDefaults = UserDefaults.standard
//
//        //テキストが空でなければ
//        if addText.text != "" {
//            taskArray.append(addText.text!)
//            //キー"add"で配列をUserDefaultsに保存
//            userDefaults.set(taskArray, forKey: "add")
//            //1つ前の画面に戻る
//            self.navigationController?.popViewController(animated: true)
//        } else {
//            //0.5秒後に文字を入力してくださいを表示する
//            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {_ in
//                self.emptyText.text = "文字を入力してください"
//                //3秒後に文字を消す
//                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {_ in
//                    self.emptyText.text = ""
//                }
//            }
//        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
