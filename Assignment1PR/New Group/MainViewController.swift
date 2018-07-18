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
    }
    
    //MARK: - Outlets
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet var hierarchyLbl: UILabel!
    
    //MARK: - CollectionViewDataFlow custom Variables
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var itemsPerRow:CGFloat = 1
    
    //MARK: - custom Variables
    var makeArray : [MakeClass]?
    var modelArray : [ModelClass]?
    var subModelArray : [SubModelClass]?
    var trimArray : [TrimsClass]?
    var makeId:String?
    var modelId:String?
    var subModelId:String?
    var trimId:String?
    var trimIdsArray:[String]?
    
    //names
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkWhichScreen()
        setUpUI()
        switchSceneType(type: toggleSceneTypeFlag)
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
        
       let urlString = UrlsEnum.makeObjApi.rawValue
        guard let url = URL(string: urlString) else { return }
        configureActivityIndicator(animating: true)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
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
                return
            }
            }.resume()
    }
    
    //MARK: - GetModelObjects API
    func getModelObjects(){
        let urlString = UrlsEnum.modelObjApi.rawValue
        guard let url = URL(string: urlString) else { return }
        configureActivityIndicator(animating: true)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)

                return
            }
            
            guard let data = data else { return }
            do {
                let ModelData = try JSONDecoder().decode([ModelClass].self, from: data)
                self.modelArray = ModelData
                //Get back to the main queue
                self.modelArray = self.modelArray?.filter({ (modelClass) -> Bool in
                    modelClass.makeId == self.makeId
                })
                DispatchQueue.main.async {
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
        
        let urlString = UrlsEnum.subModelApi.rawValue
        guard let url = URL(string: urlString) else { return }
        configureActivityIndicator(animating: true)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            guard let data = data else { return }
            do {
                let subModelData = try JSONDecoder().decode([SubModelClass].self, from: data)
                 self.subModelArray = subModelData
                //Get back to the main queue
                self.subModelArray = self.subModelArray?.filter({ (subModelClass) -> Bool in
                    return subModelClass.modelId == self.modelId
                })
                DispatchQueue.main.async {
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
        let urlString = UrlsEnum.trimsObjApi.rawValue
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

                self.trimArray = self.trimArray?.filter({ (trimsClass) -> Bool in
                    return trimsClass.id == self.trimId
                })
                //Get back to the main queue
                DispatchQueue.main.async {
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
        let urlString = UrlsEnum.calculationApi.rawValue
        //params:make_id=&model_id=&submodel_id=&trim_id=
        var urlComponents = URLComponents(string: urlString)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "make_id", value: makeId),
            URLQueryItem(name: "model_id", value: modelId),
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
        
        guard let viewControllersCount = navigationController?.viewControllers.count else {return 0}
 
        switch viewControllersCount {
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
            guard let makeId = makeArray![indexPath.row].id else {  return }
            vc.makeId = makeId
            vc.hierarchyText = makeId
        case 2:
            guard let modelId = modelArray![indexPath.row].id else { return }
            guard let modelName = modelArray![indexPath.row].name else { return }

            vc.modelId = modelId
            vc.makeId = makeId
            vc.modelName = modelName
            vc.hierarchyText = "\(makeId!)/\(modelName)"
            
        case 3:
            guard let subModelId = subModelArray![indexPath.row].id else { return }
            guard let subModelName = subModelArray![indexPath.row].name else { return }
            guard let trimIds = subModelArray![indexPath.row].trimIds else { return }

            vc.subModelId = subModelId
            vc.subModelName = subModelName
            vc.trimId = trimIds[0]
            vc.makeId = makeId
            vc.hierarchyText = "\(makeId!)/\(modelName!)/\(subModelName)"
        case 4:
            guard let trimId = trimArray![indexPath.row].id else { return }
            vc.trimId = trimId
            vc.subModelId = subModelId
            vc.modelId = modelId
            vc.makeId = makeId
            vc.title = SceneNames.trimScene.rawValue
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
        switch viewControllersCount {
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
        default:
            break
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

