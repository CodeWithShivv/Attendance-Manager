
# The Attendance Manager App is a Flutter-based mobile application for managing employee attendance. It enables users to track attendance, manage employees, and sync data with Google Sheets. The app is built with a modular architecture, leveraging modern state management and dependency injection for maintainability.

Table of Contents
Features
Architecture
Implementation Details
Dependencies
Setup and Installation
Contributing
License
Features
Add/remove employees with swipe-to-delete and undo functionality.
Track attendance with check-in/out times and automatic overtime calculation.
Sync attendance data with Google Sheets.
Modern UI with slivers, skeleton loading, and smooth keyboard handling.
Bottom navigation to switch between Attendance and Employee pages.
Architecture
The app follows a Clean Architecture approach with three layers:

Presentation Layer: UI components like pages (attendance_page.dart, employee_page.dart) and widgets (bottom_nav_bar.dart).
Domain Layer: Business logic and entities (attendance.dart, employee.dart).
Data Layer: Data operations, including Google Sheets integration via attendance_repository_impl.dart.
State management is handled with flutter_bloc, using EmployeeBloc for employee actions, HomeBloc for attendance, and HomeCubit for navigation. get_it is used for dependency injection to manage repositories and blocs.

The file structure is feature-based:


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

Implementation Details
Navigation:
HomePage uses IndexedStack and HomeCubit for bottom navigation between AttendancePage and EmployeePage.
Features a standard AppBar with the title "Attendance Manager".
BottomNavBar is styled with rounded corners and shadows.
Employee Management (EmployeePage):
Add/remove employees with a TextField and swipe-to-delete (Dismissible).
Keyboard closes on "Done", tap outside (GestureDetector), or after adding.
Uses CustomScrollView with slivers for smooth scrolling.
EmployeeBloc manages states (EmployeeAdding, EmployeeLoaded).
Attendance Management (AttendancePage):
Select dates and times with DateSelectorWidget and AttendanceListItem.
Save attendance to Google Sheets via HomeBloc.
Uses slivers and skeleton loading (skeletonizer).
Google Sheets Integration:
AttendanceRepositoryImpl handles fetching and updating records.
Default records (9 AM to 6 PM) are created if no data exists.
UI:
Cards with elevation and rounded corners for list items.
Dialogs (AlertDialogWidget) for loading states.
Skeleton loading for better UX during data fetching.
Dependencies
flutter_bloc: ^8.1.3: State management.
googleapis: ^11.1.0 \& googleapis_auth: ^1.4.0: Google Sheets integration.
skeletonizer: ^1.4.3: Skeleton loading.
get_it: ^8.0.3: Dependency injection.
intl: ^0.18.1: Date/time formatting.
freezed: ^2.4.1 \& json_serializable: ^6.7.1: Code generation.
Setup and Installation
Clone the Repository:
bash
Wrap
Copy
git clone https://github.com/yourusername/attendance_manager_app.git
cd attendance_manager_app
Install Dependencies:
bash
Wrap
Copy
flutter pub get
Generate Code:
bash
Wrap
Copy
flutter pub run build_runner build --delete-conflicting-outputs
Set Up Google Sheets API:
Enable Google Sheets API in Google Cloud Console.
Add credentials to assets/.env.
Run the App:
bash
Wrap
Copy
flutter run
Contributing
Fork the repository.
Create a branch (git checkout -b feature/your-feature).
Commit changes (git commit -m "Add your feature").
Push to the branch (git push origin feature/your-feature).
Open a Pull Request.
License
This project is licensed under the MIT License - see the LICENSE file for details.



==========================

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

