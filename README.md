# CleanJSON

[![CI Status](https://img.shields.io/travis/Pircate/CleanJSON.svg?style=flat)](https://travis-ci.org/Pircate/CleanJSON)
[![Version](https://img.shields.io/cocoapods/v/CleanJSON.svg?style=flat)](https://cocoapods.org/pods/CleanJSON)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/CleanJSON.svg?style=flat)](https://cocoapods.org/pods/CleanJSON)
[![Platform](https://img.shields.io/cocoapods/p/CleanJSON.svg?style=flat)](https://cocoapods.org/pods/CleanJSON)


继承自 JSONDecoder，在标准库源码基础上做了改动，以解决 JSONDecoder 各种解析失败的问题，如键值不存在，值为 null，类型不一致。

```
属性可以全部使用不可选类型
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 9.0
* Swift 4.2

## Installation

CleanJSON is available through [CocoaPods](https://cocoapods.org) or [Carthage](https://github.com/Carthage/Carthage). To install
it, simply add the following line to your Podfile or Cartfile:

#### Podfile

```ruby
pod 'CleanJSON'
```

#### Cartfile

```ruby
github "Pircate/CleanJSON"
```

## Import

```swift
import CleanJSON
```

## Usage

### Normal

```swift
let decoder = CleanJSONDecoder()
try decoder.decode(Model.self, from: data)
```

对于不可选的枚举类型请遵循 CaseDefaultable 协议，如果解析失败会返回默认 case

```swift
enum Enum: Int, Codable, CaseDefaultable {
    
    case case1
    case case2
    case case3
    
    static var defaultCase: Enum {
        return .case1
    }
}
```

### Customize decoding strategy

可以通过 valueNotFoundDecodingStrategy 在值为 null 或类型不匹配的时候自定义解码，默认策略请看[这里](https://github.com/Pircate/CleanJSON/blob/master/CleanJSON/Classes/Adaptor.swift)

下面代码设定在解析的时候将 JSON 的 Int 类型 转换为 swift 的 Bool 类型

```swift
var adaptor = CleanJSONDecoder.Adaptor()
adaptor.decodeBool = { decoder in
    // 值为 null
    if decoder.decodeNull() {
        return false
    }
    
    if let intValue = try decoder.decodeIfPresent(Int.self) {
        // 类型不匹配，期望 Bool 类型，实际是 Int 类型
        return intValue != 0
    }
    
    return false
}
decoder.valueNotFoundDecodingStrategy = .custom(adaptor)
```

### For Moya

使用 Moya.Response 自带的 [map](https://github.com/Moya/Moya/blob/master/Sources/Moya/Response.swift) 方法解析，传入 CleanJSONDecoder

```swift
provider = MoyaProvider<GitHub>()
provider.request(.zen) { result in
    switch result {
    case let .success(response):
        let decoder = CleanJSONDecoder()
        let model = response.map(Model.self, using: decoder)
    case let .failure(error):
        // this means there was a network failure - either the request
        // wasn't sent (connectivity), or no response was received (server
        // timed out).  If the server responds with a 4xx or 5xx error, that
        // will be sent as a ".success"-ful response.
    }
}
```

### For RxMoya

```swift
provider = MoyaProvider<GitHub>()
let decoder = CleanJSONDecoder()
provider.rx.request(.userProfile("ashfurrow"))
    .map(Model.self, using: decoder)
    .subscribe { event in
        switch event {
        case let .success(model):
            // do someting
        case let .error(error):
            print(error)
        }
    }
```

## Author

Pircate, gao497868860@gmail.com

## License

CleanJSON is available under the MIT license. See the LICENSE file for more info.
