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
