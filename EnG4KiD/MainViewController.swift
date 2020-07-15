//
//  MainViewController.swift
//  EnG4KiD
//
//  Created by Lê An on 3/10/20.
//  Copyright © 2020 An Lê. All rights reserved.
//

import UIKit
import CoreData
class MainViewController: UIViewController {
    
    @IBOutlet weak var viewMenuInfo: UIView!
    
    @IBOutlet weak var ten_app: UIImageView!
    
    @IBOutlet weak var lblLearnedPerc: UILabel!
    
    @IBOutlet weak var viewPrgLearn: UIView!
    
    @IBOutlet weak var lblPrgPercent: UILabel!
    
    var progress: CGFloat = 0{
           didSet{
               updateProgressLbl()
           }
       }
    var countFired:CGFloat = 0
    
    @IBOutlet weak var viewPrgGame: UIView!
    
    @IBOutlet weak var imgAvt: UIImageView!
    
    @IBOutlet weak var viewTopic: UIView!
    
    @IBOutlet weak var viewPopUpTableTopic: UIView!
    
    private var previousPopUpColor: UIColor!
    
    private var previousTopicViewColor: UIColor!
    
    private var viewMenuInfoColor: UIColor!
    
    private var topViewPopUpTableTopicAnimation:NSLayoutConstraint!
    private var bottomViewPopUpTableTopicAnimation:NSLayoutConstraint!
    
    private var topViewPopUpTableTopic:NSLayoutConstraint!
    private var bottomViewPopUpTableTopic:NSLayoutConstraint!
    private var leadingViewPopUpTableTopic:NSLayoutConstraint!
    private var trailingViewPopUpTableTopic:NSLayoutConstraint!
    
    private var tapPopUpGesture: UITapGestureRecognizer!
    
    private var topicData:[TopicTable] = []
    
    private var dictCheckExpanded: Dictionary<Int,Bool> = [:]
    
    private var selectIndexPath: IndexPath!
    
    @IBOutlet weak var tableViewTopic: UITableView!
    
    private var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveTopicData()
        addConstraint()
        customView()
        
        setTableViewTopicDatasourceDelegate(datasourceDelegate: self)
        registerCustomCellAndSection()
        
        createProgressLearn()
        constraintLblPrgPercent()
        runProgress()
    }
    
    func createProgressLearn(){
        let prgLearnView = CircularProgressView()
        prgLearnView.tag = 1999
        prgLearnView.trackColor = UIColor.darkGray
        prgLearnView.progressColor = UIColor.red
        
        self.viewPrgLearn.addSubview(prgLearnView)

        prgLearnView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: prgLearnView, attribute: .top, relatedBy: .equal, toItem: self.viewPrgLearn, attribute: .bottom, multiplier: 95/192, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: prgLearnView, attribute: .bottom, relatedBy: .equal, toItem: self.viewPrgLearn, attribute: .bottom, multiplier: 175/192, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: prgLearnView, attribute: .leading, relatedBy: .equal, toItem: self.viewPrgLearn, attribute: .trailing, multiplier: 109/199, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self.viewPrgLearn ?? UIView(), attribute: .trailing, relatedBy: .equal, toItem: prgLearnView, attribute: .trailing, multiplier: 199/189, constant: 0)
        
        self.view.addConstraints([topConstraint,bottomConstraint,leadingConstraint,trailingConstraint])
        
        prgLearnView.layoutIfNeeded()
        
        if prgLearnView.frame.size.width > prgLearnView.frame.size.height{
            let radius = prgLearnView.frame.size.height/2
            prgLearnView.createCircularPath(radius: radius)
        }else{
            let radius = prgLearnView.frame.size.width/2
            prgLearnView.createCircularPath(radius: radius)
        }
        
        self.viewPrgLearn.layoutIfNeeded()
    }
    
    /*func progressAnimation(duration: TimeInterval){
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 0.9
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        (self.viewPrgLearn.viewWithTag(1999) as! CircularProgressView).progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        
    }*/
    
    func getLearnedPercentTotal() -> CGFloat{
        let isLearnedFetchRequest:NSFetchRequest<VocabularyTable> = VocabularyTable.fetchRequest()
        isLearnedFetchRequest.predicate = NSPredicate(format: "isLearned == TRUE")
        let allFetchRequest:NSFetchRequest<VocabularyTable> = VocabularyTable.fetchRequest()
        do{
            let isLearnedResult = try PersistenceService.context.fetch(isLearnedFetchRequest)
            let allResult = try PersistenceService.context.fetch(allFetchRequest)
            print("Few: \(isLearnedResult.count)")
            print("ALL: \(allResult.count)")
            print("Divide: \(Float(isLearnedResult.count) / Float(allResult.count))")
            return CGFloat(Float(isLearnedResult.count) / Float(allResult.count))
        }catch{}
        
        return 1
    }
    
    func runProgress(){
        let learnedPercent:CGFloat = self.getLearnedPercentTotal()
        print("Percent: \(learnedPercent)")
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            self.countFired += 1
            DispatchQueue.main.async {
                self.progress = min(0.02 * self.countFired, learnedPercent)
                if self.progress == learnedPercent{
                    timer.invalidate()
                }
            }
        })
    }
    
    func updateProgressLbl(){
        self.lblPrgPercent.text = String(format: "%.1f",CGFloat(self.progress*100))+"%"
        (self.viewPrgLearn.viewWithTag(1999) as! CircularProgressView).progressLayer.strokeEnd = self.progress
    }
    
    func constraintLblPrgPercent(){
        self.lblPrgPercent.translatesAutoresizingMaskIntoConstraints = false
        self.lblLearnedPerc.translatesAutoresizingMaskIntoConstraints = false
        
        //Constraint lblPrgPercent
        let centerX = NSLayoutConstraint(item: self.lblPrgPercent ?? UILabel(), attribute: .centerX, relatedBy: .equal, toItem: self.viewPrgLearn.viewWithTag(1999), attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: self.lblPrgPercent ?? UILabel(), attribute: .centerY, relatedBy: .equal, toItem: self.viewPrgLearn.viewWithTag(1999), attribute: .centerY, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: self.lblPrgPercent ?? UILabel(), attribute: .leading, relatedBy: .equal, toItem: self.viewPrgLearn.viewWithTag(1999), attribute: .leading, multiplier: 119/109, constant: 0)
        let trailing = NSLayoutConstraint(item: self.lblPrgPercent ?? UILabel(), attribute: .trailing, relatedBy: .equal, toItem: self.viewPrgLearn.viewWithTag(1999), attribute: .trailing, multiplier: 179/189, constant: 0)
        
        self.lblPrgPercent.adjustsFontSizeToFitWidth = true
        
        //Constraint lblLearnedPerc
        let centerYs = NSLayoutConstraint(item: self.lblLearnedPerc ?? UILabel(), attribute: .centerY, relatedBy: .equal, toItem: self.viewPrgLearn.viewWithTag(1999), attribute: .centerY, multiplier: 1, constant: 0)
        let leadingS = NSLayoutConstraint(item: self.lblLearnedPerc ?? UILabel(), attribute: .leading, relatedBy: .equal, toItem: self.viewPrgLearn.viewWithTag(1999), attribute: .leading, multiplier: 10/109, constant: 0)
        let trailingS = NSLayoutConstraint(item: self.lblLearnedPerc ?? UILabel(), attribute: .trailing, relatedBy: .equal, toItem: self.viewPrgLearn.viewWithTag(1999), attribute: .leading, multiplier: 99/109, constant: 0)
        
        self.lblLearnedPerc.adjustsFontSizeToFitWidth = true
        
        self.view.addConstraints([centerX,centerY,leading,trailing,centerYs,leadingS,trailingS])
    }
    
    
    func retrieveTopicData(){
        let fetchRequest: NSFetchRequest<TopicTable> = TopicTable.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "titleTopic", ascending: true)]
        do{
            let arrTopic = try PersistenceService.context.fetch(fetchRequest)
            self.topicData = arrTopic
            for i in 0..<self.topicData.count{
                self.dictCheckExpanded[i] = false
            }
        }catch{}
    }
    
    func setTableViewTopicDatasourceDelegate(datasourceDelegate: UITableViewDataSource & UITableViewDelegate){
        self.tableViewTopic.dataSource = datasourceDelegate
        self.tableViewTopic.delegate = datasourceDelegate
    }
    
    func registerCustomCellAndSection(){
        self.selectIndexPath = IndexPath(row: -1, section: -1)
        
        let nibCell = UINib(nibName: "CustomCell", bundle: nil)
        self.tableViewTopic.register(nibCell, forCellReuseIdentifier: "topicCellTableViewCell")
        
        let nibSection = UINib(nibName: "CustomSection", bundle: nil)
        self.tableViewTopic.register(nibSection, forHeaderFooterViewReuseIdentifier: "topicSectionHeader")
    }
    
    func customView(){
        
        self.imgAvt.layer.cornerRadius = 10
        
        self.viewPrgLearn.layer.cornerRadius = 15
        
        viewMenuInfoColor = viewMenuInfo.backgroundColor
        previousPopUpColor = viewPopUpTableTopic.backgroundColor
        previousTopicViewColor = viewTopic.backgroundColor
        
        let color:UIColor = viewTopic.backgroundColor ?? UIColor()
        viewPopUpTableTopic.backgroundColor = color
        
    }
    
    func scrollDownPopUpTableTopicView(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: [], animations: {
           
            self.viewTopic.backgroundColor = self.viewMenuInfoColor
            self.view.removeConstraints([self.topViewPopUpTableTopic,self.bottomViewPopUpTableTopic])
            self.view.addConstraints([self.topViewPopUpTableTopicAnimation,self.bottomViewPopUpTableTopicAnimation])
            
            self.leadingViewPopUpTableTopic.constant = 8
            self.trailingViewPopUpTableTopic.constant = -8
            
            self.viewPopUpTableTopic.backgroundColor = self.previousPopUpColor
            self.viewPopUpTableTopic.layer.cornerRadius = 15
            self.viewPopUpTableTopic.layoutIfNeeded()
        }, completion: nil)
    }
    
    func scrollUpContenOffsetYzero_PopDownTableTopicView(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: [], animations: {
           
            self.viewTopic.backgroundColor = self.previousTopicViewColor
        
            self.view.removeConstraints([self.topViewPopUpTableTopicAnimation,self.bottomViewPopUpTableTopicAnimation])
            
            self.view.addConstraints([self.topViewPopUpTableTopic,self.bottomViewPopUpTableTopic])
            
            
            self.leadingViewPopUpTableTopic.constant = 0
            self.trailingViewPopUpTableTopic.constant = 0
            
            self.viewPopUpTableTopic.backgroundColor = self.viewTopic.backgroundColor
            self.viewPopUpTableTopic.layer.cornerRadius = 0
            self.viewPopUpTableTopic.layoutIfNeeded()
        }, completion: nil)
    }
    
    func addConstraint(){
        
        self.viewPopUpTableTopic.translatesAutoresizingMaskIntoConstraints = false
        
        //Constraint viewPopUpTableTopic Animation
        topViewPopUpTableTopicAnimation = NSLayoutConstraint(item: viewPopUpTableTopic ?? UIView(), attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: (viewMenuInfo.frame.height/4))
        bottomViewPopUpTableTopicAnimation = NSLayoutConstraint(item: viewPopUpTableTopic ?? UIView(), attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -8)
        
        //Constraint viewPopUpTableTopic
        topViewPopUpTableTopic = NSLayoutConstraint(item: viewPopUpTableTopic ?? UIView(), attribute: .top, relatedBy: .equal, toItem: viewTopic ?? UIView(), attribute: .top, multiplier: 1, constant: 0)
        bottomViewPopUpTableTopic = NSLayoutConstraint(item: viewPopUpTableTopic ?? UIView(), attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        leadingViewPopUpTableTopic = NSLayoutConstraint(item: viewPopUpTableTopic ?? UIView(), attribute: .leading, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0)
        trailingViewPopUpTableTopic = NSLayoutConstraint(item: viewPopUpTableTopic ?? UIView(), attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0)
        self.view.addConstraints([topViewPopUpTableTopic,bottomViewPopUpTableTopic,leadingViewPopUpTableTopic,trailingViewPopUpTableTopic])
        
    }
    

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TopicSectionHeaderDelegate, TopicCellTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "topicSectionHeader") as! TopicSectionHeader
        headerView.customInit(imgTopic: UIImage(data: self.topicData[section].imgTopic ?? Data()) ?? UIImage(), titleTopic: self.topicData[section].titleTopic ?? "Huhu", section: section, delegate: self)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.dictCheckExpanded[indexPath.section] == true{
            return 100
        }else{
            return 0
        }
    }
    
    func expandSwitchSection(header: TopicSectionHeader, section: Int) {
        self.dictCheckExpanded[section] = !(self.dictCheckExpanded[section]!)
        self.tableViewTopic.beginUpdates()
        self.tableViewTopic.reloadSections([section], with: .automatic)
        self.tableViewTopic.endUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.topicData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCellTableViewCell", for: indexPath) as! TopicCellTableViewCell
        cell.customInit(cellInSection: indexPath.section, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //guard let tableViewCell = cell as? TopicCellTableViewCell else {return}
    }
    
    func tapVocabulary(cell: TopicCellTableViewCell, cellIndex: Int) {
        print("Did select VocabularyCell: \(cellIndex)")
        performSegue(withIdentifier: "toLearnVocabularyView", sender: self.topicData[cellIndex] )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLearnVocabularyView"{
            if let learnVocabularyVC = segue.destination as? LearnVocabularyViewController{
                guard let topic = sender as? TopicTable else {return}
                learnVocabularyVC.inTopic = topic
            }
        }
    }
    
    func tapGamePlay(cell: TopicCellTableViewCell, cellIndex: Int) {
        print("Did select GamePlayCell: \(cellIndex)")
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
        //debugPrint("offSet: \(lastContentOffset)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //debugPrint("ContentSize: \(scrollView.contentSize.height), ScrollSize: \(scrollView.frame.size.height)")
        if self.lastContentOffset < scrollView.contentOffset.y-80{
            self.scrollDownPopUpTableTopicView()
        }else if self.lastContentOffset > scrollView.contentOffset.y+lastContentOffset{
            self.scrollUpContenOffsetYzero_PopDownTableTopicView()
        }
    }
    
    /*func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
        print("offSet: \(lastContentOffset)")
    }*/

}
