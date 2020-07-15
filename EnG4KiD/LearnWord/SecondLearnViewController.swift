//
//  SecondLearnViewController.swift
//  EnG4KiD
//
//  Created by MacPro An Lê on 3/16/20.
//  Copyright © 2020 An Lê. All rights reserved.
//

import UIKit
import AVFoundation

class SecondLearnViewController: UIViewController {
    
    var wordInVocabulary: VocabularyTable!
    
    var learnCompleted: Bool = false
    
    var preLearnState:Bool!

    @IBOutlet weak var visualEffectBG: UIVisualEffectView!
    @IBOutlet weak var imgBG: UIImageView!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblCompleteRound1: UILabel!
    
    @IBOutlet weak var lblCompleteRound2: UILabel!
    
    @IBOutlet weak var viewCompleteRound1: UIView!
    
    @IBOutlet weak var viewCompleteRound2: UIView!
    
    @IBOutlet weak var imgMain: UIImageView!
    
    @IBOutlet weak var stackViewAnswer: UIStackView!
    
    @IBOutlet weak var stackViewSelectLetter: UIStackView!
    
    @IBOutlet weak var stackViewRow1: UIStackView!
    
    @IBOutlet weak var stackViewRow2: UIStackView!
    
    var countCol_Row: Int!
    var countCol_Row1: Int!
    
    var wrongWord:String = "skg"
    var correctWord:String = ""
    var wordToMix:String!
    var wordMain:String = ""
    
    var arrDidRandom:[Int] = []
    
    //Arr Lable in StackViewAnswer
    var arrLblAnswer:[UILabel] = []
    var dictCoordinatorLableAnswer:Dictionary<UILabel,[CGFloat]> = [:]
    
    //preTag and curentTag
    var preTag:Int = 1
    var curentTag:Int = 1
    var isOutOfScope:Bool = false
    
    //SoundComplete
    var audioPlayer: AVAudioPlayer?
    let pathCorrectSound = Bundle.main.path(forResource: "correctSound", ofType: "wav")
    let pathWrongSound = Bundle.main.path(forResource: "wrongSound", ofType: "wav")
    //LblCorrectly
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLableCorrectly()
        constraintLblCorrectly()
        self.lblCompleteRound1.text = "✓"
        self.viewCompleteRound1.backgroundColor = UIColor.green
        
        let firstLearnVC = FirstLearnViewController()
        firstLearnVC.receiveData(escapeClosure: { vocaObj in
            self.wordInVocabulary = vocaObj
            
            self.preLearnState = self.wordInVocabulary.isLearned
            
            self.correctWord = self.wordInVocabulary.engWord ?? "NULL"
            self.imgMain.image = UIImage(data: self.wordInVocabulary.img1Word ?? Data()) ?? UIImage()
            self.borderImgMain()

            self.mixRandomLetter()
            self.createLblForStackAnswer()
            self.addLetterToStackViewSelect()
            self.registerMoveLetter()
        })
        self.sendVC?(firstLearnVC)
    }
    
    func checkCorrectAnswer(){
        var wordAnswer: String = ""
        for lbl in self.arrLblAnswer{
            wordAnswer.append(lbl.text ?? "")
        }
        if wordAnswer == self.correctWord {
            if self.preLearnState != true {
                updateWordHaveLearned()
            }
            soundCorrectly()
            self.learnCompleted = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showCorrectAnswerAndCloseThis()
            })
        }
    }
    
    func updateWordHaveLearned(){
        self.wordInVocabulary.isLearned = true
        PersistenceService.saveContext()
    }
    
    func showCorrectAnswerAndCloseThis(){
        self.imgBG.image = UIImage(data: self.wordInVocabulary.img1Word ?? Data()) ?? UIImage()
        self.view.bringSubviewToFront(self.visualEffectBG)
        self.view.bringSubviewToFront(self.btnCancel)
        let labelWord = UILabel()
        labelWord.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        labelWord.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        labelWord.text = self.correctWord
        labelWord.textAlignment = .center
        labelWord.contentMode = .center
        labelWord.translatesAutoresizingMaskIntoConstraints = false
        let centerX = NSLayoutConstraint(item: labelWord, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: labelWord, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        self.view.addSubview(labelWord)
        self.view.addConstraints([centerX,centerY])
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
        self.leadingLblCorrectlyAnim = NSLayoutConstraint(item: self.lblCorrectly ?? UILabel(), attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 207/414, constant: 0)
        self.trailingLblCorrectlyAnim = NSLayoutConstraint(item:  self.view.safeAreaLayoutGuide, attribute: .trailing, relatedBy: .equal, toItem: self.lblCorrectly ?? UILabel() , attribute: .trailing, multiplier: 414/314, constant: 0)
        
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
            self.visualEffectBG.effect = UIBlurEffect(style: .dark)
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
                self.lblCompleteRound2.text = "✓"
                self.viewCompleteRound2.backgroundColor = UIColor.green
            })
        })
    }
    
    func soundCorrectly(){
        do{
            let urlCorrectSound = URL(fileURLWithPath: self.pathCorrectSound ?? "")
            self.audioPlayer = try AVAudioPlayer(contentsOf: urlCorrectSound)
            self.animationLblCorrectlyAddToView()
            self.audioPlayer?.play()
        }catch{
            
        }
    }
    
    @IBAction func tapToCancel(_ sender: Any) {
        
        if self.preLearnState == true {
            self.learnCompleted = false
        }
        
        let detailWordVC = self.navigationController?.viewControllers.first as! DetailWordViewController
        detailWordVC.receiveSecondLearnVC(escapeClosure: { vc in
            let secondLearnVC = vc as! SecondLearnViewController
            secondLearnVC.sendData?(self.wordInVocabulary,self.learnCompleted)
        })
        
        self.navigationController?.popToRootViewController(animated: true,completion: {
            if self.learnCompleted == true{
                NotificationCenter.default.post(name: DetailWordViewController.notificationBackToRootDetailWord, object: nil, userInfo: ["wordInVoca":self.wordInVocabulary ?? VocabularyTable(),"isLearned":self.learnCompleted])
            }
        })
        
    }
    
    var sendData: ((VocabularyTable,Bool) ->Void)?
    func receiveVocabularyTableObj(escapeClosure: @escaping (VocabularyTable,Bool)->Void){
        sendData = escapeClosure
    }
    
    func borderImgMain(){
        self.imgMain.layer.borderWidth = 5
        self.imgMain.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        self.imgMain.layer.cornerRadius = 10
    }
    
    var sendVC: ((UIViewController) ->Void)?
    func receiceVC(escapeClosure: @escaping (UIViewController) ->Void){
        sendVC = escapeClosure
    }
    
    func createLblForStackAnswer(){
        for i in 0..<self.correctWord.count{
            let lbl = UILabel()
            lbl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6965432363)
            lbl.tag = i+1
            lbl.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            lbl.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            lbl.textAlignment = .center
            lbl.contentMode = .center
            lbl.clipsToBounds = true
            lbl.layer.cornerRadius = 5
            self.stackViewAnswer.addArrangedSubview(lbl)
            self.arrLblAnswer.append(self.stackViewAnswer.viewWithTag(i+1) as! UILabel)
        }
        
    }
    
    func getCoordinateLable(){
        for lbl in self.arrLblAnswer{
            self.dictCoordinatorLableAnswer[lbl] = [self.stackViewAnswer.convert(lbl.frame.origin, to: self.view).x,self.stackViewAnswer.convert(lbl.frame.origin, to: self.view).y]
        }
    }
    
    func checkMoveToLblAnswer(moveX:CGFloat, moveY:CGFloat) ->Int{
        for dict in self.dictCoordinatorLableAnswer {
            if (moveX >= dict.value[0]) && (moveX <= dict.value[0] + dict.key.frame.width) && (moveY >= dict.value[1]) && (moveY <= dict.value[1] + dict.key.frame.height){
                return dict.key.tag
            }
        }
        return 0
    }
    
    func registerMoveLetter(){
        for i in 1...self.wordMain.count{
            self.stackViewSelectLetter.viewWithTag(i)?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleMoveLbl)))
        }
    }
    
    @objc func handleMoveLbl(gesture: UIPanGestureRecognizer){
        if gesture.state == .began{
            self.getCoordinateLable()
        }else if gesture.state == .changed{
            
            let translation = gesture.translation(in: self.view)
                gesture.view?.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            
            let convertCoorInSuperView = gesture.view?.superview?.convert(gesture.view?.frame.origin ?? CGPoint(), to: self.stackViewSelectLetter)
            let convertTranslation = self.stackViewSelectLetter.convert(convertCoorInSuperView ?? CGPoint(), to: self.view)
            
            let moveToTag = checkMoveToLblAnswer(moveX: convertTranslation.x, moveY: convertTranslation.y)
        
            if  moveToTag != 0 {
                
                if self.isOutOfScope != false{
                    self.isOutOfScope = false
                }
                self.curentTag = moveToTag
                
                if self.arrLblAnswer[moveToTag-1].backgroundColor != #colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1){
                    self.arrLblAnswer[moveToTag-1].backgroundColor = #colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)
                    self.arrLblAnswer[moveToTag-1].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }
                if preTag != curentTag{
                    if self.arrLblAnswer[preTag-1].backgroundColor != #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6965432363){
                        self.arrLblAnswer[preTag-1].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6965432363)
                        self.arrLblAnswer[preTag-1].transform = .identity
                    }
                }
        
            }else{
                
                if self.arrLblAnswer[curentTag-1].backgroundColor != #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6965432363){
                    self.arrLblAnswer[curentTag-1].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6965432363)
                    self.arrLblAnswer[curentTag-1].transform = .identity
                }
                self.isOutOfScope = true
            }
            
            self.preTag = self.curentTag
            
        }else if gesture.state == .ended{
            
            gesture.view?.transform = .identity
            self.arrLblAnswer[curentTag-1].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6965432363)
            self.arrLblAnswer[curentTag-1].transform = .identity
            
            if self.isOutOfScope == false{
                let getTextLbl = gesture.view as! UILabel
                self.arrLblAnswer[curentTag-1].text = getTextLbl.text
                self.checkCorrectAnswer()
            }
        }
    }
    
    func mixRandomLetter(){
        wordToMix = correctWord + wrongWord
        for _ in 0..<wordToMix.count{
            var random:Int = 0
            repeat{
                random = Int.random(in: 0..<wordToMix.count)
            }while checkDidRandom(num: random)
            self.arrDidRandom.append(random)
            wordMain.append(self.wordToMix[random])
        }
    }
    
    func checkDidRandom(num: Int) ->Bool{
        for n in self.arrDidRandom{
            if num == n {
                return true
            }
        }
        return false
    }
    
    func createLable(text: String, tag: Int) -> UILabel{
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        lable.textColor = #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1)
        lable.textAlignment = .center
        lable.contentMode = .center
        lable.text = text
        lable.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        lable.clipsToBounds = true
        lable.layer.cornerRadius = 5
        lable.tag = tag + 1
        lable.isUserInteractionEnabled = true
        return lable
    }
    
    func createBlankLabel() -> UILabel{
        let blankLable = UILabel()
        blankLable.isUserInteractionEnabled = false
        return blankLable
    }
    
    func addLetterToStackViewSelect(){
        if self.wordMain.count <= 7 {
            self.stackViewRow2.removeFromSuperview()
            countCol_Row = self.wordMain.count
            onlyRow1()
        }else{
            if self.wordMain.count % 2 != 0{
                countCol_Row = self.wordMain.count + 1
                countCol_Row1 = countCol_Row / 2 + 1
                row1GreaterRow2()
            }else{
                countCol_Row = self.wordMain.count
                countCol_Row1 = countCol_Row / 2
                row1EqualRow2()
            }
        }
    }
    
    func row1GreaterRow2(){
        for i in 0..<countCol_Row-1{
            if i < self.countCol_Row1{
                self.stackViewRow1.addArrangedSubview(createLable(text: self.wordMain[i], tag: i))
            }else{
                
                if i == self.countCol_Row1 {
                    self.stackViewRow2.addArrangedSubview(createBlankLabel())
                }
                
                self.stackViewRow2.addArrangedSubview(createLable(text: self.wordMain[i], tag: i))
                
                if i == self.countCol_Row-2 {
                    self.stackViewRow2.addArrangedSubview(createBlankLabel())
                }
                
            }
        }
    }
    
    func row1EqualRow2(){
        for i in 0..<countCol_Row{
            if i < self.countCol_Row1{
                self.stackViewRow1.addArrangedSubview(createLable(text: self.wordMain[i], tag: i))
            }else{
                self.stackViewRow2.addArrangedSubview(createLable(text: self.wordMain[i], tag: i))
            }
        }
    }
    
    func onlyRow1(){
        for i in 0..<countCol_Row{
            self.stackViewRow1.addArrangedSubview(createLable(text: self.wordMain[i], tag: i))
        }
    }


}

extension String{
    subscript(i: Int) -> String{
        return String(self[index(startIndex, offsetBy: i)])
    }
}

extension UINavigationController{
    func popToRootViewController(animated: Bool, completion: @escaping ()->Void){
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToRootViewController(animated: animated)
        CATransaction.commit()
    }
}
