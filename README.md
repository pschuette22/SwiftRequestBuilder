# SwiftRequestBuilder

Build and test HTTP requests with concise, compile safe code.

## Builder syntax

```swift
let request = URLRequest(SimpleTestBody.self) {
    HTTPMethod(.post)
    Header("header1", value: "value")
    URL(string: "https://google.com")!
    QueryItem("query", value: 1)
    Body(SimpleTestBody(
        hello: "Hello!",
        world: 1,
        isExcited: true
    ))
}
```

## Factory Syntax

```swift
let request = RequestFactory()
    .with(httpMethod: .post)
    .with(baseURL: URL(string: "https://google.com")!)
    .with(header: "header1", equaling: "value")
    .with(
        httpBody: SimpleTestBody(
            hello: "Hello!",
            world: 1,
            isExcited: true
        )
    )
    .build()
```

## Test it

```swift
let blueprint = Blueprint(
    bodyType: SimpleTestBody.self,
    method: HTTPMethod.post,
    url: "https://google.com",
    headers: ["header1": "value"],
    body: SimpleTestBody(
        hello: "Hello!",
        world: 1,
        isExcited: true
    ),
    documentURL: nil
)

try assertRequest(request, matches: blueprint)
```