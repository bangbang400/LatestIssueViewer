//
//  SettingDetailViewController.swift
//  latest-issue-viewer
//
//  Created by BangBang on 2022/06/06.
//

import UIKit
import RealmSwift

class SettingDetailViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var countDatePicker: UIPickerView!
    @IBOutlet weak var countDateLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    
    var countDatePickerRow: Int = 0
    var countDateList:[String]!
    
    // Realmインスタンスを取得
    let realm = try! Realm()
    // 通知するデータを保存する
    var notificationDataObj:Results<Favorite>!
    var notificationDataList:List<Favorite>!
    
    // 発売日通知日をUserDefaultsで保存する
    let countDateUD = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countDatePicker.dataSource = self
        countDatePicker.delegate = self
        //　通知用リスト
        notificationDataList = realm.objects(FavoriteList.self).first?.notifiList
        // ボタンのデザイン
        settingButton.backgroundColor = UIColor(hex: "00bfff") //背景色 00bfff[deepskyblue]
        settingButton.tintColor = .white //文字色
        settingButton.layer.cornerRadius = 10 //角
        // UserDefaultsの参照
        let notifiDate = countDateUD.object(forKey: "notifiDate") as? Int ?? 1
        // pickerの初期値
        countDatePicker.selectRow(notifiDate, inComponent: 0, animated: false)
    }
    
    // ドラムロールのタイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return countDateList[row]
        default:
            return "error"
        }
    }
    
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countDateList.count
    }
    
    // ドラムロールの選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        countDateUD.set(row, forKey: "notifiDate")
        // ドラムロールの行番号を設定する
        countDatePickerRow = row
    }
    
    // ドラムロールの行の高さ
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    //　設定ボタンを押下した際の挙動
    @IBAction func settingButtonAction(_ sender: Any) {
        // UserDefaultsに保存する
        countDateUD.set(countDatePickerRow, forKey: "notifiDate")
        // 新刊発売日を設定すべきリストを取得
        Notification().getNotificationData()
        // ローカルプッシュ通知を設定する
        Notification().notificationAction(countDatePickerRow)
        // 戻る NavigationControllerの管理下にある場合
        self.navigationController?.popViewController(animated: true)
    }
}
