//
//  MainViewController.swift
//  Assignment1PR
//
//  Created by Sanad Barjawi on 7/15/18.
//  Copyright © 2018 Sanad Barjawi. All rights reserved.
//

import UIKit

protocol SceneConfigurationDelegate : AnyObject{
    func configureSceneType(isGrid:Bool)
}

class MainViewController: UIViewController,SceneConfigurationDelegate {
    func configureSceneType(isGrid: Bool) {//false = list ,true = grid
              switchSceneType(type: isGrid)
    }
    
    //MARK: - Outlets
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var sceneHierarchyStackView: UIStackView!
    
    //MARK: - CollectionViewDataFlow custom Variables
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var itemsPerRow:CGFloat = 1
    
    //MARK: - custom Variables
    var makeArray : [MakeClass]?
    var modelArray : [ModelClass]?
    var subModelArray : [SubModelClass]?
    var trimArray : [TrimsClass]?
    var makeId:String?
    var modeId:String?
    var subModelId:String?
    var trimId:String?
    var urls:Urls?
    weak var delegate:SceneConfigurationDelegate?
    var toggleSceneTypeFlag = false
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        urls = Urls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        switchSceneType(type: toggleSceneTypeFlag)
        checkWhichScreen()
        setUpUI()
    }

    //MARK: - SetUpUI Function
    func setUpUI(){

        if (navigationController?.viewControllers.count)! > 1 {
            let newBackButton = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_ios_black_18pt"), landscapeImagePhone: #imageLiteral(resourceName: "baseline_arrow_back_ios_black_18pt"), style: .plain, target: self, action: #selector(backPressed))
            self.navigationItem.leftBarButtonItem = newBackButton
        }else{
            self.navigationItem.hidesBackButton = true
        }
        
        let toggleSceneTypeBtn = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(toggleSceneType))
        toggleSceneTypeBtn.title = "Toggle"
        self.navigationItem.rightBarButtonItem  = toggleSceneTypeBtn
        collectionV.register(UINib(nibName: "CollectionVCell", bundle: nil), forCellWithReuseIdentifier: "CollectionVCell")
    }
    
    @objc func backPressed(){
        navigationController?.popViewController(animated: true)
        delegate?.configureSceneType(isGrid: toggleSceneTypeFlag)
    }
    func switchSceneType(type:Bool){
        if type {
            itemsPerRow = 3
        }else{
            itemsPerRow = 1
        }
        /////here
        collectionV.reloadData()
    }
    @objc func toggleSceneType(){

        toggleSceneTypeFlag.toggle()
        switchSceneType(type: toggleSceneTypeFlag)
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
        
        guard let urlString = urls?.makeObjApi  else { return }
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
       guard let urlString = urls?.modelObjApi  else { return }
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
        
        guard let urlString = urls?.subModelApi  else { return }
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
        guard let urlString = urls?.trimsObjApi  else { return }
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
        guard let urlString = urls?.calculationApi  else { return }
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
        
        
        let vc = MainViewController(nibName: "MainViewController", bundle: nil)
        vc.delegate = self
        guard let viewControllersCount = navigationController?.viewControllers.count else {return}
        switch viewControllersCount {
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
        cell.imgView.image = nil
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

