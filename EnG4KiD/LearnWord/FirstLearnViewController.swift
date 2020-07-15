//
//  FirstLearnViewController.swift
//  EnG4KiD
//
//  Created by MacPro An Lê on 3/16/20.
//  Copyright © 2020 An Lê. All rights reserved.
//

import UIKit
import AVFoundation

class FirstLearnViewController: UIViewController {
    
    var wordInVocabulary:VocabularyTable!

    @IBOutlet weak var imgWordBG: UIImageView!
    
    @IBOutlet weak var visualEffectWordBG: UIVisualEffectView!
    
    @IBOutlet weak var btnHearArrWord: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btn1: UIButton!
    
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var btn3: UIButton!
    
    @IBOutlet weak var btn4: UIButton!
    
    @IBOutlet weak var lblCompleteRound1: UILabel!
    
    @IBOutlet weak var lblCompleteRound2: UILabel!
    
    @IBOutlet weak var viewCompleteRound1: UIView!
    
    @IBOutlet weak var viewCompleteRound2: UIView!
    
    //Constraint LblCorrectly
    private var lblCorrectly: UILabel!
    private var topLblCorrectly: NSLayoutConstraint!
    private var bottomLblCorrectly: NSLayoutConstraint!
    private var leadingLblCorrectly: NSLayoutConstraint!
    private var trailingLblCorrectly: NSLayoutConstraint!
    //Constaint Animation
    private var topLblCorrectlyAnim: NSLayoutConstraint!
    private var bottomLblCorrectlyAnim: NSLayoutConstraint!
    private var leadingLblCorrectlyAnim: NSLayoutConstraint!
    private var trailingLblCorrectlyAnim: NSLayoutConstraint!
    
    //Data
    private var arrWord: [String]!
    private var wordMain: String!
    
    //SlowerSpeakArrWord
    var timer:Timer!
    
    let languageVoiceAccent = AVSpeechSynthesisVoice(language: "en-US")
    let synthesizer = AVSpeechSynthesizer()
    
    var check: Int = 0
    
    var audioPlayer: AVAudioPlayer?
    let pathCorrectSound = Bundle.main.path(forResource: "correctSound", ofType: "wav")
    let pathWrongSound = Bundle.main.path(forResource: "wrongSound", ofType: "wav")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editView()
        createLableCorrectly()
        constraintLblCorrectly()
        
        let vcDetailWord = DetailWordViewController()
        vcDetailWord.receiveArrWord(escapeClosure: { arrWord,vocaObj in
            self.wordInVocabulary = vocaObj
            self.arrWord = arrWord
            
            self.wordMain = self.wordInVocabulary.engWord
            self.imgWordBG.image = UIImage(data: self.wordInVocabulary.imgWord ?? Data()) ?? UIImage()
        })
        
        self.triggerSendData?(vcDetailWord)
        /*if #available(iOS 13.0, *) { // Disable swiping downward on iOS 13 or newer of device
         
            self.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }*/
        // Do any additional setup after loading the view.
    
    }
    
    var triggerSendData: ((UIViewController) ->Void)?
    
    func waitingForSendData(escapeClosure: @escaping(UIViewController)-> Void ){
        self.triggerSendData = escapeClosure
    }
    
    func editView(){
        self.btn1.layer.cornerRadius = 10
        self.btn2.layer.cornerRadius = 10
        self.btn3.layer.cornerRadius = 10
        self.btn4.layer.cornerRadius = 10
    }
    
    @IBAction func tapToHearArrWord(_ sender: Any) {
        var utterance:AVSpeechUtterance = AVSpeechUtterance()
        utterance.voice = self.languageVoiceAccent
        /*for i in 0..<self.arrWord.count{
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: { _ in
                utterance = AVSpeechUtterance(string: self.arrWord[i])
                self.synthesizer.speak(utterance)
            })
            //DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {}) //Sau 3 giay se thuc thu doan code trong excute:
        }*/
        
        var countForStop = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true, block: { _ in
            utterance = AVSpeechUtterance(string: self.arrWord[countForStop])
            self.synthesizer.speak(utterance)
            countForStop += 1
            if countForStop > self.arrWord.count - 1{
                self.timer.invalidate()
            }
        })
    }
    
    func createLableCorrectly(){
        self.lblCorrectly = UILabel(frame: CGRect(x: self.view.frame.width, y: 0, width: 92, height: 120))
        self.lblCorrectly.contentMode = .center
        self.lblCorrectly.textAlignment = .center
        self.lblCorrectly.text = "✓"
        self.lblCorrectly.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        self.lblCorrectly.textColor = UIColor.green
        self.lblCorrectly.adjustsFontSizeToFitWidth = true
        self.lblCorrectly.numberOfLines = 1
    }
    
    func constraintLblCorrectly(){
        self.lblCorrectly.translatesAutoresizingMaskIntoConstraints = false
        
        //Constraint animationMoveToStackView
        self.topLblCorrectlyAnim = NSLayoutConstraint(item: self.lblCorrectly ?? UILabel(), attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 792/862, constant: 0)
        self.bottomLblCorrectlyAnim = NSLayoutConstraint(item: self.lblCorrectly ?? UILabel(), attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 822/862, constant: 0)
        self.leadingLblCorrectlyAnim = NSLayoutConstraint(item: self.lblCorrectly ?? UILabel(), attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 100/414, constant: 0)
        self.trailingLblCorrectlyAnim = NSLayoutConstraint(item:  self.view.safeAreaLayoutGuide, attribute: .trailing, relatedBy: .equal, toItem: self.lblCorrectly ?? UILabel() , attribute: .trailing, multiplier: 414/207, constant: 0)
        
        //Constraint centerScreen
        self.topLblCorrectly = NSLayoutConstraint(item: self.lblCorrectly ?? UILabel(), attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 388/862, constant: 0)
        self.bottomLblCorrectly = NSLayoutConstraint(item: self.lblCorrectly ?? UILabel(), attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 508/862, constant: 0)
        self.leadingLblCorrectly = NSLayoutConstraint(item: self.lblCorrectly ?? UILabel(), attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 161/414, constant: 0)
        self.trailingLblCorrectly = NSLayoutConstraint(item:  self.view.safeAreaLayoutGuide, attribute: .trailing, relatedBy: .equal, toItem: self.lblCorrectly ?? UILabel() , attribute: .trailing, multiplier: 414/253, constant: 0)
        
    }
    
    func animationMoveLblCorrectlyToStackView(){       self.view.removeConstraints([self.topLblCorrectly,self.bottomLblCorrectly,self.leadingLblCorrectly,self.trailingLblCorrectly])
        self.lblCorrectly.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        self.view.addConstraints([self.topLblCorrectlyAnim,self.bottomLblCorrectlyAnim,self.leadingLblCorrectlyAnim,self.trailingLblCorrectlyAnim])
    }
    
    func animationLblCorrectlyAddToView(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [], animations: {
            self.visualEffectWordBG.effect = UIBlurEffect(style: .dark)
            self.view.addSubview(self.lblCorrectly)
            self.view.addConstraints([self.topLblCorrectly,self.bottomLblCorrectly,self.leadingLblCorrectly,self.trailingLblCorrectly])
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.9, execute: {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 4, options: [], animations: {
                self.animationMoveLblCorrectlyToStackView()
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.lblCorrectly.removeFromSuperview()
                self.lblCompleteRound1.text = "✓"
                self.viewCompleteRound1.backgroundColor = UIColor.green
            })
        })
    }
    
    func correctAndWrongSound(bool: Bool) -> Bool{
        if bool {
            do{
                let urlCorrectSound = URL(fileURLWithPath: self.pathCorrectSound ?? "")
                self.audioPlayer = try AVAudioPlayer(contentsOf: urlCorrectSound)
                self.animationLblCorrectlyAddToView()
                self.audioPlayer?.play()
            }catch{
                
            }
        }else{
            do{
                let urlWrongSound = URL(fileURLWithPath: self.pathWrongSound ?? "")
                self.audioPlayer = try AVAudioPlayer(contentsOf: urlWrongSound)
                self.audioPlayer?.play()
            }catch{
                
            }
        }
        return bool
    }
    
    func nextSecondLearn(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.view.bringSubviewToFront(self.visualEffectWordBG)
            //self.view.bringSubviewToFront(self.btnCancel)
            let waitLable = UILabel()
            waitLable.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            waitLable.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            waitLable.text = "Waiting..."
            waitLable.textAlignment = .center
            waitLable.contentMode = .center
            waitLable.translatesAutoresizingMaskIntoConstraints = false
            let centerX = NSLayoutConstraint(item: waitLable, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: waitLable, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            self.view.addSubview(waitLable)
            self.view.addConstraints([centerX,centerY])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                guard let secondLearnVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondLearnVC") as? SecondLearnViewController else {return}
                secondLearnVC.receiceVC(escapeClosure: { vc in
                    guard let thisVc = vc as? FirstLearnViewController else {return}
                    thisVc.sendDataToSecondLearn?(self.wordInVocabulary)
                })
                self.navigationController?.pushViewController(secondLearnVC, animated: true)
            })
        })
    }
    
    var sendDataToSecondLearn: ((VocabularyTable) ->Void)?
    
    func receiveData(escapeClosure: @escaping (VocabularyTable) ->Void ){
        sendDataToSecondLearn = escapeClosure
    }
    
    
    @IBAction func tapBtn1(_ sender: Any) {
        check = 0
        if correctAndWrongSound(bool: check == self.arrWord.firstIndex(of: self.wordMain)){
            self.btn1.backgroundColor = UIColor.green
            nextSecondLearn()
        }else{
            self.btn1.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func tapBtn2(_ sender: Any) {
        check = 1
        if correctAndWrongSound(bool: check == self.arrWord.firstIndex(of: self.wordMain)){
            self.btn2.backgroundColor = UIColor.green
            nextSecondLearn()
        }else{
            self.btn2.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func tapBtn3(_ sender: Any) {
        check = 2
        if correctAndWrongSound(bool: check == self.arrWord.firstIndex(of: self.wordMain)){
            self.btn3.backgroundColor = UIColor.green
            nextSecondLearn()
        }else{
            self.btn3.backgroundColor = UIColor.red
        }
        
    }
    
    @IBAction func tapBtn4(_ sender: Any) {
        check = 3
        if correctAndWrongSound(bool: check == self.arrWord.firstIndex(of: self.wordMain)){
            self.btn4.backgroundColor = UIColor.green
            nextSecondLearn()
        }else{
            self.btn4.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func cancelThisVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
