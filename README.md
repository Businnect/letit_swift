# LetIt Swift SDK

A professional Swift client for the LetIt API, featuring high-performance support for **Microposts** and **Job** management.

## API Documentation

For detailed information on the underlying REST API, endpoints, and authentication schemas, please visit the official documentation:

- **API Reference**: [http://api.letit.com](https://api.letit.com/docs/client/)

## Features

- **Job Management**: Full support for creating job postings with company logos, descriptions, and metadata.
- **Micropost System**: Create text posts or file-based updates with attachment support.
- **Async HTTP Support**: Built on `URLSession` with centralized authentication and API error handling.

## Installation

Using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/Businnect/letit_swift.git", from: "0.0.0")
]
```

## Quick Start

### Initialize the Client

```swift
import LetIt

let client = LetItClient(
    baseURL: "https://api.letit.com",
    apiKey: "your-api-token"
)
```

### Create a Job with a Company Logo

```swift
import Foundation
import LetIt

let logo = FilePayload(
    filename: "logo.png",
    bytes: try Data(contentsOf: URL(fileURLWithPath: "logo.png")),
    mimeType: "image/png"
)

let request = CreateJobWithCompanyRequest(
    companyName: "Acme Corp",
    companyDescription: "Building next-gen developer tools.",
    companyWebsite: "https://acme.example",
    jobTitle: "Senior Swift Developer",
    jobDescription: "Building production SDKs and integrations.",
    jobHowToApply: "https://acme.example/careers",
    companyLogo: logo,
    jobLocation: .remote
)

let response = try await client.job.createWithCompany(request)
print(response.slug)
```

### Create a Micropost

```swift
import LetIt

let request = CreateMicropostRequest(
    body: "The Swift SDK is now live!",
    title: "New Update",
    postType: .text
)

let response = try await client.micropost.create(request)
print(response.publicId)
```

## Testing

Live integration tests use real API calls (no mock). Set environment variables before running:

```bash
export LETIT_API_TOKEN="your-api-token"
```

Run the test suite:

```bash
swift test
```