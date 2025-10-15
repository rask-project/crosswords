# Crosswords

The Biblical Crossword Game

## Project Structure

This project is a Biblical Crossword Game developed using Qt/QML, targeting multiple platforms, with a strong focus on Android. The repository is structured as follows:

```
crosswords/
├── CMakeLists.txt
├── LICENSE
├── Main.qml
├── Native/
│   ├── Android.cpp
│   └── Android.h
├── README.md
├── CrosswordsGame/
│   ├── CMakeLists.txt
│   ├── data/
│   ├── game/
│   ├── qml/
│   │   ├── CrosswordsGame.qml
│   │   ├── Letter.qml
│   │   ├── QuestionIndicator.qml
│   │   ├── QuestionTip.qml
│   │   ├── QuestionsArea.qml
│   │   └── ShowVerseButton.qml
│   ├── repositories/
│   ├── resources/
│   └── viewmodels/
├── android/
├── controls/
│   ├── ButtonAction.qml
│   ├── CrosswordsItemDelegate.qml
│   ├── HeaderBar.qml
│   ├── Page.qml
│   ├── ScrollablePage.qml
│   └── TextAlert.qml
├── main.cpp
├── pages/
│   ├── CrosswordsGamePage.qml
│   └── CrosswordsListPage.qml
└── resources/
    ├── icons/
    ├── logo.png
    └── qtquickcontrols2.conf
```

## Code Coverage Reports

To generate coverage reports you must configure the project with coverage enabled, build the tests, and then run the custom
coverage target created by CMake:

```bash
cmake -S . -B build -DENABLE_COVERAGE=ON
cmake --build build --target TestCrosswordsGame
cmake --build build --target TestCrosswordsGame_coverage_run
```

Running the coverage target executes the unit tests and uses `gcovr` with detailed HTML, LCOV, and Cobertura XML outputs. The
artifacts are generated under `build/coverage/`:

- `index.html`: Human-friendly HTML coverage report with per-file details.
- `lcov.info`: LCOV file, suitable for tools that consume the LCOV format.
- `coverage.xml`: Cobertura XML report, which can be published to services such as SonarQube/SonarCloud.

You can adapt the commands above to the build directory or targets relevant to your platform if they differ from the defaults.

-   **`CMakeLists.txt`**: The primary CMake configuration file for the entire project.
-   **`Main.qml`**: The main QML file that defines the application window and manages navigation between different pages using a `StackView`.
-   **`Native/`**: Contains C++ code for platform-specific integrations, particularly for Android functionalities (e.g., status bar color, splash screen). This leverages JNI for interacting with Android APIs.
-   **`CrosswordsGame/`**: This directory encapsulates the core crossword game logic. It includes:
    -   **`data/`**: Likely contains data models or utility classes for data handling.
    -   **`game/`**: Expected to hold the backend logic for the crossword game itself, such as board representation and answer validation.
    -   **`qml/`**: QML components specific to the game interface, like individual `Letter` cells, `QuestionIndicator`s, and `QuestionsArea`.
    -   **`repositories/`**: Classes responsible for data access and management, interacting with the database.
    -   **`resources/`**: Static assets and SQL files used by the game logic.
    -   **`viewmodels/`**: Implements the Model-View-ViewModel (MVVM) pattern to expose data and logic to the QML frontend.
-   **`android/`**: Contains Android-specific build files and configurations.
-   **`controls/`**: Reusable QML UI components such as `HeaderBar`, `ButtonAction`, and `TextAlert`, promoting a consistent look and feel.
-   **`main.cpp`**: The C++ entry point of the application, initializing the Qt environment and loading the main QML interface.
-   **`pages/`**: Defines the main screens of the application:
    -   **`CrosswordsListPage.qml`**: Displays a list of available crossword puzzles.
    -   **`CrosswordsGamePage.qml`**: The actual game screen where users play the crossword.
-   **`resources/`**: General application resources like icons and configuration files.

## Game Logic Explanation

The game is built around the Qt/QML framework, providing a rich and interactive user interface. The core game flow involves:

1.  **Listing Crosswords**: The `CrosswordsListPage.qml` displays a list of available crossword puzzles. It uses a `GridView` to present `CrosswordsItemDelegate` components, each representing a crossword. Data for these crosswords is provided by a `CrosswordsModel` (likely a C++ class exposed to QML).
2.  **Starting a Game**: When a user clicks on a crossword item, the `StackView` navigates to `CrosswordsGamePage.qml`. This page sets up the game board and controls.
3.  **Game Board Interaction**: The `CrosswordsGamePage.qml` contains the `CrosswordsGame` component, which is the central element for playing. It defines the grid dimensions (`columns`, `rows`) and receives the `crosswords` data for the current puzzle.
4.  **Letter Input**: Individual cells on the crossword board are represented by `Letter.qml` components. These components contain a `TextInput` field where users can enter letters. The `TextInput` uses a `RegExpValidator` (`/[A-Z]/i`) to ensure only alphabetic characters are entered, enhancing input validation. It also handles navigation between letters (next/previous) and saves the user's response.
5.  **Checking Answers**: The `CrosswordsGamePage.qml` includes actions in its `HeaderBar` to refresh (reset) the game and check the user's answers. The `CrosswordsGame` component is responsible for validating the entered responses against the correct answers.
6.  **Theming and Native Integration**: `Main.qml` manages the application's theme (light/dark mode) and uses the `Native/Android.cpp` module to adjust system UI elements like the status bar and navigation bar colors on Android, providing a seamless user experience.

## How Crosswords are Inserted and Updated

The project uses a SQLite database (implied by `Qt6::Sql` dependency and `QSqlDatabase` usage) to manage crossword data and user responses. The data handling is primarily managed by classes within the `CrosswordsGame/repositories/` directory.

### Crossword Data Insertion (Loading)

Crossword puzzles themselves are loaded into the application via the `CrosswordsRepository` class. The `getAllCrosswords()` method in `CrosswordsRepository.cpp` reads a static SQL query from `:/resources/sql/select_all_crosswords.sql`. This query retrieves `awake`, `label`, and `questions` data from a `crosswords` table. The `questions` data is stored as a JSON string in the database and then parsed into a `QVariantMap`.

```cpp
// In CrosswordsRepository.cpp
auto sql = ResourceUtils::readResource(":/resources/sql/select_all_crosswords.sql");
// ...
QSqlQuery query { m_db };
if (!query.exec(sql)) {
    // ...
}
// ... process results ...
```

The `select_all_crosswords.sql` file contains a simple `SELECT` statement:

```sql
SELECT awake, label, questions FROM crosswords ORDER BY awake DESC;
```

This indicates that the crossword data is pre-defined and loaded from the application's resources, rather than being dynamically inserted by the user or an administrative interface within the application itself. The `awake` field likely refers to the issue of the 'Awake!' magazine from which the crosswords are sourced.

### User Response Insertion and Update

User-entered responses (letters in the crossword grid) are managed by the `CrosswordsResponseRepository` class. When a user types a letter into a `Letter.qml` component, the `saveResponse()` signal is emitted, which eventually calls `insertResponse()` in `CrosswordsResponseRepository.cpp`.

```cpp
// In CrosswordsResponseRepository.cpp
bool CrosswordsResponseRepository::insertResponse(const QString& awake,
    int position,
    const QString& response) noexcept
{
    auto sql = ResourceUtils::readResource(":/resources/sql/insert_crosswords_response.sql");
    // ...
    QSqlQuery query { m_db };
    query.prepare(sql);
    query.addBindValue(awake);
    query.addBindValue(position);
    query.addBindValue(response);

    if (!query.exec()) {
        // ...
    }
    return true;
}
```

The `insert_crosswords_response.sql` file uses an `INSERT OR REPLACE` statement:

```sql
INSERT OR REPLACE INTO crosswords_response (awake, position, response) VALUES (?, ?, ?);
```

-   **`INSERT OR REPLACE`**: This SQL command is crucial. It means that if a response for a given `awake` (crossword identifier) and `position` (cell in the grid) already exists, it will be updated with the new `response`. If it doesn't exist, a new record will be inserted. This effectively handles both insertion and updating of user responses in the database.
-   **Parameterized Queries**: The `insertResponse` method uses `QSqlQuery::prepare()` and `QSqlQuery::addBindValue()` to bind the `awake`, `position`, and `response` parameters to the SQL query. This is a **best practice for database interaction**, as it prevents SQL injection vulnerabilities by ensuring that user-provided data is treated as data, not as executable SQL code.

### Deleting Responses

The `CrosswordsResponseRepository` also includes a `deleteResponses()` method, which is likely called when a user chooses to reset a crossword puzzle. This method uses a parameterized query with `delete_crosswords_responses.sql` to remove all saved responses for a specific crossword.

In summary, the application loads pre-defined crossword data from its resources and stores/updates user progress (their answers) in a local database using safe, parameterized SQL queries.
