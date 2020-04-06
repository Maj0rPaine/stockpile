# stockpile
Demo api using Unsplash API.

You must obtain an access key from the Unsplash API in order to run this project:

[Authorization: Client-ID YOUR_ACCESS_KEY](https://unsplash.com/documentation#public-actions)

Example:

```extension URLRequest {
    static let apiKey = "<INSERT ACCESS KEY>"

    static func authorized(url: URL?) -> URLRequest? {
        guard let url = url else { return nil }
    
        guard !apiKey.isEmpty else {
            preconditionFailure("Failed to add API key")
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.addValue("v1", forHTTPHeaderField: "Accept-Version")
        request.addValue("Client-ID \(apiKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}
```
