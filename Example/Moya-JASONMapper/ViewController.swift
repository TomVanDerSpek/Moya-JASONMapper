//
//  ViewController.swift
//  Moya-JASONMapper
//
//  Created by Antoine van der Lee on 01/26/2016.
//  Copyright (c) 2016 Antoine van der Lee. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import ReactiveSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        exampleRequestDirectMapping()
        coreObjectMapping()
        reactiveCocoaObjectMapping()
        rxSwiftObjectMapping()
    }
    
    func exampleRequestDirectMapping(){
        // This instead works, with type definition
        let producer:SignalProducer<GetResponse, Moya.Error> = requestType(ExampleAPI.getObject).on(value: { (object) in
            print("Example origin \(object.origin)")
        })
        producer.start()
    }
    
    func coreObjectMapping(){
        stubbedProvider.request(ExampleAPI.getObject) { (result) -> () in
            switch result {
            case let .success(response):
                do {
                    let getResponseObject = try response.map(to: GetResponse.self)
                    print(getResponseObject)
                } catch {
                    print(error)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func reactiveCocoaObjectMapping(){
        RCStubbedProvider.request(token: ExampleAPI.getObject).mapObject(to: GetResponse.self).on(failed: { (error) -> () in
            print(error)
        }) { (response) -> () in
            print(response)
        }.start()
    }
    
    func rxSwiftObjectMapping(){
        let disposeBag = DisposeBag()
        RXStubbedProvider.request(ExampleAPI.getObject).mapObject(to: GetResponse.self).subscribe(onNext: { (response) -> Void in
            print(response)
        }, onError: { (error) -> Void in
            print(error)
        }).addDisposableTo(disposeBag)
    }
}

