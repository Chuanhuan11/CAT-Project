# How to Run 'Univent' in IntelliJ IDEA

Since this is a standard Java Web Project (not Maven/Gradle), you need to configure it manually in IntelliJ. Follow these steps exactly:

## 1. Open the Project
1.  Open IntelliJ IDEA.
2.  Click **Open** or **File > Open**.
3.  Select the **`CAT-Project`** folder.

## 2. Setup Project Structure
1.  Go to **File > Project Structure** (Ctrl+Alt+Shift+S).
2.  **Project Settings > Project**:
    -   Ensure **SDK** is set to Java 1.8 or higher (e.g., JDK 17 or 21).
3.  **Project Settings > Modules**:
    -   Click on the `CAT-Project` module.
    -   Go to the **Paths** tab.
    -   Select **"Use module compile output path"**.
4.  **Project Settings > Libraries** (Crucial Step!):
    -   Click **+ (New Project Library)** -> **Java**.
    -   Locate your **Command Line** or downloaded JARs.
    -   You MUST add the **MySQL Connector JAR** (`mysql-connector-j-8.x.x.jar`).
    -   *(If you don't have it, download it from MySQL website).*
    -   Also ensure you have **Java Servlet API** (usually comes with Tomcat, see below).

## 3. Configure Tomcat Server
1.  Click **Add Configuration** (top right) -> **+** -> **Tomcat Server** -> **Local**.
2.  **Server** Tab:
    -   **Application server**: Select your installed Apache Tomcat directory.
3.  **Deployment** Tab:
    -   Click **+** -> **Artifact**.
    -   Select **`CAT-Project:war exploded`** (or create a new artifact from module contents if missing).
    -   **Application context**: Set this to `/univent` (or just `/`).
4.  Click **Apply** and **OK**.

## 4. Database Check
1.  Open `src/main/java/com/univent/utils/DBConnection.java`.
2.  **CRITICAL**: Change lines 9 and 10:
    ```java
    private static final String USER = "root";       // <-- CHANGE TO YOUR MYSQL USERNAME
    private static final String PASS = "password";   // <-- CHANGE TO YOUR MYSQL PASSWORD
    ```
3.  Open your Database Tool (or Workbench) and run the `database.sql` file to create the tables.

## 5. Run it!
1.  Click the Green **Run** (Play) button in IntelliJ.
2.  Tomcat should start.
3.  Your browser should open to `http://localhost:8080/univent`.
