# Data Importer Lightning Web Component Application

Data Importer is an LWC application which can be used to load data for Standard and Custom objects.

## Table of Contents

-   Installation Instructions

    -   [Installing Data Importer using a Scratch Org](#installing-data-importer-using-a-scratch-org)
    -   [Installing Data Importer using Unlocked Packages](#installing-data-importer-using-unlocked-packages)
-   [Features](#features)

## Installation Instructions

There are two ways to install Data Importer:

-   [Using a Scratch Org](#installing-data-importer-using-a-scratch-org): This is the recommended installation option. Use this option if you are a developer who wants to experience the app and the code.
-   [Using Unlocked Packages](#installing-data-importer-using-unlocked-packages): This option allows anybody to experience the sample app without installing a local development environment.

### Installing Data Importer using a Scratch Org

1. Set up your environment. Follow the steps in the [Quick Start: Lightning Web Components](https://trailhead.salesforce.com/content/learn/projects/quick-start-lightning-web-components/) Trailhead project. The steps include:

    - Enable Dev Hub in your Trailhead Playground
    - Install Salesforce CLI
    - Install Visual Studio Code
    - Install the Visual Studio Code Salesforce extensions, including the Lightning Web Components extension

1. If you haven't already done so, authenticate with your hub org and provide it with an alias (**myhuborg** in the command below):

    ```
    sfdx auth:web:login -d -a myhuborg
    ```

1. Clone this repository:

    ```
    git clone https://github.com/Shalini1696/Data-Importer
    cd data-importer
    ```

1. Create a scratch org and provide it with an alias (**DataImporter** in the command below):

    ```
    sfdx force:org:create -s -f config/project-scratch-def.json -a DataImporter
    ```

1. Push source to your scratch org:

    ```
    sfdx force:source:push
    ```
1. Open the scratch org:

    ```
    sfdx force:org:open
    ```

### Installing Data Importer using an Unlocked Package

Follow this set of instructions if you want to deploy the app to a more permanent environment than a Scratch org or if you don't want to install the local developement tools. You can use a non source-tracked orgs such as a free [Developer Edition Org](https://developer.salesforce.com/signup) or a [Trailhead Playground](https://trailhead.salesforce.com/).

Make sure to start from a brand-new environment to avoid conflicts with previous work you may have done.

1. Log in to your org

1. Click [this link](**To be Updated**) to install the Data Importer unlocked package in your org.

1. Select **Install for All Users**

1. In App Launcher, click **View all**, select the **Data Importer** app.

#### Explore the application

1. In **App Launcher**, click **View all** then select the **Data Importer** app.

1. Have fun exploring!

## Features

A quick overview of the features you can explore in Data Importer:

-   Helps to upload data for both Parent and Child object without any manual intervention.
-   Field name mapping between the csv file and the API name is not required which inturn reduces the manual effort and avoid errors.
-   Maintains the history of data uploads. This helps in tracking of the data loaded by any user and also the older file can be reused anytime if required.
