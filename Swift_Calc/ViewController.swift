//
//  ViewController.swift
//  Swift_Calc
//
//  Created by takusan23 on 2019/06/09.
//  Copyright © 2019 takusan23. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // letは最初だけ代入できる　varは何回でも代入できる
    let tasizan = 100
    let hikizan = 200
    let kakezan = 300
    let warizan = 400
    let goukei = 1000
    let delete = 10
    let ac = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var LabelIntermediate: UILabel! //途中の
    @IBOutlet weak var LabelAnser: UILabel! //合計
    @IBOutlet weak var LabelHugou: UILabel! //符号
    
    // 0-9のボタンクリックしたら下の{}の中のこプログラムが動きます
    @IBAction func TenKeyTouchDown(_ sender: UIButton) {
        //タグをわかりやすいように変数に入れます
        let tag : Int = sender.tag
        //後ろにたす
        // ! はよくわからん。たぶん文字列を強制してる？
        LabelAnser.text = LabelAnser.text! + tag.description
    }
    
    // + - = を押した時に下の{}が動きます
    @IBAction func ClacControllTochDown(_ sender: UIButton) {
        // 上と同じ
        let tag : Int = sender.tag
        
        // 初めての計算。符号Labelが何もなくて合計ボタンと一個消すボタン以外の時の処理（&& tag != goukei && tag != delete は符号Labelに[=,<]が入らないようにするためです。）
        if LabelHugou.text?.description == "" && tag != goukei && tag != delete {
            // 初めての計算
            // 符号のLabelが何もない時にここに来る。何もない時は起動した時、答えを出した時、ACを押した時です
            LabelHugou.text = sender.currentTitle?.description // 符号のLabelを変更する。あとで使う
            LabelIntermediate.text = LabelAnser.text // 下の段に入れた値を上の段に入れる
            LabelAnser.text = "" // 下の段を空にする
        }else{
            // 計算。二回め以降はここが動く
            // なんで2回目？→1回目だけだと足すことも引くこともできないので2回目から計算するようにしている。
            if tag == tasizan || tag == hikizan || tag == kakezan || tag == warizan {
                // 足し算、引き算、掛け算、割り算は関数 calc_func() を動くようにしている。
                // 91行目からの func calc_func() に処理方法が書いてある。
                calc_func()
            }else{
                // 足し算、引き算、掛け算、割り算　以外のボタンを押した時はここに来る
                if tag == delete {
                    // 消すボタンを押したらここに来る
                    if LabelAnser.text!.description.count > 0 {
                        // 下の段が一文字以上あればここが動く .countは文字列の桁数を返してくれる。
                        // 65行目から66行目は一文字消す処理が書いてあるけどぱくったからわからん。
                        let number :NSMutableString = NSMutableString(string: LabelAnser.text!)
                        number.deleteCharacters(in: NSRange(location: number.length - 1, length: 1))
                        LabelAnser.text = number.description // 一文字消した値を入れる
                    }
                }
                if tag == ac {
                    // ACを押したらここに来る
                    // 全てのLabelを空に戻す
                    LabelAnser.text = ""
                    LabelIntermediate.text = ""
                    LabelHugou.text = ""
                }
                if tag == goukei {
                    // 合計ボタン（=）を押したらここに来る
                    calc_func() // 計算する。詳しくは 91行目の func calc_func() 参照。
                    // これいる？→例 1押す→+押す→2押す→=押す→計算できない。最後イコールを押した場合は計算されない(計算する時に使う func calc_fanc() は + - / * 以外で使っていない)ので答えを出す前にもう一回計算している。
                    LabelAnser.text = LabelIntermediate.text //上の段の値を下の段に入れる
                    LabelIntermediate.text = "" // 上の段のLabelを空にする
                    LabelHugou.text = "" // 符号のLabelを空にする。これで次の計算は最初の計算の処理のところになる
                }
            }
        }
    }
    // 計算全般はここでやってる
    // + - * / の四つと = を押した時にここの文が動くようになっている。
    func calc_func(){
        // 万が一上の段のLabelに何も入ってない時（=連打等）の時は何もしない。
        if LabelIntermediate.text?.description != "" {
            let intermediate = Int(LabelIntermediate.text!.description)! // 上の段の数字取得してInt型に変換
            let anser = Int(LabelAnser.text!.description)! // 下の段の数字取得してInt型に変換
            var calc : Int = 0 // 計算結果を入れる変数
            let hugou = LabelHugou.text?.description // 符号を表示しているLabelの文字を取得して変数に入れる
            switch hugou { // 符号判断はswitchを使っている
            case "+":
                // 足し算
                calc = intermediate + anser
                break
            case "-":
                // 引き算
                calc = intermediate - anser
                break
            case "*":
                // 掛け算
                calc = intermediate * anser
                break
            case "/":
                // 割り算
                calc = intermediate / anser
                break
            default:
                break
            }
            LabelIntermediate.text = calc.description // 計算した値（数値）を文字列に変換して上の段に入れる
            LabelAnser.text = "" // 下の段を消す
        }
    }
    
    // おまけ。共有できるようにする
    @IBAction func ShareButtonTouchDown(_ sender: UIBarButtonItem) {
        // 下のLabelの値があることを確認
        if LabelAnser.text!.description != "" {
            let share_text = "答え : " + LabelAnser.text!.description  // 共有する文字を変数に入れる
            let ui_activity = UIActivityViewController(activityItems: [share_text], applicationActivities: nil) // 準備
            present(ui_activity,animated: true,completion: nil) // 表示する。
        }
        
    }
    
    // おまけその2。答えから消費税計算
    @IBAction func AddButtonTouchDown(_ sender: UIBarButtonItem) {
        // 通知(アラート)作成
        let alert : UIAlertController = UIAlertController(title: "その他の機能", message: "下から選んでね", preferredStyle: UIAlertController.Style.actionSheet)
        // 消費税ボタン
        let tax_button : UIAlertAction = UIAlertAction(title: "消費税", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction) in
            // 押したらここが動く。書き方慣れない
            let anser : Float = Float(self.LabelAnser.text!.description)! // 下のLabelをFloatに変換する
            let tax = anser * 1.08 // 1.08かける
            self.LabelAnser.text = round(tax).description // 掛けた値を下のLabelに入れる
        })
        // 2進数変換
        let sinsu_button : UIAlertAction = UIAlertAction(title: "二進数へ変換", style: UIAlertAction.Style.default,handler : { (action:UIAlertAction) in
            // 押したらここが動く。書き方慣れない
            let anser : Int = Int(self.LabelAnser.text!.description)! // 下のLabelをIntに変換する
            let sinsu = String(anser,radix: 2) // 2進数変換
            self.LabelAnser.text = sinsu.description // 変換した値を下のLabelに入れる
        })
        // キャンセルボタン
        let cancel : UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        // 通知にボタン追加する
        alert.addAction(tax_button)
        alert.addAction(cancel)
        alert.addAction(sinsu_button)
        // 通知を表示する
        present(alert,animated: true,completion: nil)
    }
}


