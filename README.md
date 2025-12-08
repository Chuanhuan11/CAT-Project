Server Setup Guide

Part 1: Download Apache Tomcat

1. Download: Go to the Apache Tomcat 9 Download Page.
2. Select Version: Under Binary Distributions > Core, download the zip (for Windows) or tar.gz (for Mac).
3. Note: Do not use the "Installer" version; the zip version is easier for IntelliJ.
4. Extract: Unzip the folder to a safe place (e.g., C:\Tomcat9 or Documents/Tomcat).

Part 2: Configure IntelliJ (Do this once)

IntelliJ does not share these settings, so you must set this up manually on your own laptop.

1. Add Configuration:
   
   In IntelliJ, click Add Configuration (Top Right corner) > Click + > Select Tomcat Server > Local.
   
2. Link Tomcat:

   In the Server tab, click Configure... and browse to the folder you just extracted in Part 1.

3. Deploy the App (Crucial):
   
   Click the Deployment tab (next to Server tab).

   Click + > Select Artifact.
   
   Choose Univent:war exploded.
   
5. Finish:
   
   Click Apply > OK.
   
   Click the green Play button to run the site.

Database Setup Guide

Part 1: Install MySQL Server

If you already have XAMPP, just click "Start" next to MySQL and skip to Part 2.

1. Download: Go to the MySQL Community Installer Page. https://dev.mysql.com/downloads/installer/
2. Select: Download the Windows (x86, 32-bit), MSI Installer (The larger file).
3. Install: Run the installer.

   Choose "Developer Default" or "Server Only".

   Click Next until you reach Accounts and Roles.

4. Set Password (CRITICAL):

   Create a Root Password (e.g., 1234 or root).

   WRITE THIS DOWN. You cannot recover it later.

5. Finish: Complete the installation and ensure the "MySQL" service is running.


Part 2: Run the SQL Script (Create Tables)

We are using IntelliJ to run the script, so you don't need to open Workbench.

1. Open IntelliJ: Look for the Database tab on the very right sidebar.

2. Add Connection:

   Click + (Plus) > Data Source > MySQL.

   User: root

   Password: Type the password you created in Part 1.

   Test Connection: It must show a green checkmark. (If it fails, check your password).

   Click OK.

3. Run Script:

   In the project view (left), go to src/main/resources/.

   Right-click database.sql.

   Select Run 'database.sql'.

   Choose the console you just created.

4. Verify: You should see output at the bottom saying CREATE TABLE successful.


Part 3: Connect Java to Database

Your code needs to know your local password to connect.

1. Open File: Go to src/main/java/com/univent/util/DBConnection.java.

2. Edit Password:

   Find the line: private static final String PASSWORD = "";

   Change "" to your actual password (e.g., "1234").

   Don't Commit This: Try not to push your personal password to GitHub if possible, or remember to change it back before pushing.
