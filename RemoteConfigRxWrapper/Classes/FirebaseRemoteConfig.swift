//
//  FirebaseRemoteConfig.swift
//  FirebaseCore
//
//  Created by Markus on 2018-09-05.
//

import Foundation
import FirebaseRemoteConfig
import RxSwift

internal class FirebaseRemoteConfig: RemoteConfigType {
  var exiprationDuration: TimeInterval = 3600
  var remoteConfigInstance: RemoteConfig!
  
  init(defaultValues: [String: NSObject]? = [: ], expirationDuration: TimeInterval = 3600, remoteConfigInstance: RemoteConfig = RemoteConfig.remoteConfig()) {
    self.remoteConfigInstance = remoteConfigInstance
    self.exiprationDuration = expirationDuration
    self.remoteConfigInstance.setDefaults(defaultValues)
  }
  
  func fetchValues() -> Observable<(RemoteConfigFetchStatus)> {
    return Observable.create {[unowned self] observer in
      self.remoteConfigInstance.fetch(withExpirationDuration: self.exiprationDuration, completionHandler: { status, error in
        if let error = error {
          observer.onError(error)
        } else {
          observer.onNext(
            (RemoteConfigFetchStatus(rawValue: status.rawValue) ?? RemoteConfigFetchStatus.unkown)
          )
        }
        observer.onCompleted()
      })
      return Disposables.create()
    }
  }
  
  func activateFetchedValues() {
    _ = remoteConfigInstance.activateFetched()
  }
  
  func getBoolValue(with key: String) -> Bool {
    return self.remoteConfigInstance.configValue(forKey: key).boolValue
  }
  
  func getStringValue(with key: String) -> String? {
    return self.remoteConfigInstance.configValue(forKey: key).stringValue
  }
  
  func getNumberValue(with key: String) -> NSNumber? {
    return self.remoteConfigInstance.configValue(forKey: key).numberValue
  }
}
