# Mindbody

### Overview

This file outlines my Mindbody assessment project and the thinking behind certain decisions. Please note that I have lots to learn as a developer and I would cherish any of the team’s feedback on how I can improve and enhance my skills.

I wrote all of the classes in this project, some of which have been taken from my own personal projects. This is because I spent a lot of time working on them and believe they show some of my best work.

I chose an MVVM design pattern as I believe it to be the most effective pattern. Since it’s incredibly efficient at organizing the code and also common enough for easily onboarding new team members.

### Dependencies

I decided to include a few dependencies within the project to streamline the logic. I have reasons for adding each framework, which I'll elaborate on below.

* **[Alamofire](https://github.com/Alamofire/Alamofire)** - This framework aids in building a clean and reliable networking layer. I only implemented Alamofire into one networking class, meaning it can be easily replaced by another dependency or my own networking logic.
* **[ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper)** - Rather than building my own JSON deserialization methods such as "fromJSON", this framework drastically reduces the lines of required code to manage JSON responses.
* **[RxSwift](https://github.com/ReactiveX/RxSwift)** - This helps me bind my data to the UI, reducing the amount of code by automatically updating views when data is modified.
* **[SDWebImage](https://github.com/SDWebImage/SDWebImage)** - Fetches and caches image URLs quickly and reliably. I leveraged this to retrieve the country flag images for the table cells.
* **[Handy](https://bitbucket.org/bconway99/handy)** - This is a Swift Package that I wrote myself, I created it with the purpose of sharing utility methods across my projects.

### To Improve

Below I have listed a few points which I could improve in this project.

* I have implemented a few methods leveraging third party frameworks. However I have also replicated some of these methods without any external dependencies. My thinking behind including these was wanting to demonstrate my understanding of Apple's frameworks outside of leveraging third parties.
* The **CLGeocoder** object sometimes struggled to retrieve locations for a specified address. I should implement some fail-safe logic to reduce the possibility of this, as well as error handling to clarify the issue to the user.
* I should leverage thread management to the point where bigger tasks are created on a background thread and then redirected to the main thread once the UI needs updating.
* I would add unit and UI testing for every aspect of the codebase, to make sure I’m following TDD (Test Driven Development) as much as possible.
* Since we cannot develop everything on the production environment, targets would be added for each development environment in order to aim at the various domains, APIs and more.
* I included a **Constants** file in the project which contains sensitive data such as domains, endpoints and in a production project would also contain API keys. However in a production project I would add this to the Gitignore file so that it’s never hosted in a repository. Then the Constants file could be shared between the development team in a more secure way. For this assessment I have included it in the repository so that it can be viewed by the team.
* Usually I would never hardcode strings and instead add them to a separate strings file, so that we can localize languages far more easily.
* I can always include cleaner UI as well as animations.
