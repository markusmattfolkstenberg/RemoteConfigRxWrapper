import XCTest
import RxSwift
import RxTest
import RxCocoa
@testable import RemoteConfigRxWrapper

class RemoteConfigRxWrapperTests: XCTestCase {
  
  var scheduler: TestScheduler!
  var disposeBag: DisposeBag!
  var remoteConfigMock: RemoteConfigMock!
  
  override func setUp() {
    let defaultValues: [String: NSObject] = ["Bool": true as NSObject,
                                             "String": "Test" as NSObject]
    remoteConfigMock = RemoteConfigMock(defaultValues: defaultValues)
    RemoteConfigRxWrapper.setSharedInstance(remoteConfigWrapper: RemoteConfigRxWrapper())
    RemoteConfigRxWrapper.sharedInstance.setupRemoteConfig(remoteConfig: remoteConfigMock)
    
    scheduler = TestScheduler(initialClock: 0)
    disposeBag = DisposeBag()
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testThatItUpdatesValueOnFetch() {
    SharingScheduler.mock(scheduler: scheduler) {
      let observer = scheduler.createObserver(String.self)
      let observer2 = scheduler.createObserver(Bool.self)
      let observer3 = scheduler.createObserver(NSNumber.self)
      RemoteConfigRxWrapper.sharedInstance.getStringValue(with: "Test").asDriver(onErrorJustReturn: "Error")
        .drive(observer)
        .disposed(by: disposeBag)
      RemoteConfigRxWrapper.sharedInstance.getBoolValue(with: "Bool").asDriver(onErrorJustReturn: false)
        .drive(observer2)
        .disposed(by: disposeBag)
      RemoteConfigRxWrapper.sharedInstance.getNumberValue(with: "Number").asDriver(onErrorJustReturn: NSNumber(value: -1))
        .drive(observer3)
        .disposed(by: disposeBag)
      
      remoteConfigMock.newValues = ["Test": "Correct" as NSObject,
                                    "Bool": false as NSObject,
                                    "Number": 12 as NSObject]
      
      RemoteConfigRxWrapper.sharedInstance.fetchValues()
      scheduler.start()
      XCTAssertEqual(observer.events.count, 2)
      XCTAssertEqual(observer.events[0].value.element, "") // Default value
      XCTAssertEqual(observer.events[1].value.element, "Correct")
      XCTAssertEqual(observer2.events.count, 2)
      XCTAssertEqual(observer2.events[0].value.element, true)
      XCTAssertEqual(observer2.events[1].value.element, false)
      XCTAssertEqual(observer2.events.count, 2)
      XCTAssertEqual(observer3.events[0].value.element, 0)
      XCTAssertEqual(observer3.events[1].value.element, 12)
    }
  }
}

