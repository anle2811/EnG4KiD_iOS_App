//
//  LearnVocabularyViewController.swift
//  EnG4KiD
//
//  Created by Lê An on 3/11/20.
//  Copyright © 2020 An Lê. All rights reserved.
//

import UIKit
import CoreData
class LearnVocabularyViewController: UIViewController {

    static let notificationName = Notification.Name(rawValue: "GetLearnState")
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblTopicName: UILabel!
    @IBOutlet weak var btnBackHome: UIButton!
    @IBOutlet weak var vocabularyCollectionView: UICollectionView!
    private var spacingBetweenCellToCollectionView: CGFloat = 10
    
    @IBOutlet weak var btnLearnNow: UIButton!
    
    var inTopic: TopicTable!
    
    private var vocabularyData: [VocabularyTable]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addConstraint()
        retrieveVocabulary()
        self.lblTopicName.text = self.inTopic.titleTopic
        self.vocabularyCollectionView.dataSource = self
        self.vocabularyCollectionView.delegate = self
        
        registerCell()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getLearnState(notification:)), name: LearnVocabularyViewController.notificationName, object: nil)
        
    }
    
    @objc func getLearnState(notification: Notification){
        updateWordHaveLearned(wordInVoca: notification.userInfo?["wordInVoca"] as! VocabularyTable)
    }
    
    func updateWordHaveLearned(wordInVoca: VocabularyTable){
        let reloadIndex = self.vocabularyData.firstIndex(of: wordInVoca)
        self.vocabularyCollectionView.reloadItems(at: [IndexPath(item: reloadIndex ?? 0, section: 0)])
    }
    
    func retrieveVocabulary(){
        let fetchRequest: NSFetchRequest<VocabularyTable> = VocabularyTable.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "engWord", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "oneTopic == %@", self.inTopic)
        do{
            let vocabularies = try PersistenceService.context.fetch(fetchRequest)
            self.vocabularyData = vocabularies
            for word in vocabularies{
                print(word.engWord ?? "AnLe")
            }
        }catch{}
    }
    
    
    @IBAction func tapToBackHome(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    var sendData: ((VocabularyTable) -> Void)?
    
    func receiveWordData(escapeClosure: @escaping (VocabularyTable) -> Void){
        sendData = escapeClosure // Stored escapeClosure vào sendData
    }
    
    func showViewWord(obj: VocabularyTable){
        
        guard let vcDetailWord = storyboard?.instantiateViewController(withIdentifier: "DetailWordVC") as? DetailWordViewController else {return}
        
        guard let naviDetailWord = storyboard?.instantiateViewController(withIdentifier: "naviDetailWord") as? UINavigationController else {return}
        
        naviDetailWord.modalPresentationStyle = .overFullScreen
        naviDetailWord.modalTransitionStyle = .crossDissolve
        naviDetailWord.pushViewController(vcDetailWord, animated: false)
        
        vcDetailWord.triggerSendData { vc in
            guard let vcLearn = vc as? LearnVocabularyViewController else {return} //Body sẽ được thực thi khi continueTriggerSendDataAndSendVCObj(vc: (UIViewController) -> Void) được gọi từ vcDetailWord
            vcLearn.sendData?(obj)
        }
        
        present(naviDetailWord, animated: true)
       
    }
    
   /* func filterVocabularyFlowTopic(){
        self.vocabularyOfTopic = self.vocabularyData.filter({$0.idTopic == self.idTopic})
        print("vnWord: \(self.vocabularyOfTopic[0].vnWord)")
    }*/
    
    func registerCell(){
        let nib = UINib(nibName: "VocabularyCollectionViewCell", bundle: nil)
        self.vocabularyCollectionView.register(nib, forCellWithReuseIdentifier: "vocabularyCollectionViewCell")
    }
    
    func addConstraint(){
       
        self.vocabularyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.btnLearnNow.translatesAutoresizingMaskIntoConstraints = false
        self.lblTopicName.adjustsFontSizeToFitWidth = true
        
        //Constraint vocabularyCollectionView
        let topVocabularyCollectionView = NSLayoutConstraint(item: self.vocabularyCollectionView ?? UICollectionView(), attribute: .top, relatedBy: .equal, toItem: self.headerView ?? UIView(), attribute: .bottom, multiplier: 1, constant: 3)
        let bottomVocabularyCollectionView = NSLayoutConstraint(item: self.vocabularyCollectionView ?? UICollectionView(), attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -3)
        let leadingVocabularyCollectionView = NSLayoutConstraint(item: self.vocabularyCollectionView ?? UICollectionView(), attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 3)
        let trailingVocabularyCollectionView = NSLayoutConstraint(item: self.vocabularyCollectionView ?? UICollectionView(), attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -3)
        self.vocabularyCollectionView.layer.cornerRadius = 15
       
       //Constraint btnLearnNow
        let topBtnLearnNow = NSLayoutConstraint(item: self.btnLearnNow ?? UIButton(), attribute: .top, relatedBy: .equal, toItem: self.vocabularyCollectionView ?? UICollectionView(), attribute: .bottom, multiplier: 1, constant: -60)
        let bottomBtnLearnNow = NSLayoutConstraint(item: self.btnLearnNow ?? UIButton(), attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 10)
        let leadingBtnLearnNow = NSLayoutConstraint(item: self.btnLearnNow ?? UIButton(), attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 20)
        let trailingBtnLearnNow = NSLayoutConstraint(item: self.btnLearnNow ?? UIButton(), attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -20)
        self.btnLearnNow.layer.cornerRadius = 15
        self.view.addConstraints([topVocabularyCollectionView,bottomVocabularyCollectionView,leadingVocabularyCollectionView,trailingVocabularyCollectionView,topBtnLearnNow,bottomBtnLearnNow,leadingBtnLearnNow,trailingBtnLearnNow])
     
        
    }


}

extension LearnVocabularyViewController: UICollectionViewDataSource, UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vocabularyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vocabularyCollectionViewCell", for: indexPath) as! VocabularyCollectionViewCell
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let customCell = cell as? VocabularyCollectionViewCell else {return}
        
        let cellHeight = cell.bounds.height
       
        let topRatio: CGFloat = 117/120
        let bottomRatio: CGFloat = 97/120
        let minusTop = cellHeight-(cellHeight * topRatio)
        let minusBottom = cellHeight-(cellHeight * bottomRatio)
        
        let calculatingCornerRadius = ((cellHeight) - ((cellHeight*((cellHeight/(cellHeight-minusTop))+(cellHeight/(cellHeight-minusBottom)))) - (cellHeight*2)))/2
        
        customCell.customInit(imgWord: UIImage(data: self.vocabularyData[indexPath.item].imgWord ?? Data()) ?? UIImage(), engWord: self.vocabularyData[indexPath.item].engWord ?? "NULL", isLearned: self.vocabularyData[indexPath.item].isLearned,cornerRadius: calculatingCornerRadius*1.06)
 
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vocaId = self.vocabularyData[indexPath.item].objectID
        do{
            let objHasId = try PersistenceService.context.existingObject(with: vocaId) as! VocabularyTable
            showViewWord(obj: objHasId)
        }catch{}
    }
    
}

extension LearnVocabularyViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemPerRow: CGFloat = 3
        let spacingBetweenPerItem: CGFloat = 10
        
        let totalSpacingOfPerRow = (self.spacingBetweenCellToCollectionView*2)+((numberOfItemPerRow-1)*spacingBetweenPerItem)
        
        let widthAndHeight = (collectionView.bounds.width - totalSpacingOfPerRow) / numberOfItemPerRow
        
        return CGSize(width: widthAndHeight, height: widthAndHeight*(120/100))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.spacingBetweenCellToCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.spacingBetweenCellToCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.spacingBetweenCellToCollectionView, left: self.spacingBetweenCellToCollectionView, bottom: self.spacingBetweenCellToCollectionView, right: self.spacingBetweenCellToCollectionView)
    }
    
}

