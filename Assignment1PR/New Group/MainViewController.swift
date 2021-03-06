//
//  MainViewController.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import UIKit

protocol SceneConfigurationProtocol : AnyObject{
    func configureSceneTypeDelegate(isGrid:Bool)
}

class MainViewController: UIViewController,SceneConfigurationProtocol {
    
    func configureSceneTypeDelegate(isGrid: Bool) {//false = list ,true = grid
        switchSceneType(type: isGrid)
        toggleSceneTypeFlag = isGrid
    }
    
    //MARK: - Outlets
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet var hierarchyLbl: UILabel!
    
    //MARK: - CollectionViewDataFlow custom Variables
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var itemsPerRow:CGFloat = 1
    
    //MARK: - custom Variables
    var itemsArray:[CarNameable]?
    var makeId:String?
    var modelId:String?
    var subModelId:String?
    var trimId:String?
    var trimIdsArray:[String]?
    
    //Hierarchy names
    var hierarchyText:String?
    var modelName:String?
    var subModelName:String?
    var trimName:String?
    
    var slicedSceneNamesArray:[String]?
    weak var delegate:SceneConfigurationProtocol?
    var toggleSceneTypeFlag = false
    
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkWhichScreen()
        setUpUI()
        switchSceneType(type: toggleSceneTypeFlag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    //MARK: - configureBackButton Function
    func configureBackButton(){
        if (navigationController?.viewControllers.count)! > 1 {
            let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_ios_black_18pt"), landscapeImagePhone: #imageLiteral(resourceName: "baseline_arrow_back_ios_black_18pt"), style: .plain, target: self, action: #selector(backPressed))
            self.navigationItem.leftBarButtonItem = newBackButton
        }else{
            self.navigationItem.hidesBackButton = true
        }
    }
    
    //MARK: - Buttons Actions
    @objc func backPressed(){
        navigationController?.popViewController(animated: true)
        delegate?.configureSceneTypeDelegate(isGrid: toggleSceneTypeFlag)
    }
    @objc func toggleSceneType(){
        toggleSceneTypeFlag.toggle()
        switchSceneType(type: toggleSceneTypeFlag)
        collectionV.reloadData()
    }
    
    //MARK: - Custom UIFunctions
    func setUpUI(){
        if hierarchyText != nil{hierarchyLbl.text = hierarchyText}
        configureBackButton()
        let toggleSceneTypeBtn = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(toggleSceneType))
        toggleSceneTypeBtn.title = "Toggle"
        self.navigationItem.rightBarButtonItem  = toggleSceneTypeBtn
        collectionV.register(UINib(nibName: "CollectionVCell", bundle: nil), forCellWithReuseIdentifier: "CollectionVCell")
    }
    
    func switchSceneType(type:Bool){
        if type {
            itemsPerRow = 3
        }else{
            itemsPerRow = 1
        }
        collectionV.reloadData()
    }
    
    func checkWhichScreen() {
        guard let viewControllersCount = navigationController?.viewControllers.count else {return}
        switch viewControllersCount {
        case 1:
            getMake()
        case 2:
            getModelObjects()
        case 3:
            getSubModelObjects()
        case 4:
            getTrims()
        default:
            break
        }
    }
    
    //MARK: - MakeObjects API
    func getMake(){
        configureActivityIndicator(animating: true)
        guard let url = URL(string:UrlsEnum.makeObjApi.rawValue)else{return}
        APIClient.apiRequest(url: url, method: Networker.HttpMethodEnum.get) { (error, data) in
            if error == nil && data != nil{
                do{
                    let makeData = try JSONDecoder().decode([MakeClass].self, from: data!)
                    self.itemsArray = makeData
                }
                catch let error {
                    print(error)
                    return
                }
            }
            self.configureActivityIndicator(animating: false)
            self.collectionV.reloadData()
        }
        
    }
    
    //MARK: - GetModelObjects API
    func getModelObjects(){
        configureActivityIndicator(animating: true)
        guard let url = URL(string:UrlsEnum.modelObjApi.rawValue)else{return}
        
        APIClient.apiRequest(url: url, method: Networker.HttpMethodEnum.get) { (error, data) in
            if error == nil && data != nil{
                do{
                    let ModelData = try JSONDecoder().decode([ModelClass].self, from: data!)
                    self.itemsArray = ModelData
                    
                    var modelArray = self.itemsArray as! [ModelClass]
                    //                modelArray = modelArray.filter({
                    //                    (modelArray) -> Bool in
                    //                    return modelArray.makeId == self.makeId
                    //                })
                    //shortened way $0 is used instead of the (modelClass) parameter(points on the first parameter)
                    modelArray = modelArray.filter({$0.makeId == self.makeId})
                    
                    self.itemsArray = modelArray
                }
                catch let error {
                    print(error)
                    return
                }
            }
            self.configureActivityIndicator(animating: false)
            self.collectionV.reloadData()
        }
        
    }
    
    //MARK: - GetSubModelObjects API
    func getSubModelObjects(){
        configureActivityIndicator(animating: true)
        guard let url = URL(string:UrlsEnum.subModelApi.rawValue)else{return}
        
        APIClient.apiRequest(url: url, method: Networker.HttpMethodEnum.get) { (error, data) in
            if error == nil && data != nil{
                do{
                    let subModelData = try JSONDecoder().decode([SubModelClass].self, from: data!)
                    let submodelArray = subModelData.filter({ (submodelClass) -> Bool in
                        return submodelClass.modelId == self.modelId
                    })
                    self.itemsArray = submodelArray
                }
                catch let error {
                    print(error)
                    return
                }
            }
            self.configureActivityIndicator(animating: false)
            self.collectionV.reloadData()
        }
    }
    
    //MARK: - GetTrims API
    func getTrims(){
        self.configureActivityIndicator(animating: true)
        guard let url = URL(string:UrlsEnum.trimsObjApi.rawValue)else{return}
        
        APIClient.apiRequest(url: url, method: Networker.HttpMethodEnum.get) { (error, data) in
            if error == nil && data != nil{
                
                do{
                    let trimData = try JSONDecoder().decode([TrimsClass].self, from: data!)
                    let trimArray = trimData.filter({ (trimsClass) -> Bool in
                        return (self.trimIdsArray?.contains(trimsClass.id!))!
                    })
                    self.itemsArray = trimArray
                }
                catch let error {
                    print(error.localizedDescription)
                    return
                }
            }
            self.configureActivityIndicator(animating: false)
            self.collectionV.reloadData()
        }
    }
    
    //MARK: - getPrice API
    func getPrice(){
        var urlComponents = URLComponents(string:UrlsEnum.calculationApi.rawValue)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "make_id", value: makeId),
            URLQueryItem(name: "model_id", value: modelId),
            URLQueryItem(name: "submodel_id", value: subModelId),
            URLQueryItem(name: "trim_id", value: trimId),
        ]
        configureActivityIndicator(animating: true)
        guard let url = (urlComponents?.url) else{return}
        APIClient.apiRequest(url: url, method: Networker.HttpMethodEnum.get) { (error, data) in
            if error == nil && data != nil{
                let result = String(data: data!, encoding: String.Encoding.utf8)
                self.displayAlertWithDone(msg: "Result = \(result!)", completion: {
                    self.configureActivityIndicator(animating: false)
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }
            self.configureActivityIndicator(animating: false)
        }
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    //MARK: - CollectionView stubs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numOfItems = 0
        
        guard let viewControllersCount = navigationController?.viewControllers.count else {return 0}
        
        switch viewControllersCount {
        case 1:
            let makeArray = itemsArray as! [MakeClass]?
            guard (makeArray?.count) != nil else{return 0}
            numOfItems = (makeArray?.count)!
        case 2:
            let modelArray = itemsArray as! [ModelClass]?
            guard (modelArray?.count) != nil else{return 0}
            numOfItems = (modelArray?.count)!
        case 3:
            let subModelArray = itemsArray as! [SubModelClass]?
                guard (subModelArray?.count) != nil else{return 0}
            numOfItems = (subModelArray?.count)!
        case 4:
            let trimClass = itemsArray as! [TrimsClass]?
            guard (trimClass?.count) != nil else{return 0}
            numOfItems = (trimClass?.count)!
        default:
            break
        }
        return numOfItems
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let vc = MainViewController(nibName: "MainViewController", bundle: nil) as MainViewController
        vc.delegate = self
        guard let viewControllersCount = navigationController?.viewControllers.count else {return}
        switch viewControllersCount {
        case 1:
            let makeArray = itemsArray as! [MakeClass]
            guard let makeId = makeArray[indexPath.row].id else {  return }
            vc.makeId = makeId
            vc.hierarchyText = makeId
        case 2:
            let modelArray = itemsArray as! [ModelClass]
            guard let modelId = modelArray[indexPath.row].id else { return }
            guard let modelName = modelArray[indexPath.row].name else { return }
            
            vc.modelId = modelId
            vc.makeId = makeId
            vc.modelName = modelName
            vc.hierarchyText = "\(makeId!)/\(modelName)"
            
        case 3:
            let subModelArray = itemsArray as! [SubModelClass]
            guard let subModelId = subModelArray[indexPath.row].id else { return }
            guard let subModelName = subModelArray[indexPath.row].name else { return }
            guard let trimIds = subModelArray[indexPath.row].trimIds else { return }
            vc.modelId = modelId
            vc.subModelId = subModelId
            vc.subModelName = subModelName
            vc.trimIdsArray = trimIds
            vc.modelName = modelName
            vc.makeId = makeId
            vc.hierarchyText = "\(makeId!)/\(modelName!)/\(subModelName)"
        case 4:
            guard trimIdsArray![indexPath.row].count != 0 else {return}
            trimId = trimIdsArray?[indexPath.row]
            hierarchyText = "\(makeId!)/\(modelName!)/\(subModelName!)"
            getPrice()
            return
        default:
            break
        }
        vc.toggleSceneTypeFlag = toggleSceneTypeFlag
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionV.dequeueReusableCell(withReuseIdentifier: "CollectionVCell", for: indexPath) as! CollectionVCell
        guard let viewControllersCount = navigationController?.viewControllers.count else {return cell}
        cell.lbl1.text = itemsArray![indexPath.row].name
        switch viewControllersCount {
        case 1:
            let makeArray = itemsArray as! [MakeClass]
            cell.imgView.downloadedFrom(link: makeArray[indexPath.row].logoUri!)
            cell.imgView.isHidden = false
        default:
            cell.imgView.isHidden = true
            break
        }
        return cell
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionV.reloadData()
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

