# JSON Patch (RFC 6902) in Swift

JSONPatchSwift is an implementation of JSONPatch (RFC 6902) in pure Swift.

## Installation

###CocoaPods (iOS 9.0+, OS X 10.10+)
You can use [Cocoapods](http://cocoapods.org/) to install `JSONPatchSwift`by adding it to your `Podfile`:
```ruby
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
	pod 'JSONPatchSwift', :git => 'https://github.com/EXXETA/JSONPatchSwift.git'
end
```
Note that this requires CocoaPods version 36, and your iOS deployment target to be at least 9.0:

## Usage

###Initialization
```swift
import JSONPatchSwift
```
```swift
let jsonPatch = try? JPSJsonPatch("{ \"op\": \"add\", \"path\": \"/baz\", \"value\": \"qux\" }")
```

###Using it on a JSON (using the framework [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON))
```swift
let json = JSON(data: " { \"foo\" : \"bar\" } ".dataUsingEncoding(NSUTF8StringEncoding)!)
let resultingJson = try? JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
```

## Requirements

- iOS 9.0+
- Xcode 7


## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

## History

v1.0 - initial release

## Credits

- EXXETA AG
- See [Contributors](https://www.github.com/EXXETA/JSONPatchSwift/graphs/contributors)

## License

Apache License v2.0
