# Data Importer Lightning Web Component Application

Data Importer is an LWC application which can be used to upload data for Standard and Custom objects.This tool allows users to select the object and its fields from UI and generates a template for data loading. The data can then be filled in this template and uploaded directly from UI.

## Table of Contents

-   [Installation Instructions](#installation-instructions)

    -   [Installing Data Importer using a Scratch Org](#installing-data-importer-using-a-scratch-org)
    -   [Installing Data Importer using Unlocked Package](#installing-data-importer-using-unlocked-package)

-   [Features](#features)
-   [Steps for the Data Import](#steps-for-data-loading)
	
	-	[Single Object](#single-object)
	-	[Parent Child Object](#parent-child-object)

-   [Sample File for the Data Import](#sample-file-for-the-data-import)

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

1. If you haven't already done so, authenticate with your hub org and provide it with an alias (**mydevhuborg** in the command below):

    ```
    sfdx auth:web:login -d -a mydevhuborg
    ```]

1. Clone this repository:

    ```
    git clone https://github.com/Shalini1696/data-importer
    cd data-importer
    ```

1. Create a scratch org and provide it with an alias (**dataImporter** in the command below):

    ```
    sfdx force:org:create -s -f config/project-scratch-def.json -a dataImporter
    ```

1. Push source to your scratch org:

    ```
    sfdx force:source:push
    ```

1. Open the scratch org:

    ```
    sfdx force:org:open
    ```
	
### Installing Data Importer using Unlocked Package

Follow this set of instructions if you want to deploy the app to a more permanent environment than a Scratch org or if you don't want to install the local developement tools. You can use a non source-tracked orgs such as a free [Developer Edition Org](https://developer.salesforce.com/signup) or a [Trailhead Playground](https://trailhead.salesforce.com/).

Make sure to start from a brand-new environment to avoid conflicts with previous work you may have done.

1. Log in to your org

1. Click [this link](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t2w000009MgojAAC) to install the and choose **Install for All Users**.

1. From the command line, enter the following commands to clone this repository. You need to do this to get the metadata, code and files with sample data on your computer:

    ```
    git clone https://github.com/Shalini1696/data-importer
    cd data-importer
    ```

#### Explore the application

1. In **App Launcher**, click **View all** then select the **Data Importer** app.

1. Have fun exploring!

### Features

Below are some of the key advantages over Salesforce Data Loader:

-   Helps to upload data for both Parent and Child object without any manual intervention.
-   Field name mapping between the csv file and the API name is not required which inturn reduces the manual effort and avoid errors.
-   Maintains the history of data uploads. This helps in tracking of the data loaded by any user and also the older file can be reused anytime if required.

## Steps for the Data Import

The following are the steps to load data for Single/ Parent & Child object.

### Single Object

1.	Navigate to the tab "Generate Data Template" to generate a template for the object for data loading.
1.	Select the object type.
1.	Select the object name and its fields. The field name and its datatype will be displayed for the selected fields.
1.	Please click on download template link to generate template for the selected fields.
1.	Navigate to the tab "Upload File & Track Progress" to upload the template and select the object type.
1.	Please select the object name and upload the file. Click on 'Done' in the popup window. The status of the upload will the displayed with the success and error count.

### Parent Child Object

1.	Navigate to the tab "Generate Data Template" to generate a template for the object for data loading.
1.	Select the object type.
1.	Select the object name and its fields. The field name and its datatype will be displayed for the selected fields.
1.	Please click on download template link to generate template for the selected fields.
1.  	Repeat Step 4 to generate template for child object as well.
1.	Navigate to the tab "Upload File & Track Progress" to upload the template and select the object type.
1.	Please select the parent object name and upload the file. Click on 'Done' in the popup window. The status of the upload will the displayed with the success and error count. Repeat Step 7 to upload the file for child object.

### Note

-	Please create a text field in parent object in the following format(objectname_key__c) and keep this field in the column A of parent object's template.
-	Also, please keep the parent object reference(Eg: AccountId) in the column A of child object's template and map it with the corresponding unique key identifier provided in the parent object's template.

## Sample File for the Data Import

### Single Object

![Single Object](https://user-images.githubusercontent.com/86902550/127331818-fb3d7d66-1931-4528-bdc2-aa4c9cef0811.PNG)

### Parent & Child Object

**Parent Object: Account**

Here Account_Key__c is the unique key identifier which helps to map the account record with the related contacts.

![Parent Object](https://user-images.githubusercontent.com/86902550/127330318-09e08953-ed92-4fdd-aa9b-9ac930e23766.PNG)

**Child Object: Contact**

The parent reference(AccountId) will be replaced with the salesforce ID's during the creation of child records. Also, the child record will be created if and only if the parent record got inserted successfully without any validation errors.

![Child Object](https://user-images.githubusercontent.com/86902550/127330345-101b2e2a-86a7-4319-ba26-94b7df3a5c00.PNG)
