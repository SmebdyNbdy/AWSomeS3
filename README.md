# AWSomeS3
### Vapor version 4.0.0
### Swift version 5.2

====

TODO:
- [ ] Describe usage

## Basic usage:
In your `Package.swift` add the following dependencies
```
dependencies: [
    •••
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"), // duh...
    .package(url: "https://github.com/smebdynbdy/awsomes3.git", from: "0.1.0")
],
targets: [
    .target(
        •••
        dependencies: [
            •••
            .product(name: "AWSomeS3", package: "awsomes3")
        ])
]
```

After that you can start using `import AWSomeS3`

