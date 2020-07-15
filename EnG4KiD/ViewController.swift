//
//  ViewController.swift
//  EnG4KiD
//
//  Created by An Lê on 2/23/20.
//  Copyright © 2020 An Lê. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var imgMoc1: UIImageView!
    @IBOutlet weak var imgMoc2: UIImageView!
    @IBOutlet weak var imgTenApp: UIImageView!
    
    @IBOutlet weak var btn_batdau: UIButton!
    @IBOutlet weak var btn_dangnhap: UIButton!
//    var btnBatDau:UIButton!
//    var btnDangNhap:UIButton!
    
    var imgMoc1LeadingConstraint:NSLayoutConstraint!
    var imgMoc1TopConstraint:NSLayoutConstraint!
    var imgMoc1BottomConstraint:NSLayoutConstraint!
    var imgMoc1TrailingConstraint:NSLayoutConstraint!
    
    var imgMoc2LeadingConstraint:NSLayoutConstraint!
    var imgMoc2TopConstraint:NSLayoutConstraint!
    var imgMoc2BottomConstraint:NSLayoutConstraint!
    var imgMoc2TrailingConstraint:NSLayoutConstraint!
    
    var btnBDTopConstraint:NSLayoutConstraint!
    var btnBDTrailingConstraint:NSLayoutConstraint!
    var btnBDLeadingConstraint:NSLayoutConstraint!
    var btnBDBottomConstraint:NSLayoutConstraint!
    
    var btnDNTopConstraint:NSLayoutConstraint!
    var btnDNTrailingConstraint:NSLayoutConstraint!
    var btnDNLeadingConstraint:NSLayoutConstraint!
    var btnDNBottomConstraint:NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        addConstraintsForMoc()
        animWithConstraintForMoc()
        addConstraintsForBtn()
        animWithConstraintForBtn()
        if checkCreateData() != true{
            createData()
        }
    }
    
    func checkCreateData() ->Bool{
        let fetchRequest: NSFetchRequest<TopicTable> = TopicTable.fetchRequest()
        do{
            let result = try PersistenceService.context.fetch(fetchRequest)
            if result.count > 0{
                return true
            }
        }catch{}
        return false
    }
    
    func retrieveData(){
        var topic:[TopicTable] = []
        
        let fetchRequest: NSFetchRequest<TopicTable> = TopicTable.fetchRequest()
        let softByTopicTitle = NSSortDescriptor(key: "titleTopic", ascending: false)
        fetchRequest.sortDescriptors = [softByTopicTitle]
        //fetchRequest.predicate = NSPredicate(format: "titleTopic == %@", "School")
        do{
            topic = try PersistenceService.context.fetch(fetchRequest)
            for tp in topic{
                print("TopicName: \(tp.titleTopic ?? "")")
                for vc in tp.manyVocabulary ?? Set<VocabularyTable>(){
                    print("Vocabularies: \(vc.engWord ?? "")")
                }
            }
            
        }catch {
            
        }
        
        let fetchVoca:NSFetchRequest<VocabularyTable> = VocabularyTable.fetchRequest()
        let sortByEngWord = NSSortDescriptor(key: "engWord", ascending: true)
        fetchVoca.sortDescriptors = [sortByEngWord]
        fetchVoca.predicate = NSPredicate(format: "oneTopic == %@",topic[0])
        do{
            let vocabulary = try PersistenceService.context.fetch(fetchVoca)
            for vo in vocabulary{
                print(vo.engWord ?? "A")
            }
        }catch{
            
        }
    }
    
    func createData(){
        //School
        let schoolTopic = TopicTable(context: PersistenceService.context)
        schoolTopic.titleTopic = "School"
        schoolTopic.imgTopic = UIImage(named: "schoolImg")?.pngData()
        ////////
        let schoolWord = VocabularyTable(context: PersistenceService.context)
        schoolWord.engWord = "School"
        schoolWord.vnWord = "Trường Học"
        schoolWord.imgWord = UIImage(named: "schoolWord")?.pngData()
        schoolWord.img1Word = UIImage(named: "school1Word")?.pngData()
        schoolWord.isLearned = false
        schoolWord.oneTopic = schoolTopic
        
        let classroomWord = VocabularyTable(context: PersistenceService.context)
        classroomWord.engWord = "Classroom"
        classroomWord.vnWord = "Lớp Học"
        classroomWord.imgWord = UIImage(named: "classroomWord")?.pngData()
        classroomWord.img1Word = UIImage(named: "classroom1Word")?.pngData()
        classroomWord.isLearned = false
        classroomWord.oneTopic = schoolTopic
        
        let teacherWord = VocabularyTable(context: PersistenceService.context)
        teacherWord.engWord = "Teacher"
        teacherWord.vnWord = "Giáo Viên"
        teacherWord.imgWord = UIImage(named: "teacherWord")?.pngData()
        teacherWord.img1Word = UIImage(named: "teacher1Word")?.pngData()
        teacherWord.isLearned = false
        teacherWord.oneTopic = schoolTopic
        
        let studentWord = VocabularyTable(context: PersistenceService.context)
        studentWord.engWord = "Student"
        studentWord.vnWord = "Học Sinh"
        studentWord.imgWord = UIImage(named: "studentWord")?.pngData()
        studentWord.img1Word = UIImage(named: "student1Word")?.pngData()
        studentWord.isLearned = false
        studentWord.oneTopic = schoolTopic
        
        let tableWord = VocabularyTable(context: PersistenceService.context)
        tableWord.engWord = "Table"
        tableWord.vnWord = "Cái Bàn"
        tableWord.imgWord = UIImage(named: "tableWord")?.pngData()
        tableWord.img1Word = UIImage(named: "table1Word")?.pngData()
        tableWord.isLearned = false
        tableWord.oneTopic = schoolTopic
        
        schoolTopic.manyVocabulary = [schoolWord,classroomWord,teacherWord,studentWord,tableWord]
        ////////
        
        //Family
        let familyTopic = TopicTable(context: PersistenceService.context)
        familyTopic.titleTopic = "Family"
        familyTopic.imgTopic = UIImage(named: "familyImg")?.pngData()
        ////////
        let fatherWord = VocabularyTable(context: PersistenceService.context)
        fatherWord.engWord = "Father"
        fatherWord.vnWord = "Cha"
        fatherWord.imgWord = UIImage(named: "fatherWord")?.pngData()
        fatherWord.img1Word = UIImage(named: "father1Word")?.pngData()
        fatherWord.isLearned = false
        fatherWord.oneTopic = familyTopic
        
        let grandfatherWord = VocabularyTable(context: PersistenceService.context)
        grandfatherWord.engWord = "Grandfather"
        grandfatherWord.vnWord = "Ông Nội, Ngoại"
        grandfatherWord.imgWord = UIImage(named: "grandfatherWord")?.pngData()
        grandfatherWord.img1Word = UIImage(named: "grandfather1Word")?.pngData()
        grandfatherWord.isLearned = false
        grandfatherWord.oneTopic = familyTopic
        
        let motherWord = VocabularyTable(context: PersistenceService.context)
        motherWord.engWord = "Mother"
        motherWord.vnWord = "Mẹ"
        motherWord.imgWord = UIImage(named: "motherWord")?.pngData()
        motherWord.img1Word = UIImage(named: "mother1Word")?.pngData()
        motherWord.isLearned = false
        motherWord.oneTopic = familyTopic
        
        let grandmotherWord = VocabularyTable(context: PersistenceService.context)
        grandmotherWord.engWord = "Grandmother"
        grandmotherWord.vnWord = "Bà Nội, Ngoại"
        grandmotherWord.imgWord = UIImage(named: "grandmotherWord")?.pngData()
        grandmotherWord.img1Word = UIImage(named: "grandmother1Word")?.pngData()
        grandmotherWord.isLearned = false
        grandmotherWord.oneTopic = familyTopic
        
        familyTopic.manyVocabulary = [fatherWord,grandfatherWord,motherWord,grandmotherWord]
        //////
        
        //Animal
        let animalTopic = TopicTable(context: PersistenceService.context)
        animalTopic.titleTopic = "Animal"
        animalTopic.imgTopic = UIImage(named: "animalImg")?.pngData()
        ///////
        let catWord = VocabularyTable(context: PersistenceService.context)
        catWord.engWord = "Cat"
        catWord.vnWord = "Con Mèo"
        catWord.imgWord = UIImage(named: "catVocabulary")?.pngData()
        catWord.img1Word = UIImage(named: "cat1Word")?.pngData()
        catWord.isLearned = false
        catWord.oneTopic = animalTopic
        
        let dogWord = VocabularyTable(context: PersistenceService.context)
        dogWord.engWord = "Dog"
        dogWord.vnWord = "Con Chó"
        dogWord.imgWord = UIImage(named: "dogImg")?.pngData()
        dogWord.img1Word = UIImage(named: "dog1Word")?.pngData()
        dogWord.isLearned = false
        dogWord.oneTopic = animalTopic
        
        let snakeWord = VocabularyTable(context: PersistenceService.context)
        snakeWord.engWord = "Snake"
        snakeWord.vnWord = "Con Rắn"
        snakeWord.imgWord = UIImage(named: "snakeImg")?.pngData()
        snakeWord.img1Word = UIImage(named: "snake1Word")?.pngData()
        snakeWord.isLearned = false
        snakeWord.oneTopic = animalTopic
        
        let turtleWord = VocabularyTable(context: PersistenceService.context)
        turtleWord.engWord = "Turtle"
        turtleWord.vnWord = "Con Rùa"
        turtleWord.imgWord = UIImage(named: "turtleImg")?.pngData()
        turtleWord.img1Word = UIImage(named: "turtle1Word")?.pngData()
        turtleWord.isLearned = false
        turtleWord.oneTopic = animalTopic
        
        let birdWord = VocabularyTable(context: PersistenceService.context)
        birdWord.engWord = "Bird"
        birdWord.vnWord = "Con Chim"
        birdWord.imgWord = UIImage(named: "birdWord")?.pngData()
        birdWord.img1Word = UIImage(named: "bird1Word")?.pngData()
        birdWord.isLearned = false
        birdWord.oneTopic = animalTopic
        
        animalTopic.manyVocabulary = [catWord,dogWord,snakeWord,turtleWord,birdWord]
        //////
        
        //Fruits
        let fruitsTopic = TopicTable(context: PersistenceService.context)
        fruitsTopic.titleTopic = "Fruits"
        fruitsTopic.imgTopic = UIImage(named: "fruitsImg")?.pngData()
        //////
        let orangeWord = VocabularyTable(context: PersistenceService.context)
        orangeWord.engWord = "Orange"
        orangeWord.vnWord = "Trái Cam"
        orangeWord.imgWord = UIImage(named: "orangeWord")?.pngData()
        orangeWord.img1Word = UIImage(named: "orange1Word")?.pngData()
        orangeWord.isLearned = false
        orangeWord.oneTopic = fruitsTopic
        
        let bananaWord = VocabularyTable(context: PersistenceService.context)
        bananaWord.engWord = "Banana"
        bananaWord.vnWord = "Trái Chuối"
        bananaWord.imgWord = UIImage(named: "bananaWord")?.pngData()
        bananaWord.img1Word = UIImage(named: "banana1Word")?.pngData()
        bananaWord.isLearned = false
        bananaWord.oneTopic = fruitsTopic
        
        let grapeWord = VocabularyTable(context: PersistenceService.context)
        grapeWord.engWord = "Grape"
        grapeWord.vnWord = "Trái Nho"
        grapeWord.imgWord = UIImage(named: "grapeWord")?.pngData()
        grapeWord.img1Word = UIImage(named: "grape1Word")?.pngData()
        grapeWord.isLearned = false
        grapeWord.oneTopic = fruitsTopic
        
        let strawberryWord = VocabularyTable(context: PersistenceService.context)
        strawberryWord.engWord = "Strawberry"
        strawberryWord.vnWord = "Trái Dâu"
        strawberryWord.imgWord = UIImage(named: "strawberryWord")?.pngData()
        strawberryWord.img1Word = UIImage(named: "strawberry1Word")?.pngData()
        strawberryWord.isLearned = false
        strawberryWord.oneTopic = fruitsTopic
        
        let appleWord = VocabularyTable(context: PersistenceService.context)
           appleWord.engWord = "Apple"
           appleWord.vnWord = "Trái Táo"
           appleWord.imgWord = UIImage(named: "appleWord")?.pngData()
        appleWord.img1Word = UIImage(named: "apple1Word")?.pngData()
           appleWord.isLearned = false
           appleWord.oneTopic = fruitsTopic
        
        fruitsTopic.manyVocabulary = [orangeWord,bananaWord,grapeWord,strawberryWord,appleWord]
        
        //ColorTopic
        let colorTopic = TopicTable(context: PersistenceService.context)
        colorTopic.titleTopic = "Colors"
        colorTopic.imgTopic = UIImage(named: "colorImgTopic")?.pngData()
        
        let redWord = VocabularyTable(context: PersistenceService.context)
           redWord.engWord = "Red"
           redWord.vnWord = "Màu Đỏ"
           redWord.imgWord = UIImage(named: "redWord")?.pngData()
        redWord.img1Word = UIImage(named: "red1Word")?.pngData()
           redWord.isLearned = false
           redWord.oneTopic = fruitsTopic
        
        let yellowWord = VocabularyTable(context: PersistenceService.context)
           yellowWord.engWord = "Yellow"
           yellowWord.vnWord = "Màu Vàng"
           yellowWord.imgWord = UIImage(named: "yellowWord")?.pngData()
        yellowWord.img1Word = UIImage(named: "yellow1Word")?.pngData()
           yellowWord.isLearned = false
           yellowWord.oneTopic = fruitsTopic
        
        let blueWord = VocabularyTable(context: PersistenceService.context)
           blueWord.engWord = "Blue"
           blueWord.vnWord = "Màu Xanh"
           blueWord.imgWord = UIImage(named: "blueWord")?.pngData()
        blueWord.img1Word = UIImage(named: "blue1Word")?.pngData()
           blueWord.isLearned = false
           blueWord.oneTopic = fruitsTopic
        
        let pinkWord = VocabularyTable(context: PersistenceService.context)
           pinkWord.engWord = "Pink"
           pinkWord.vnWord = "Màu Hồng"
           pinkWord.imgWord = UIImage(named: "pinkWord")?.pngData()
        pinkWord.img1Word = UIImage(named: "pink1Word")?.pngData()
           pinkWord.isLearned = false
           pinkWord.oneTopic = fruitsTopic
        
        let greenWord = VocabularyTable(context: PersistenceService.context)
           greenWord.engWord = "Green"
           greenWord.vnWord = "Màu Xanh Lá"
           greenWord.imgWord = UIImage(named: "greenWord")?.pngData()
        greenWord.img1Word = UIImage(named: "green1Word")?.pngData()
           greenWord.isLearned = false
           greenWord.oneTopic = fruitsTopic
        
        colorTopic.manyVocabulary = [redWord,yellowWord,blueWord,pinkWord,greenWord]
        
        PersistenceService.saveContext()
        
    }

    @IBAction func tapToMainView(_ sender: Any) {
       /* self.dismiss(animated: true) {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "MainVC")
            //self.present(vc, animated: true)
            self.showDetailViewController(vc, sender: nil)
            
        }*/
        performSegue(withIdentifier: "toMainView", sender: nil)
    }
    
    
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue){
        
    }
    /*private func initBtn(){
        let imgBtnBD:UIImage! = UIImage(named: "btn_batdau.png")
        btnBatDau = UIButton()
        btnBatDau.setTitle("", for: .normal)
        btnBatDau.setImage(imgBtnBD, for: .normal)
        self.view.addSubview(btnBatDau)
        
        let imgBtnDN:UIImage! = UIImage(named: "btn_dangnhap.png")
        btnDangNhap = UIButton()
        btnDangNhap.setTitle("", for: .normal)
        btnDangNhap.setImage(imgBtnDN, for: .normal)
        self.view.addSubview(btnDangNhap)
    }*/
    
    private func addConstraintsForMoc(){
        self.imgMoc1.translatesAutoresizingMaskIntoConstraints = false
        self.imgMoc2.translatesAutoresizingMaskIntoConstraints = false
        
        self.imgMoc1LeadingConstraint = NSLayoutConstraint(item: self.imgMoc1 ?? UIImageView(), attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: -130)
        
        self.imgMoc1TopConstraint = NSLayoutConstraint(item: self.imgMoc1 ?? UIImageView(), attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 50)
        
        self.imgMoc1BottomConstraint = NSLayoutConstraint(item: self.imgMoc1 ?? UIImageView(), attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -250)
        
        self.imgMoc1TrailingConstraint = NSLayoutConstraint(item: self.imgMoc1 ?? UIImageView(), attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -(self.view.frame.width/2)-(self.view.frame.width/6))
       
        self.imgMoc2LeadingConstraint = NSLayoutConstraint(item: self.imgMoc2 ?? UIImageView(), attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: -225)
        
        self.imgMoc2TopConstraint = NSLayoutConstraint(item: self.imgMoc2 ?? UIImageView(), attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 85)
        
        self.imgMoc2BottomConstraint = NSLayoutConstraint(item: self.imgMoc2 ?? UIImageView(), attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -310)
       
        self.imgMoc2TrailingConstraint = NSLayoutConstraint(item: self.imgMoc2 ?? UIImageView(), attribute: .trailing, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -(self.view.frame.width/2)+(self.view.frame.width/4))
        self.view.addConstraints([self.imgMoc1LeadingConstraint,self.imgMoc1TopConstraint,self.imgMoc1BottomConstraint,self.imgMoc1TrailingConstraint,self.imgMoc2LeadingConstraint,self.imgMoc2TopConstraint,self.imgMoc2BottomConstraint,self.imgMoc2TrailingConstraint])
    }
    
    private func addConstraintsForBtn(){
        
        self.btn_batdau.translatesAutoresizingMaskIntoConstraints = false
        self.btn_dangnhap.translatesAutoresizingMaskIntoConstraints = false
        
        self.btnBDTopConstraint = NSLayoutConstraint(item: self.btn_batdau ?? UIButton(), attribute: .top, relatedBy: .equal, toItem: self.imgMoc1, attribute: .top, multiplier: 1, constant: (self.imgMoc1.frame.height)-(self.imgMoc1.frame.height/4))
        
        self.btnBDBottomConstraint = NSLayoutConstraint(item: self.btn_batdau ?? UIButton(), attribute: .bottom, relatedBy: .equal, toItem: self.imgMoc1, attribute: .bottom, multiplier: 1, constant: (self.imgMoc1.frame.height/6))
        
        self.btnBDLeadingConstraint = NSLayoutConstraint(item: self.btn_batdau ?? UIButton(), attribute: .leading, relatedBy: .equal, toItem: self.imgMoc1, attribute: .leading, multiplier: 1, constant: self.imgMoc1.frame.width/4)
        
        self.btnBDTrailingConstraint = NSLayoutConstraint(item: self.btn_batdau ?? UIButton(), attribute: .trailing, relatedBy: .equal, toItem: self.imgMoc1, attribute: .trailing, multiplier: 1, constant: self.imgMoc1.frame.width/3)
        
        self.btnDNTopConstraint = NSLayoutConstraint(item: self.btn_dangnhap ?? UIButton(), attribute: .top, relatedBy: .equal, toItem: self.imgMoc2, attribute: .top, multiplier: 1, constant: (self.imgMoc2.frame.height)-(self.imgMoc2.frame.height/4))
        
        self.btnDNBottomConstraint = NSLayoutConstraint(item: self.btn_dangnhap ?? UIButton(), attribute: .bottom, relatedBy: .equal, toItem: self.imgMoc1, attribute: .bottom, multiplier: 1, constant: (self.imgMoc2.frame.height/12))
        
        self.btnDNLeadingConstraint = NSLayoutConstraint(item: self.btn_dangnhap ?? UIButton(), attribute: .leading, relatedBy: .equal, toItem: self.imgMoc1, attribute: .leading, multiplier: 1, constant: (self.imgMoc2.frame.width)-(self.imgMoc2.frame.width/3))
        
        self.btnDNTrailingConstraint = NSLayoutConstraint(item: self.btn_dangnhap ?? UIButton(), attribute: .trailing, relatedBy: .equal, toItem: self.imgMoc2, attribute: .trailing, multiplier: 1, constant: self.imgMoc2.frame.width/8)
        
        self.view.addConstraints([self.btnBDTopConstraint,self.btnBDBottomConstraint,self.btnBDLeadingConstraint,self.btnBDTrailingConstraint,self.btnDNTopConstraint,self.btnDNBottomConstraint,self.btnDNLeadingConstraint,self.btnDNTrailingConstraint])
    }
    
   /* private func showMoc(){
        animForMoc(inst: self.imgMoc1, delay: 0.5, transX: 130, transY: 0)
        animForMoc(inst: self.imgMoc2, delay: 1, transX: 225, transY: 0)
    }
    
    private func animForMoc(inst: UIImageView,delay: Double,transX: CGFloat,transY: CGFloat){
        
        UIView.animate(withDuration: 1,delay: delay,usingSpringWithDamping: 0.3, initialSpringVelocity: 5,options: [],animations: {
            inst.transform = CGAffineTransform(translationX: transX, y: transY)
        })
    }*/
    
    private func animWithConstraintForMoc(){
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: [], animations: {
        
            self.imgMoc1LeadingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 1,usingSpringWithDamping: 0.5,initialSpringVelocity: 3, options: [], animations: {
            
            self.imgMoc2LeadingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    private func animWithConstraintForBtn(){
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
    }

}

