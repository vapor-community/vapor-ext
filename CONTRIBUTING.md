# Contributing Guidelines

This document contains information and guidelines about contributing to this project. Please read it before you start participating.

**Topics**

- [Asking Questions](#asking-questions)
- [Ways to Contribute](#ways-to-contribute)
- [Adding new Extensions](#adding-new-extensions)
- [Adding documentation](#adding-documentation)
- [Adding changelog entries](#adding-changelog-entries)
- [Reporting Issues](#reporting-issues)

---

## Asking Questions

We don't use GitHub as a support forum.
For any usage questions that are not specific to the project itself, please ask on [Vapor Slack](https://vapor.team) instead.
By doing so, you'll be more likely to quickly solve your problem, and you'll allow anyone else with the same question to find the answer.
This also allows us to focus on improving the project for others.

---

## Ways to Contribute

You can contribute to the project in a variety of ways:

- Improve documentation 🙏
- Add more extensions 👍
- Add missing unit tests 😅
- Fixing or reporting bugs 😱

If you're new to Open Source or Swift the Vapor community is a great place to get involved

**Your contribution is always welcomed, no contribution is too small.**

---

## Adding new Extensions

Please refer to the following rules before submitting a pull request with your new extensions:

- Add your contributions to [**master branch** ](https://github.com/vapor-community/vapor-ext/tree/master): - by doing this we can merge new pull-requests into **master** branch as soon as they are accepted, and add them to the next releases once they are fully tested.
- Mention the original source of extension source (if possible) as a comment inside extension:

```swift
public extension SomeType {
   public name: SomeType {
       // https://stackoverflow.com/somepage
       // .. code
   }
}
```

- A pull request should only add one extension at a time.
- All extensions should follow [Swift API Design Guidelines](https://developer.apple.com/videos/play/wwdc2016/403/)
- Always declare extensions as **public**.
- All extensions names should be as clear as possible.
- All extensions should be well documented. see [Adding documentation](#adding-documentation)
- This library is to extend the standards types available in Async package.
- Extensions could be: - Enums - Instance properties & type properties - Instance methods & type methods - Initializers
- All extensions should be tested.
- Files are named based on the type that the contained extensions extend and located inside a related target.
  - (example: `Future` extensions related to `Bool` types are found in "**Future+Bool.swift**" file insine `AsyncExt` target)
- All extensions files and test files have a one to one relation.
  - (example: all tests for "**Future+Bool.swift**" are found in the "**Future+BoolTests.swift**" file)
- There should be a one to one relationship between extensions and their backing tests.
- Tests should be named using the same API of the extension it backs.
  - (example: `Future` extension method `equal` is named `testEqual`)
- All test files are named based on the extensions which it tests.
  - (example: all Future extensions tests are found in "**FutureExtensionsTests.swift**" file)
- Extensions and tests are ordered inside files in the following order:

```swift
// MARK: - enums
public enum {
    // ...
}

// MARK: - Properties
public extension SomeType {}

// MARK: - Methods
public extension SomeType {}

// MARK: - Initializers
public extension SomeType {}
```

---

## Adding documentation

Use the following template to add documentation for extensions

> Replace placeholders inside <>

> Remove any extra lines, eg. if method does not return any value, delete the `- Returns:` line

#### Documentation template for units with single parameter:

```swift
/// <Description>.
///
///    <Example Code>
///
/// - Parameter <Paramenter>: <Description>.
/// - Throws: <Error>
/// - Returns: <Description>
```

#### Documentation template for units with multiple parameters:

```swift
/// <Description>.
///
///    <Example Code>
///
/// - Parameters:
///   - <Paramenter>: <Description>.
///   - <Paramenter>: <Description>.
/// - Throws: <Error>
/// - Returns: <Description>
```

#### Documentation template for enums:

```swift
/// AsyncExt: <Description>.
///
/// - <Case1>: <Description>
/// - <Case2>: <Description>
/// - <Case3>: <Description>
/// - <Case4>: <Description>
```

#### Power Tip:

In Xcode select a method and press `command` + `alt` + `/` to create a documentation template!

---

## Adding changelog entries

The [Changelog](https://github.com/vapor-community/async-extensions/blob/master/CHANGELOG.md) is a file which contains a curated, chronologically ordered list of notable changes for each version of a project. Please make sure to add a changelog entry describing your contribution to it everyting there is a notable change.

The [Changelog Guidelines](https://github.com/vapor-community/async-extensions/blob/master/CHANGELOG_GUIDELINES.md) contains instructions for maintaining (or adding new entries) to the Changelog.

---

## Reporting Issues

A great way to contribute to the project is to send a detailed issue when you encounter an problem.
We always appreciate a well-written, thorough bug report.

Check that the project issues database doesn't already include that problem or suggestion before submitting an issue.
If you find a match, add a quick "**+1**" or "**I have this problem too**".
Doing this helps prioritize the most common problems and requests.

**When reporting issues, please include the following:**

- What did you do?
- What did you expect to happen?
- What happened instead?
- VaporExt version
- Swift version
- Platform(s) (macOS or Linux)
- Demo Project (if available)

This information will help us review and fix your issue faster.
