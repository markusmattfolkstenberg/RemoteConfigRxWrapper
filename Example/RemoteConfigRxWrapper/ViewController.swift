  //
  //  ViewController.swift
  //  RemoteConfigRxWrapper
  //
  //  Created by Markus Mattfolk Stenberg on 09/06/2018.
  //  Copyright (c) 2018 Markus Mattfolk Stenberg. All rights reserved.
  //
  
  import UIKit
  import RemoteConfigRxWrapper
  import RxSwift
  import RxCocoa
  import RxOptional
  
  class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      setupAlert()
      setupButton()
      setupLabel()
    }
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
    
    func setupLabel() {
      RemoteConfigRxWrapper.sharedInstance.getStringValue(with: "welcomeTitle").asDriver(onErrorJustReturn: "").drive(self.label.rx.text).disposed(by: self.disposeBag)
    }
    
    func setupButton() {
      self.button.rx.tap.subscribe( onNext: {
        RemoteConfigRxWrapper.sharedInstance.fetchValues()
      }).disposed(by: self.disposeBag)
    }
    
    func setupAlert() {
      RemoteConfigRxWrapper.sharedInstance.getSystemStatusMessageData()
        .filterNil()
        .filter { data in
          if let startDate = data.startDate, startDate > Date() {
            return false
          } else if let endDate = data.endDate, endDate < Date() {
            return false
          } else {
            return true
          }
        }
        .distinctUntilChanged()
        .delay(0.6)
        .drive( onNext: { [unowned self] data in
          let alert = UIAlertController(title: data.title, message: data.text, preferredStyle: UIAlertControllerStyle.alert)
          
          self.present(alert, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }
    
  }
  
