//
//  RemoteConfigWrapper.swift
//  RemoteConfigRxWrapper
//
//  Created by Markus on 2018-09-05.
//

import Foundation
import RxSwift

public enum RemoteConfigFetchStatus: Int {
  case noFetchYet, success, failure, throttled, unkown
}

public protocol RemoteConfigType {
  func getBoolValue(with key: String) -> Bool
  func getStringValue(with key: String) -> String?
  func getNumberValue(with key: String) -> NSNumber?
  func fetchValues() -> Observable<(RemoteConfigFetchStatus)>
  func activateFetchedValues()
}

public class RemoteConfigRxWrapper {
  
  public private(set) var activeRemoteConfig: RemoteConfigType?
  public private(set) static var sharedInstance = RemoteConfigRxWrapper()
  
  public var remoteConfigUpdated = ReplaySubject<Void>.create(bufferSize: 1)
  
  private var disposeBag = DisposeBag()
  
  static func setSharedInstance(remoteConfigWrapper: RemoteConfigRxWrapper) {
    sharedInstance = remoteConfigWrapper
  }
  
  public func setupRemoteConfig(remoteConfig: RemoteConfigType) {
    activeRemoteConfig = remoteConfig
    self.remoteConfigUpdated.onNext(Void())
  }
  
  public func getStringValue(with key: String) -> Observable<String> {
    guard let activeRemoteConfig = self.activeRemoteConfig else {
      return Observable.never()
    }
    return remoteConfigUpdated.flatMapLatest {
      return Observable.just(activeRemoteConfig.getStringValue(with: key) ?? "")
      }.share(replay: 1)
  }
  
  public func getBoolValue(with key: String) -> Observable<Bool> {
    guard let activeRemoteConfig = self.activeRemoteConfig else {
      return Observable.never()
    }
    return remoteConfigUpdated.flatMapLatest {
      return Observable.just(activeRemoteConfig.getBoolValue(with: key))
      }.share(replay: 1)
  }
  
  public func getNumberValue(with key: String) -> Observable<NSNumber> {
    guard let activeRemoteConfig = self.activeRemoteConfig else {
      return Observable.never()
    }
    return remoteConfigUpdated.flatMapLatest {
      return Observable.just(activeRemoteConfig.getNumberValue(with: key) ?? 0)
      }.share(replay: 1)
  }
  
  public func fetchValues() {
    guard let activeRemoteConfig = self.activeRemoteConfig else {
      return
    }
    
    activeRemoteConfig.fetchValues().subscribe(onNext: { [unowned self] status in
      switch status {
      case .failure:
        print("Failed to fetch remote config")
      default:
        activeRemoteConfig.activateFetchedValues()
        self.remoteConfigUpdated.onNext(Void())
      }
      }, onError: { error in
        print(error)
    }).disposed(by: disposeBag)
  }
}
