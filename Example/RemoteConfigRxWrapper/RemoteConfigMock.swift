//
//  RemoteConfigMock.swift
//  RemoteConfigRxWrapper_Example
//
//  Created by Markus on 2018-09-06.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import RemoteConfigRxWrapper
import RxSwift

class RemoteConfigMock: RemoteConfigType {
  func getStringValue(with key: String) -> String? {
    return activeValues[key] as? String
  }
  
  func getNumberValue(with key: String) -> NSNumber? {
    return (activeValues[key] as? NSNumber)
  }
  
  func getBoolValue(with key: String) -> Bool {
    return (activeValues[key] as? Bool) ?? false
  }
  
  func activateFetchedValues() {
    activeValues = newValues
  }
  
  required init(defaultValues: [String: NSObject] = [: ]) {
    activeValues = defaultValues
  }
  var activeValues: [String: NSObject]
  var newValues: [String: NSObject] = [: ]
  
  
  func fetchValues() -> Observable<(RemoteConfigFetchStatus)> {
    self.activateFetchedValues()
    return Observable.just(RemoteConfigFetchStatus.success)
  }
}
