# ProvisioningProfile

This package will provide you easy access to useful information on the provisioning profile used in your app,
such as the profile's name and the date it will expire. Read [my blog post for this library](https://chris-mash.medium.com/knowing-when-your-ios-apps-provisioning-profile-is-going-to-expire-4689d03d0d5) for a bit more of a discussion
around this.

You can use this information to display in the development versions of your apps to make it easy to check
when the profile will expire (and hence, when the app will stop working without being reinstalled again).

You could show an alert when the app starts up if the profile is going to expire soon to remind you (or allow you
test users to remind you) to redistribute the app with a new profile. You could even schedule a local notification
so that the reminder is still visible if the app isn't in regular use.

Platforms supported:

* iOS
* watchOS
* tvOS
* macOS

There's also a shell script included in the package that can be added as a Run Script build phase in your app
so that when building or archiving you can get a warning or error if the provisioning profile is going to expire soon.

## Adding to your project

Follow [Apple's guidance](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) to add the package to your project.

## Usage

### In your source code

```
import ProvisioningProfile
let profileName = ProvisioningProfile.profile()?.name
let profileExpiry = ProvisioningProfile.profile()?.expiryDate
let profileExpiryFormatted = ProvisioningProfile.profile().formattedExpiryDate
```

### Customisation

The `ProvisioningProfile` class has the following customisation points:

*  The static property `dateFormatter` can be used to set a custom `DateFormatter` for use in generating the `formattedExpiryDate`
property, if the default formatting is not suitable.
* The static property `logger` can be used to provide a delegate that receives information about errors or warnings
that have occurred during loading and parsing of the provisioning profile. See the `Logger` protocol for more 
information.

### Example apps

See the test apps in the `Examples` folder for runnable example usage.

### In your build phases

You can add the `check_provisioning_expiry.sh` shell script as a Run Script build phase to provide a warning or error if the profile
will expire soon.

Copy the script file out of the package/repo and add it to your own project's files. See the build phases of the test apps in `Examples` for an example of how to make use of the script.

## Contributions

If you wish to make any contributions to this project, feel free to make a fork and then submit a pull request back
with your proposed changes/additions.

Make sure any changes or additions are covered with unit tests and the test apps are updated as appropriate. 

Bear in mind that breaking changes should be avoided where possible!

### SwiftLint

The project is setup with [SwiftLint](https://github.com/realm/SwiftLint) to check code quality a little. It's configured
by the `.swiftlint.yml` file in the root of the project.

Run a scan with the following command in the root of the project:
`swiftlint`

### Jazzy docs

API documentation can be generated with [Jazzy](https://github.com/realm/jazzy). Whilst this isn't published it's
useful for pointing out parts of the API that aren't documented correctly (check the `undocumented.json` file for
any warnings after the documentation is generated), so you can be sure the API documentation available within
Xcode will be correct and useful to users.

Generate the documentation using the following command in the root of the project:
`jazzy`
