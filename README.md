# WeatherApp

## Note
The application is built using
- Swift
- Swift UI
- iOS 17.4
- Xcode 15.3
- async await
- TCA Architecture


## To Run The Application
- Variable **TOKEN** needs to be added as an environment variable in the **run scheme** of the application
- This is done to avoid storing the authentication token in the code. The method is also considered safe in terms of security.

### Below is an illustration of a sample token:
<img width="400" alt="Screenshot 2024-07-10 at 22 51 39" src="https://github.com/yusuphjoluwasen/WeatherApp/assets/25069943/d5a4d95c-8794-4996-b8ce-bc124e2cc6a1">

## Description
- The App provides a search functionality, which takes a location and provides weather information. Search history is persisted in the database. It includes a detail view that shows full weather details and offers the option to load historical forecasts. The location entered into the text field is debounced using a timer to minimize API calls. The location input is also trimmed for empty spaces and newlines.
- It contains two reducers (`Search History` and `Weather Detail`), both containing states, actions and dependencies to manage the activities of the view.
- The TCA macros, e.g., `@Reducer`, `@ObservableState`, are used in the reducer.
- I used `@DependencyClient` from the TCA library for dependency injection, e.g., to inject the `WeatherClient` service that provides an abstraction to make network calls into the reducer. It is also used for `SearchDataManagerClient`, which provides an abstraction for Core Data. This ensures the reducers can be fully unit tested with mocks.
- Unit tests are written for both reducers.
- The Network and Utility modules are created as independent modules using swift package manager to optimize application's efficiency

### Assumptions
- An assumption was made about the option of loading historical forecasts. I added a button that, when clicked, fetches previous weather historical data from the API.

### Improvements
- To create the `Data Layer` and `WeatherService` modules as Packages.

### Screenshots
- To create the `Data Layer` and `WeatherService` modules as independent modules using Swift Package Manager to optimize the application's efficiency.
<img width="150" alt="Screenshot 2024-07-10 at 22 51 39" src="https://github.com/yusuphjoluwasen/WeatherApp/assets/25069943/547d9439-3f77-4ce5-ad2a-5f2edb7db3f3">
<img width="150" alt="Screenshot 2024-07-10 at 22 51 39" src="https://github.com/yusuphjoluwasen/WeatherApp/assets/25069943/156ea2e2-dafa-45c9-a4f5-0e7eb736bc01">
<img width="150" alt="Screenshot 2024-07-10 at 22 51 39" src="https://github.com/yusuphjoluwasen/WeatherApp/assets/25069943/d299ec32-d05c-4855-a614-b38e3c12783a">
<img width="150" alt="Screenshot 2024-07-10 at 22 51 39" src="https://github.com/yusuphjoluwasen/WeatherApp/assets/25069943/2309341b-1557-4f82-9420-5f03281aabca">
<img width="150" alt="Screenshot 2024-07-10 at 22 51 39" src="https://github.com/yusuphjoluwasen/WeatherApp/assets/25069943/119a7fd9-e2fc-431a-8f10-462efb63bc40">
<img width="150" alt="Screenshot 2024-07-10 at 22 51 39" src="https://github.com/yusuphjoluwasen/WeatherApp/assets/25069943/7970d55f-bb8c-4712-896b-649375289c87">



