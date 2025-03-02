
The Attendance Manager App is a Flutter-based mobile application designed to streamline employee attendance management. It supports tracking attendance, managing employees, and syncing data with Google Sheets, all within a modular and maintainable architecture using modern state management and dependency injection.

Screenshots
<img width="350" alt="Screenshot 2025-03-02 at 11 57 53 AM" src="https://github.com/user-attachments/assets/e948b4c4-967d-4562-aa7b-b1d74cd58cc9" />
<img width="360" alt="Screenshot 2025-03-02 at 11 58 06 AM" src="https://github.com/user-attachments/assets/e1741462-defc-4f1a-8556-e135344399e5" />
<img width="360" alt="Screenshot 2025-03-02 at 11 58 15 AM" src="https://github.com/user-attachments/assets/736f7652-77dd-431c-ab77-64a4dc19e370" />


https://github.com/user-attachments/assets/e4b53001-3578-4e67-b085-2fa98447ca6a




Table of Contents
Features
Architecture
Implementation Details
Dependencies
Setup and Installation
Contributing
License



Features
Add or remove employees using a swipe-to-delete gesture with an undo option.
Track employee attendance, including check-in/out times, with automatic overtime calculation.
Synchronize attendance data with Google Sheets for persistence.
Clean UI with slivers, skeleton loading effects, and intuitive keyboard handling.
Bottom navigation bar to toggle between Attendance and Employee sections.
Architecture
The app is structured using Clean Architecture, divided into three layers:

Presentation Layer: Contains UI elements such as pages (attendance_page.dart, employee_page.dart) and widgets (bottom_nav_bar.dart).
Domain Layer: Houses business logic and entities (attendance.dart, employee.dart), independent of external frameworks.
Data Layer: Manages data operations, including Google Sheets integration through attendance_repository_impl.dart.
For state management, the app uses flutter_bloc with:

EmployeeBloc for handling employee-related actions.
HomeBloc for managing attendance data.
HomeCubit for navigation state.
Dependency injection is implemented with get_it to manage repositories and blocs efficiently.



A Flutter-based mobile application designed to manage employee attendance efficiently. It allows users to track attendance, manage employees, and sync data with Google Sheets.

## Features

------------

- **Employee Management**: Add or remove employees with swipe-to-delete and undo functionality.
- **Attendance Tracking**: Record check-in/out times with automatic overtime calculation.
- **Google Sheets Integration**: Sync attendance data seamlessly with Google Sheets.
- **Modern UI**: Features slivers, skeleton loading, and smooth keyboard handling for enhanced user experience.
- **Navigation**: Bottom navigation to switch between Attendance and Employee pages.


## Architecture

--------------

The app follows a **Clean Architecture** approach, divided into three layers:

- **Presentation Layer**: UI components such as pages (`attendance_page.dart`, `employee_page.dart`) and widgets (`bottom_nav_bar.dart`).
- **Domain Layer**: Business logic and entities (`attendance.dart`, `employee.dart`).
- **Data Layer**: Data operations, including Google Sheets integration via `attendance_repository_impl.dart`.


### State Management and Dependency Injection

- **State Management**: Utilizes `flutter_bloc` with `EmployeeBloc` for employee actions, `HomeBloc` for attendance, and `HomeCubit` for navigation.
- **Dependency Injection**: Employs `get_it` to manage repositories and blocs.


## File Structure

-----------------

The file structure is organized feature-wise:

```plaintext
lib/
├── features/
│   ├── attendance/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── employee/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── home/
│   │   └── presentation/
│   └── splash/
│       └── presentation/
├── main.dart
└── assets/
    └── .env
```


## Implementation Details

------------------------

### Navigation

- **HomePage**: Uses `IndexedStack` and `HomeCubit` for bottom navigation between `AttendancePage` and `EmployeePage`.
- **AppBar**: Standard app bar with the title "Attendance Manager".
- **BottomNavBar**: Styled with rounded corners and shadows.


### Employee Management

- **EmployeePage**: Add/remove employees using a `TextField` and swipe-to-delete (`Dismissible`).
- **Keyboard Handling**: Keyboard closes on "Done", tap outside (`GestureDetector`), or after adding.
- **Scrolling**: Utilizes `CustomScrollView` with slivers for smooth scrolling.
- **EmployeeBloc**: Manages states (`EmployeeAdding`, `EmployeeLoaded`).


### Attendance Management

- **AttendancePage**: Select dates and times with `DateSelectorWidget` and `AttendanceListItem`.
- **Google Sheets Sync**: Saves attendance to Google Sheets via `HomeBloc`.
- **UI Enhancements**: Uses slivers and skeleton loading (`skeletonizer`).


### Google Sheets Integration

- **AttendanceRepositoryImpl**: Handles fetching and updating records.
- **Default Records**: Creates default records (9 AM to 6 PM) if no data exists.


### UI

- **List Items**: Cards with elevation and rounded corners.
- **Dialogs**: `AlertDialogWidget` for loading states.
- **Skeleton Loading**: Enhances UX during data fetching.


## Dependencies

--------------

- **flutter_bloc**: ^8.1.3 (State management)
- **googleapis**: ^11.1.0 \& **googleapis_auth**: ^1.4.0 (Google Sheets integration)
- **skeletonizer**: ^1.4.3 (Skeleton loading)
- **get_it**: ^8.0.3 (Dependency injection)
- **intl**: ^0.18.1 (Date/time formatting)
- **freezed**: ^2.4.1 \& **json_serializable**: ^6.7.1 (Code generation)


## Setup and Installation

-------------------------

### Clone the Repository

```bash
git clone https://github.com/yourusername/attendance_manager_app.git
cd attendance_manager_app
```


### Install Dependencies

```bash
flutter pub get
```


### Generate Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```


### Set Up Google Sheets API

1. **Enable Google Sheets API**: In the Google Cloud Console.
2. **Add Credentials**: Place credentials in `assets/.env`.

### Run the App

```bash
flutter run
```


## Contributing

--------------

1. **Fork the Repository**.
2. **Create a Branch**: `git checkout -b feature/your-feature`.
3. **Commit Changes**: `git commit -m "Add your feature"`.
4. **Push to the Branch**: `git push origin feature/your-feature`.
5. **Open a Pull Request**.

## License

---------

This project is licensed under the **MIT License**. See the LICENSE file for details.

