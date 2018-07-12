![Api-Template](https://user-images.githubusercontent.com/1342803/36623515-7293b4ec-18d3-11e8-85ab-4e2f8fb38fbd.png)

----

![Language](https://img.shields.io/badge/Language-Swift-orange.svg)
![Version](https://img.shields.io/badge/version-0.0.1-blue.svg)

A quick way for creating mock APIs without taking so much time.

# Installation

As it is a Vapor template, you have to execute the following command:

`vapor new project-name --template=jcarlosestela/mockapi`

then, use the `vapor xcode -y` for creating the Xcode project and open it.

# Usage

## Mocks

There are some pre-defined mocks that are available:

* JSONFileMock
* ModelMock
* StatusMock

Also, you can create your own by conforming the protocol `Mockable`.

Let's explain how it works:

### JSONFileMock

A json file mock. You have to include the path of the file that you want to return. It have to be in the `Public/` folder. An example of usage:

```swift
JSONFileMock(method: .GET, path: "api/users", file: "user-mock.json")
```

### ModelMock

A model mock. You have to use an object that conforms the `Codable` protocol. An example of usage:

```swift
ModelMock(method: .GET, path: "api/users", object: User(name: "mock user"))
```

### StatusMock

Mock for returning a http status without any body. An example of usage:

```swift
StatusMock(method: .POST, path: "api/users", status: .created)
```

Finally, in your `MockController` you have a method where you can register an array of mocks:

```swift
func boot(router: Router) throws {
    try router.register(mocks: [
        JSONFileMock(method: .GET, path: "api/test", file: "test.json"),
        ModelMock(method: .GET, path: "api/test2", object: AnyObject(name: "test")),
        StatusMock(method: .GET, path: "api/test/error", status: .notAcceptable)
    ])
}
```

## MockMiddleware

TBD
