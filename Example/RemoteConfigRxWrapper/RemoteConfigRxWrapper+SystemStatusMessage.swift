//
//  RemoteConfigRxWrapper+SystemStatusMessage.swift
//  RemoteConfigRxWrapper_Example
//
//  Created by Markus on 2018-09-06.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import RemoteConfigRxWrapper
import RxSwift
import RxCocoa

struct SystemStatusMessageData {
  var startDate: Date? // Date when message should start showing
  var endDate: Date? // Date when message stops showing
  var title: String // Title of the alert
  var text: String // Text in the alert
}

protocol SystemStatusMessage {
  func getSystemStatusMessageData() -> Driver<SystemStatusMessageData?>
}

extension RemoteConfigRxWrapper: SystemStatusMessage {
  
  enum SystemStatusKeys {
    static let startDate = "systemStatusStartDate"
    static let endDate = "systemStatusEndDate"
    static let title = "systemStatusTitle"
    static let text = "systemStatusText"
  }
  
  func getSystemStatusMessageData() -> Driver<SystemStatusMessageData?> {
    guard let activeRemoteConfig = self.activeRemoteConfig else {
      return Driver.never()
    }
    
    return remoteConfigUpdated.flatMapLatest { _ -> Observable<SystemStatusMessageData?> in
      let formatter = ISO8601DateFormatter()
      guard let title =  activeRemoteConfig.getStringValue(with: SystemStatusKeys.title),
        let text = activeRemoteConfig.getStringValue(with: SystemStatusKeys.text) else {
          return Observable.never()
      }
      
      return Observable.just(SystemStatusMessageData(
        startDate: formatter.date(from: activeRemoteConfig.getStringValue(with: SystemStatusKeys.startDate) ?? "") ,
        endDate: formatter.date(from: activeRemoteConfig.getStringValue(with: SystemStatusKeys.endDate) ?? ""),
        title: title,
        text: text))
      }.asDriver(onErrorJustReturn: nil)
  }
}

extension SystemStatusMessageData: Equatable {
  static func == (lhs: SystemStatusMessageData, rhs: SystemStatusMessageData) -> Bool {
    return lhs.startDate == rhs.startDate &&
      lhs.endDate == rhs.endDate &&
      lhs.text == rhs.text &&
      lhs.title == rhs.title
  }
}
