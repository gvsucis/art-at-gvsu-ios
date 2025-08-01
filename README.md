# Art At GVSU

![Tests](https://github.com/gvsucis/art-at-gvsu-ios/actions/workflows/ci.yml/badge.svg) [![CalVer 2025.07.1019][img_version]][url_version]

## Download

<a href="https://apple.co/3XI4pvu">
    <img src="./site/app-store-download.svg" width="150px">
</a>

## Getting Started

1. Open the .xcodeproj file by double clicking it in Finder or via the command-line

    ```
    open ArtAtGVSU.xcodeproj
    ```
1. Navigate to the Project Manager and click the "Signing & Capabilities" tab
1. On the "Signing & Capabilities" tab, Enter the Team account info for the project. You'll need to get these credentials from a current team member.
1. Hit <kbd>Command+R</kbd> and run the app using an iPhone or a simulator.

[img_version]: https://img.shields.io/static/v1.svg?label=CalVer&message=2025.07.1019&color=blue
[url_version]: https://github.com/gvsucis/art-at-gvsu-v3

## Committing

Run the following command before adding a new commit

```
make bootstrap
```

This will install several Git commit hooks via [pre-commit](https://pre-commit.com/) to ensure
the Xcode project file is sorted among other code quality checks.

## Release

### Testflight

Testflight builds will automatically on new commits to the main branch.

### App Store

App Store releases are handled by the GitHub Action called "Deploy Production."

Before creating a new release, update the [fastlane/metadata/en-US/release_notes.txt](./fastlane/metadata/en-US/release_notes.txt) file with a description of the important changes made since the last release.

## Structure

The app structure is comprised mostly of the `ArtAtGVSU` directory. This contains app models and SwiftUI views.

The `ArtAtGVSU` model depends on the `ArtGalleryClient` which is responsible for HTTP requests to the Art Museum's Collective Access API instance.

```mermaid
flowchart TB
Models --> ArtAtGVSU
Views --> ArtAtGVSU
ArtAtGVSU --> ArtGalleryClient

ArtGalleryClient --> API
API[(Collective Access)]
```
