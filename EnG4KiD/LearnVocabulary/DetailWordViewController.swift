//
//  DetailWordViewController.swift
//  EnG4KiD
//
//  Created by MacPro An Lê on 3/14/20.
//  Copyright © 2020 An Lê. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class DetailWordViewController: UIViewController {
    
    private var wordInVocabulary: VocabularyTable!
    
    static let notificationBackToRootDetailWord = Notification.Name(rawValue: "BackToRootDetailWord")
    
    var checkUseNotifi: Bool = false
    
    /*init(delegate: DetailWordViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }*/

    @IBOutlet var viewShowWord: UIView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnHear: UIButton!
    
    @IBOutlet weak var viewEngWord: UIView!
    
    @IBOutlet weak var viewVnWord: UIView!
    
    @IBOutlet weak var imgDescribeWord: UIImageView!
    
    @IBOutlet weak var btnDismiss: UIButton!
    
    @IBOutlet weak var imgBGViewShowWord: UIImageView!
    
    @IBOutlet weak var visualEffectBlurBG:
    UIVisualEffectView!
    
    @IBOutlet weak var lblEngWord: UILabel!
    @IBOutlet weak var lblVnWord: UILabel!
    
    //Text-To-Speech
    let languageSpeechAccent: AVSpeechSynthesisVoice? = AVSpeechSynthesisVoice(language: "en-US")
    let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    //
    var arrWord: [String] = []
    
    var arrRandomCheck: [Int] = []
    
    var checkHaveLearned: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RELOAD!!")
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleBackHere(notification:)), name: DetailWordViewController.notificationBackToRootDetailWord, object: nil)
        
        addConstraintViewShowWord_VC()
        addConstraintViewShowWord()
        editView()
        
        let vcSecondLearn = SecondLearnViewController()
                vcSecondLearn.receiveVocabularyTableObj(escapeClosure: { vocaTableObj,isLearned in
                    self.checkHaveLearned = isLearned
                    self.wordInVocabulary = vocaTableObj
                    
                    self.setUpView()
                })
        self.sendObj?(vcSecondLearn)
        
        let vcLearn = LearnVocabularyViewController()
        vcLearn.receiveWordData(escapeClosure: { vocaObj in
             self.wordInVocabulary = vocaObj
            
            self.setUpView()
         })
        self.continueTriggerSendDataAndSendVCObj?(vcLearn)
    }
    
    
    func setUpView(){
        self.imgDescribeWord.image = UIImage(data: self.wordInVocabulary.imgWord ?? Data()) ?? UIImage()
        self.imgBGViewShowWord.image = UIImage(data: self.wordInVocabulary.imgWord ?? Data()) ?? UIImage()
        self.lblEngWord.text = self.wordInVocabulary.engWord
        self.lblVnWord.text = self.wordInVocabulary.vnWord
        
        self.randomFetchThreeWord()
        self.randomMixMainWordToArrWord()
        
        if self.checkHaveLearned == true || self.wordInVocabulary.isLearned == true{
            self.btnNext.setTitle("Done!", for: .normal)
            self.btnNext.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        }
    }

    @objc func handleBackHere(notification:Notification){
        let wordInVoca = notification.userInfo?["wordInVoca"] as! VocabularyTable
        let checkLearned = notification.userInfo?["isLearned"] as! Bool
        self.wordInVocabulary = wordInVoca
        self.checkHaveLearned = checkLearned
    
        if self.checkHaveLearned == true || self.wordInVocabulary.isLearned == true{
            self.btnNext.setTitle("Done!", for: .normal)
            self.btnNext.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        }
    }
    
    var sendObj:((UIViewController) ->Void)?
    func receiveSecondLearnVC(escapeClosure: @escaping (UIViewController) ->Void){
        sendObj = escapeClosure
    }
    
    func randomFetchThreeWord(){
        let fetchRequest: NSFetchRequest<VocabularyTable> = VocabularyTable.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "oneTopic == %@ AND self != %@", self.wordInVocabulary.oneTopic ?? TopicTable(),self.wordInVocabulary)
        do{
            let words = try PersistenceService.context.fetch(fetchRequest)
            var numRD:Int = 0
            for _ in 0..<3{
                repeat{
                    numRD = Int.random(in: 0..<words.count)
                }while checkSameRandom(numRd: numRD)
                self.arrRandomCheck.append(numRD)
                self.arrWord.append(words[numRD].engWord ?? "NULL")
            }
        }catch{}
    }
    
    func checkSameRandom(numRd: Int) ->Bool{
        for num in self.arrRandomCheck{
            if numRd == num{
                return true
            }
        }
        return false
    }
    
    func randomMixMainWordToArrWord(){
        let rdNumber = Int.random(in: 0..<4)
        arrWord.insert(self.wordInVocabulary.engWord ?? "NULL", at: rdNumber)
    }

    
    @IBAction func nextLearn(_ sender: Any) {
        guard let firstLearnVC = storyboard?.instantiateViewController(withIdentifier: "FirstLearnVC") as? FirstLearnViewController else {
            return
        }
        
        firstLearnVC.waitingForSendData(escapeClosure: { vc in
            guard let instanceVc = vc as? DetailWordViewController else {return}
            instanceVc.sendArrWord?(self.arrWord,self.wordInVocabulary)
        })
        
        self.navigationController?.pushViewController(firstLearnVC, animated: true)
    }
    
    var sendArrWord: (([String],VocabularyTable)->Void)?
    
    func receiveArrWord(escapeClosure:@escaping([String],VocabularyTable)->Void){
        self.sendArrWord = escapeClosure
    }
    
    @IBAction func speechWord(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: self.lblEngWord.text ?? "Hello")
        utterance.voice = self.languageSpeechAccent
        self.synthesizer.speak(utterance)
    }
    
    
    var continueTriggerSendDataAndSendVCObj: ((UIViewController)->Void)?
    
    func triggerSendData(escapeClosure: @escaping (UIViewController)->Void){
        continueTriggerSendDataAndSendVCObj = escapeClosure
    }
   
    @IBAction func dismissPopupView(_ sender: Any) {
        dismiss(animated: true,completion: {
            if self.checkHaveLearned == true{
                NotificationCenter.default.post(name: LearnVocabularyViewController.notificationName, object: nil, userInfo: ["wordInVoca": self.wordInVocabulary ?? VocabularyTable()])
            }
        })
    }
    
    func editView(){
        self.btnNext.layer.cornerRadius = 15
        
        self.imgBGViewShowWord.layer.cornerRadius = 15
        self.visualEffectBlurBG.layer.cornerRadius = 15
        self.viewShowWord.layer.cornerRadius = 15
        
        self.viewEngWord.layer.cornerRadius = 15
        self.viewVnWord.layer.cornerRadius = 15
        
        self.btnHear.layer.cornerRadius = 10
        self.btnDismiss.layer.cornerRadius = 10
        self.imgDescribeWord.layer.cornerRadius = 15
        
        //self.btnNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.btnNext.frame.width/2)
        self.btnNext.titleLabel?.adjustsFontForContentSizeCategory = true
        self.viewShowWord.sendSubviewToBack(self.visualEffectBlurBG)
        self.viewShowWord.sendSubviewToBack(self.imgBGViewShowWord)
        
        self.lblEngWord.adjustsFontSizeToFitWidth = true
        self.lblVnWord.adjustsFontSizeToFitWidth = true

    }
    
    
    func addConstraintViewShowWord_VC(){
        self.viewShowWord.translatesAutoresizingMaskIntoConstraints = false
        
        let topViewShowWord = NSLayoutConstraint(item: self.viewShowWord ?? UIView(), attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 124/862, constant: 0)
        let bottomViewShowWord = NSLayoutConstraint(item: self.viewShowWord ?? UIView(), attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 782/862, constant: 0)
        let leadingViewShowWord = NSLayoutConstraint(item: self.viewShowWord ?? UIView(), attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 20/414, constant: 0)
        let trailingViewShowWord = NSLayoutConstraint(item: self.view.safeAreaLayoutGuide, attribute: .trailing, relatedBy: .equal, toItem: self.viewShowWord ?? UIView() , attribute: .trailing, multiplier: 414/394, constant: 0)
        
        self.view.addConstraints([topViewShowWord,bottomViewShowWord,leadingViewShowWord,trailingViewShowWord])
    }
    
    func addConstraintViewShowWord(){
        self.imgDescribeWord.translatesAutoresizingMaskIntoConstraints = false
        self.viewEngWord.translatesAutoresizingMaskIntoConstraints = false
        self.viewVnWord.translatesAutoresizingMaskIntoConstraints = false
        self.btnNext.translatesAutoresizingMaskIntoConstraints = false
        self.btnHear.translatesAutoresizingMaskIntoConstraints = false
        self.btnDismiss.translatesAutoresizingMaskIntoConstraints = false
               
        //Constraint viewEngWord
        let topViewEngWord = NSLayoutConstraint(item: self.viewEngWord ?? UIView(), attribute: .top, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .bottom, multiplier: 60/782, constant: 0)
        let bottomViewEngWord = NSLayoutConstraint(item: self.viewEngWord ?? UIView(), attribute: .bottom, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .bottom, multiplier: 188/782, constant: 0)
        let leadingViewEngWord = NSLayoutConstraint(item: self.viewEngWord ?? UIView(), attribute: .leading, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .trailing, multiplier: 35/394 , constant: 0)
        let trailingViewEngWord = NSLayoutConstraint(item: self.viewEngWord ?? UIView(), attribute: .trailing, relatedBy: .equal, toItem: self.viewVnWord ?? UIView(), attribute: .leading, multiplier: 199/215 , constant: 0)
        //Constraint viewVnWord
        let topViewVnWord = NSLayoutConstraint(item: self.viewVnWord ?? UIView(), attribute: .top, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .bottom, multiplier: 60/782, constant: 0)
        let bottomViewVnWord = NSLayoutConstraint(item: self.viewVnWord ?? UIView(), attribute: .bottom, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .bottom, multiplier: 188/782, constant: 0)
        let leadingViewVnWord = NSLayoutConstraint(item: self.viewVnWord ?? UIView(), attribute: .leading, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .trailing, multiplier: 215/394 , constant: 0)
        let trailingViewVnWord = NSLayoutConstraint(item: self.viewShowWord ?? UIView(), attribute: .trailing, relatedBy: .equal, toItem: self.viewVnWord ?? UIView(), attribute: .trailing, multiplier: 394/379 , constant: 0)
        //Constraint btnNext
        let topBtnNext = NSLayoutConstraint(item: self.btnNext ?? UIButton(), attribute: .top, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .bottom, multiplier: 629/658, constant: 0)
        let bottomBtnNext = NSLayoutConstraint(item: self.btnNext ?? UIButton(), attribute: .bottom, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .bottom, multiplier: 687/658, constant: 0)
        let leadingBtnNext = NSLayoutConstraint(item: self.btnNext ?? UIButton(), attribute: .leading, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .trailing, multiplier: 95/374, constant: 0)
        let trailingBtnNext = NSLayoutConstraint(item:  self.viewShowWord ?? UIView(), attribute: .trailing, relatedBy: .equal, toItem: self.btnNext ?? UIButton() , attribute: .trailing, multiplier: 374/279, constant: 0)
        //Constraint btnHear
        let topBtnHear = NSLayoutConstraint(item: self.btnHear ?? UIButton(), attribute: .top, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .bottom, multiplier: 367/658, constant: 0)
        let bottomBtnHear = NSLayoutConstraint(item: self.btnHear ?? UIButton(), attribute: .bottom, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .bottom, multiplier: 437/658, constant: 0)
        let leadingBtnHear = NSLayoutConstraint(item: self.btnHear ?? UIButton(), attribute: .leading, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .trailing, multiplier: 320/375, constant: 0)
        let trailingBtnHear = NSLayoutConstraint(item: self.btnHear ?? UIButton(), attribute: .trailing, relatedBy: .equal, toItem: self.viewShowWord ?? UIView() , attribute: .trailing, multiplier: 390/375, constant: 0)
        //Constraint imgDescribeWord
        let topImgDescribeWord = NSLayoutConstraint(item: self.imgDescribeWord ?? UIImageView(), attribute: .top, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .bottom, multiplier: 76/658, constant: 0)
        let bottomImgDescribeWord = NSLayoutConstraint(item: self.imgDescribeWord ?? UIImageView(), attribute: .bottom, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .bottom, multiplier: 621/658, constant: 0)
        let leadingImgDescribeWord = NSLayoutConstraint(item: self.imgDescribeWord ?? UIImageView(), attribute: .leading, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .trailing, multiplier: 15/375, constant: 0)
        let trailingImgDescribeWord = NSLayoutConstraint(item: self.viewShowWord ?? UIView(), attribute: .trailing, relatedBy: .equal, toItem: self.imgDescribeWord ?? UIImageView() , attribute: .trailing, multiplier: 375/360, constant: 0)
        //Constraint btnDismiss
        let topBtnDismiss = NSLayoutConstraint(item: self.btnDismiss ?? UIButton(), attribute: .top, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .bottom, multiplier: 171/658, constant: 0)
        let bottomBtnDismiss = NSLayoutConstraint(item: self.btnDismiss ?? UIButton(), attribute: .bottom, relatedBy: .equal, toItem: self.btnHear ?? UIButton(), attribute: .top, multiplier: 241/367, constant: 0)
        let leadingBtnDismiss = NSLayoutConstraint(item: self.btnDismiss ?? UIButton(), attribute: .leading, relatedBy: .equal, toItem: self.viewShowWord ?? UIView(), attribute: .trailing, multiplier: 320/375, constant: 0)
        let trailingBtnDismiss = NSLayoutConstraint(item: self.btnDismiss ?? UIButton(), attribute: .trailing, relatedBy: .equal, toItem: self.viewShowWord ?? UIView() , attribute: .trailing, multiplier: 390/375, constant: 0)
        
        //Send imgDescribeWord to the end of layers
    self.viewShowWord.sendSubviewToBack(self.imgDescribeWord)
        self.viewShowWord.addConstraints([topImgDescribeWord,bottomImgDescribeWord,leadingImgDescribeWord,trailingImgDescribeWord,topBtnNext,bottomBtnNext,leadingBtnNext,trailingBtnNext,topBtnHear,bottomBtnHear,leadingBtnHear,trailingBtnHear,topBtnDismiss,bottomBtnDismiss,leadingBtnDismiss,trailingBtnDismiss])
        
        self.view.addConstraints([topViewEngWord,bottomViewEngWord,leadingViewEngWord,trailingViewEngWord,topViewVnWord,bottomViewVnWord,leadingViewVnWord,trailingViewVnWord])
        
    }
    
}


