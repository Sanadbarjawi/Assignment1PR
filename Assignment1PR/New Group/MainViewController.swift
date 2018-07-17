//
//  MainViewController.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    //MARK: - CollectionViewDataFlow custom Variables
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let itemsPerRow:CGFloat = 1
    
    //MARK: - custom Variables
    var makeArray : [MakeClass]?
    var modelArray : [ModelClass]?
    var subModelArray : [SubModelClass]?
    var trimArray : [TrimsClass]?
    
    var makeId:String?
    var modeId:String?
    var subModelId:String?
    var trimId:String?
    
    var currentSceneIndex = 0
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkWhichScreen()
        setUpUI()
    }
    
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - SetUpUI Function
    func setUpUI(){
        collectionV.register(UINib(nibName: "CollectionVCell", bundle: nil), forCellWithReuseIdentifier: "CollectionVCell")
    }

    func checkWhichScreen() {
        guard let viewControllersCount = navigationController?.viewControllers.count else {return}
        switch viewControllersCount {
        case 1:
            currentSceneIndex = 1
            getMake()
        case 2:
            currentSceneIndex = 2
            getModelObjects()
        case 3:
            currentSceneIndex = 3
            getSubModelObjects()
        case 4:
            currentSceneIndex = 4
            getTrims()
        default:
            currentSceneIndex = 5
            getPrice()
        }
    }
    //MARK: - MakeObjects API
    func getMake(){
        let urlString = Urls.sharedInstance.makeObjApi
        guard let url = URL(string: urlString) else { return }
        configureActivityIndicator(animating: true)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let makeData = try JSONDecoder().decode([MakeClass].self, from: data)
                self.makeArray = makeData

                DispatchQueue.main.async {
                    self.collectionV.reloadData()
                    self.configureActivityIndicator(animating: false)
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    //MARK: - GetModelObjects API
    func getModelObjects(){
        let urlString = Urls.sharedInstance.modelObjApi
        guard let url = URL(string: urlString) else { return }
        configureActivityIndicator(animating: true)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            guard let data = data else { return }
            do {
                let ModelData = try JSONDecoder().decode([ModelClass].self, from: data)
                self.modelArray = ModelData
                //Get back to the main queue
                DispatchQueue.main.async {
                    
                  self.modelArray = self.modelArray?.filter({ (modelClass) -> Bool in
                        modelClass.makeId == self.makeId
                   })
                    self.collectionV.reloadData()
                    self.configureActivityIndicator(animating: false)
                }
            } catch{
                self.configureActivityIndicator(animating: false)
                return
            }
            }.resume()
    }
    
    //MARK: - GetSubModelObjects API
    func getSubModelObjects(){
        
        let urlString = Urls.sharedInstance.subModelApi
        guard let url = URL(string: urlString) else { return }
        configureActivityIndicator(animating: true)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            guard let data = data else { return }
            do {
                let subModelData = try JSONDecoder().decode([SubModelClass].self, from: data)
                 self.subModelArray = subModelData
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.subModelArray = self.subModelArray?.filter({ (subModelClass) -> Bool in
                       return subModelClass.modelId == self.modeId
                    })
                    self.collectionV.reloadData()
                    self.configureActivityIndicator(animating: false)
                }
            } catch {
                self.configureActivityIndicator(animating: false)
                return

            }
            }.resume()
    }
    
    
    //MARK: - GetTrims API
    func getTrims(){
        let urlString = Urls.sharedInstance.trimsObjApi
        guard let url = URL(string: urlString) else { return }
        
        configureActivityIndicator(animating: true)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            
            guard let data = data else { return }
            do {
                let trimData = try JSONDecoder().decode([TrimsClass].self, from: data)
                self.trimArray = trimData

                //Get back to the main queue
                DispatchQueue.main.async {
                    self.trimArray = self.trimArray?.filter({ (trimsClass) -> Bool in
                       return trimsClass.makeId == self.makeId
                    })
                    self.collectionV.reloadData()
                    self.configureActivityIndicator(animating: false)
                }
            } catch  {
                self.configureActivityIndicator(animating: false)
                return

            }
            }.resume()
    }
    
    //MARK: - getPrice API
    func getPrice(){
        let urlString = Urls.sharedInstance.calculationApi
        //params:make_id=&model_id=&submodel_id=&trim_id=
        var urlComponents = URLComponents(string: urlString)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "make_id", value: makeId),
            URLQueryItem(name: "model_id", value: modeId),
            URLQueryItem(name: "submodel_id", value: subModelId),
            URLQueryItem(name: "trim_id", value: trimId),
        ]
        configureActivityIndicator(animating: true)
        URLSession.shared.dataTask(with: (urlComponents?.url)!) { (data, response, error) in
            if error != nil {
                self.configureActivityIndicator(animating: false)
                return
            }
            
            if let data = data {
                let result = String(data: data, encoding: String.Encoding.utf8)
                self.displayAlertWithDone(msg: "Result = \(result!)", completion: {
                    self.configureActivityIndicator(animating: false)
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
            }.resume()
    }
}


extension MainViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    //MARK: - CollectionView stubs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numOfItems = 0
        
        switch currentSceneIndex {
        case 1:
            guard let makeArrayCount = makeArray?.count else { return numOfItems }
            numOfItems = makeArrayCount
        case 2:
            guard let modelArrayCount = modelArray?.count else { return numOfItems }
            numOfItems = modelArrayCount
        case 3:
            guard let subModelCount = subModelArray?.count else { return numOfItems }
            numOfItems = subModelCount
        case 4:
            guard let TrimArrayCount = trimArray?.count else { return numOfItems }
            numOfItems = TrimArrayCount
        default:
            print("mmmm")
        }
        return numOfItems
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let vc = MainViewController(nibName: "MainViewController", bundle: nil)
        switch currentSceneIndex {
        case 1:
            guard let makeId = makeArray![indexPath.row].id else {  return }
            vc.makeId = makeId
        case 2:
            guard let modelId = modelArray![indexPath.row].id else { return }
            vc.modeId = modelId
            vc.makeId = makeId
        case 3:
            guard let subModelId = subModelArray![indexPath.row].id else { return }
            vc.subModelId = subModelId
            vc.modeId = modeId
            vc.makeId = makeId
        case 4:
            guard let trimId = trimArray![indexPath.row].id else { return }
            vc.trimId = trimId
            vc.subModelId = subModelId
            vc.modeId = modeId
            vc.makeId = makeId
        default:
            print("mmmm")
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionV.dequeueReusableCell(withReuseIdentifier: "CollectionVCell", for: indexPath) as! CollectionVCell
        
        switch currentSceneIndex {
        case 1:
            guard makeArray != nil else{return cell}
            cell.imgView.isHidden = false
            cell.imgView.downloadedFrom(link: makeArray![indexPath.row].logoUri!)
            cell.lbl1.text = makeArray![indexPath.row].name
        case 2:
            guard modelArray != nil else{return cell}
            cell.imgView.isHidden = true
            cell.lbl1.text = modelArray![indexPath.row].name
        case 3:
            guard subModelArray != nil else{return cell}
            cell.imgView.isHidden = true
            cell.lbl1.text = subModelArray![indexPath.row].name
        case 4:
            guard trimArray != nil else{return cell}
            cell.imgView.isHidden = true
            cell.lbl1.text = trimArray![indexPath.row].name
        case 5:
            print("mmm")
        default:
            print("mmm")
        }
        
        return cell
    }
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

