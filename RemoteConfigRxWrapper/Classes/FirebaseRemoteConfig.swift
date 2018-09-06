//
//  FirebaseRemoteConfig.swift
//  FirebaseCore
//
//  Created by Markus on 2018-09-05.
//

import Foundation
import FirebaseRemoteConfig
import RxSwift

public class FirebaseRemoteConfig: RemoteConfigType {
  var exiprationDuration: TimeInterval = 3600
  var remoteConfigInstance: RemoteConfig!
  
  public init(defaultValues: [String: NSObject]? = [: ], expirationDuration: TimeInterval = 3600, remoteConfigInstance: RemoteConfig = RemoteConfig.remoteConfig()) {
    self.remoteConfigInstance = remoteConfigInstance
    self.exiprationDuration = expirationDuration
    self.remoteConfigInstance.setDefaults(defaultValues)
  }
  
  public func fetchValues() -> Observable<(RemoteConfigFetchStatus)> {
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
  
  public func activateFetchedValues() {
    _ = remoteConfigInstance.activateFetched()
  }
  
  public func getBoolValue(with key: String) -> Bool {
    return self.remoteConfigInstance.configValue(forKey: key).boolValue
  }
  
  public func getStringValue(with key: String) -> String? {
    return self.remoteConfigInstance.configValue(forKey: key).stringValue
  }
  
  public func getNumberValue(with key: String) -> NSNumber? {
    return self.remoteConfigInstance.configValue(forKey: key).numberValue
  }
}
