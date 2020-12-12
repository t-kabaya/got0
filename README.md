
## Installation

got is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'got'
```
## Example Usage

```swift
import got

struct Person: Codable {
    let name: String
    let gender: String?
}

let url = "https://swapi.dev/api/people/1/"
Got.get(url: url, model: Person.self) { response in
    let person: Person = response
    print(person)
}
// Person(
//    name: "Luke Skywalker",
//    gender: "male"
// )
```


```swift
let header: [String : Any] = [
    "Content-Type": "text/html",
]

let body: [String: Any] = [
    "age": 20
]

Got.post(url: url, model: Person.self, header: header, body: body) { person in
    print(person) // Person(...)
}
```

Also support delete and put.

```swift
Got.delete(...)
Got.put(...)
```



## License

got is available under the MIT license. See the LICENSE file for more info.
