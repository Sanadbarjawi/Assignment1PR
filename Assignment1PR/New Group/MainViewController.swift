//
//  MainViewController.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    //MARK: - Outlets
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - CollectionViewDataFlow custom Variables
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let itemsPerRow:CGFloat = 2
    
    //MARK: - custom Variables
    var makeArray = [MakeClass]()
    var modelArray = [ModelClass]()
    var subModelArray = [SubModelClass]()
    var TrimArray = [TrimsClass]()
    
    var flag = 0
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkWhichScreen()
        setUpUI()
    }
    
    //MARK: - CollectionView stubs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numOfItems = 0
        
        switch flag {
        case 1:
            numOfItems = makeArray.count
        case 2:
            numOfItems = modelArray.count
        case 3:
            numOfItems = subModelArray.count
        case 4:
            numOfItems = TrimArray.count
        default:
            print("mmmm")
        }
        return numOfItems
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select item")
        
        switch flag {
        case 1:
            Manager.sharedInstance.make_id = makeArray[indexPath.row].id!
        case 2:
            Manager.sharedInstance.model_id = modelArray[indexPath.row].id!
        case 3:
            Manager.sharedInstance.submodel_id = subModelArray[indexPath.row].id!
        case 4:
            Manager.sharedInstance.trim_id = TrimArray[indexPath.row].id!
        default:
            print("mmmm")
        }
        
        let vc = MainViewController(nibName: "MainViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionV.dequeueReusableCell(withReuseIdentifier: "CollectionVCell", for: indexPath) as! CollectionVCell
        
        switch flag {
        case 1:
            cell.imgView.isHidden = false
            cell.imgView.downloadedFrom(link: makeArray[indexPath.row].logo_uri!)
            cell.lbl1.text = makeArray[indexPath.row].name
        case 2:
            cell.imgView.isHidden = true
            cell.lbl1.text = modelArray[indexPath.row].name
        case 3:
            cell.imgView.isHidden = true
            cell.lbl1.text = subModelArray[indexPath.row].name
        case 4:
            cell.imgView.isHidden = true
            cell.lbl1.text = TrimArray[indexPath.row].name
        case 5:
            print("mmm")
        default:
            print("mmm")
        }
        
        return cell
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - SetUpUI Function
    func setUpUI(){
        collectionV.register(UINib(nibName: "CollectionVCell", bundle: nil), forCellWithReuseIdentifier: "CollectionVCell")
    }
    func checkWhichScreen(){
        switch navigationController?.viewControllers.count {
        case 1?:
            flag = 1
            GetMake()
        case 2?:
            flag = 2
            GetModelObjects()
        case 3?:
            flag = 3
            GetSubModelObjects()
        case 4?:
            flag = 4
            GetTrims()
        default:
            flag = 5
            dotheMath()
            print("mmm")
        }
    }
    //MARK: - MakeObjects API
    func GetMake(){
        let urlString = Urls.sharedInstance.makeObjApi
        guard let url = URL(string: urlString) else { return }
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let makeData = try JSONDecoder().decode([MakeClass].self, from: data)
                Manager.sharedInstance.makeClassObj = makeData
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.makeArray = Manager.sharedInstance.makeClassObj
                    self.collectionV.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    //MARK: - GetModelObjects API
    func GetModelObjects(){
        let urlString = Urls.sharedInstance.modelObjApi
        guard let url = URL(string: urlString) else { return }
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let ModelData = try JSONDecoder().decode([ModelClass].self, from: data)
                Manager.sharedInstance.modelClassObj = ModelData
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.modelArray = Manager.sharedInstance.modelClassObj
                    self.collectionV.reloadData()
                    self.activityIndicator.stopAnimating()
                    
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    //MARK: - GetSubModelObjects API
    func GetSubModelObjects(){
        let urlString = Urls.sharedInstance.subModelApi
        guard let url = URL(string: urlString) else { return }
        self.activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let subModelData = try JSONDecoder().decode([SubModelClass].self, from: data)
                Manager.sharedInstance.SubModelClassObj = subModelData
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.subModelArray = Manager.sharedInstance.SubModelClassObj
                    self.collectionV.reloadData()
                    self.activityIndicator.stopAnimating()
                    
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    
    //MARK: - GetTrims API
    func GetTrims(){
        let urlString = Urls.sharedInstance.trimsObjApi
        guard let url = URL(string: urlString) else { return }
        
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let trimData = try JSONDecoder().decode([TrimsClass].self, from: data)
                Manager.sharedInstance.TrimClassObj = trimData
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.TrimArray = Manager.sharedInstance.TrimClassObj
                    self.collectionV.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    //MARK: - dotheMath API
    func dotheMath(){
        let urlString = Urls.sharedInstance.calculationApi
        //params:make_id=&model_id=&submodel_id=&trim_id=
        
        var urlComponents = URLComponents(string: urlString)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "make_id", value: Manager.sharedInstance.make_id),
            URLQueryItem(name: "model_id", value: Manager.sharedInstance.model_id),
            URLQueryItem(name: "submodel_id", value: Manager.sharedInstance.submodel_id),
            URLQueryItem(name: "trim_id", value: Manager.sharedInstance.trim_id),
        ]
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: (urlComponents?.url)!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            if let data = data {
                let result = String(data: data, encoding: String.Encoding.utf8)
                self.displayAlertWithDone(msg: "Result = \(result!)", completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
            }.resume()
        activityIndicator.stopAnimating()
        
    }
    
}


extension MainViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

