![Api-Template](https://user-images.githubusercontent.com/1342803/36623515-7293b4ec-18d3-11e8-85ab-4e2f8fb38fbd.png)

----

![Language](https://img.shields.io/badge/Language-Swift-orange.svg)
![Version](https://img.shields.io/badge/version-1.0.1-blue.svg)

A quick way for creating mock APIs without taking so much time.

# Installation

As it is a Vapor template, you have to execute the following command:

`vapor new project-name --template=jcarlosestela/vapor-mockapi`

then, use the `vapor xcode -y` for creating the Xcode project and open it.

# Usage

## Mocks

There are some pre-defined mocks that are available:

* JSONFileMock
* ModelMock
* StatusMock

Let's explain how it works:

### JSONFileMock

A json file mock. You have to include the path of the file that you want to return. It have to be in the `Public/` folder. An example of usage:

```swift
JSONFileMock(method: .GET, path: "api/users", file: "user-mock.json")
```

### ModelMock

A model mock. You have to use an object that conforms the `Codable` protocol. An example of usage:

```swift
ModelMock(method: .GET, path: "api/users", mock: User(name: "mock user"))
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
        ModelMock(method: .GET, path: "api/test2", mock: AnyObject(name: "test")),
        StatusMock(method: .GET, path: "api/test/error", status: .notAcceptable)
    ])
}
```

Also, you can create your own mocks by conforming the protocol `Mockable`.

## MockMiddleware

The project contains a MockMiddleware that provide some features to the mocks already explained. This middleware is set up by default in the `configure.swift` file.

There are two features implemented:

* Error (for returning errors in some cases)
* Delay (for delaying the response)

Every `Mockable` instance has some methods that provides a way for changing the behaviour of the mock itself. The methods already implemented are:

```swift
func fail(with status: HTTPResponseStatus, every: Int) -> Mockable
func fail(with status: HTTPResponseStatus, probability: Float) -> Mockable
func delay(_ delay: Double) -> Mockable
```

An example of usage could be:

```swift
JSONFileMock(method: .GET, path: "api/test", file: "test.json").delay(1.0).fail(with: .badRequest, every: 1)
```

## GatewayMiddleware

This middleware provides the feature of calling to your original API with the same params & headers received. This is very useful if you want to mock some method of your API but not the full API (and you want the original behaviour).  

You have two ways of using it:

```swift
middlewares.use(GatewayMiddleware(to: "https://yourapi.com", routes: router.routes))
// or
middlewares.use(GatewayMiddleware(to: "https://yourapi.com", routes: ["/GET/api/v1/login"]))
```

In the first one any request with different path to the paths included in `router.routes` will be requested to `https://yourapi.com` with the same params & headers. 

In the second one any request with different path to "/GET/api/v1/login" will be requested to `https://yourapi.com` with the same params & headers.