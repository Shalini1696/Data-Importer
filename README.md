<ApexTestDataGenerator is a sample application that demonstrates the unique value proposition of the Salesforce platform for building Employee Productivity and Customer Engagement apps.>

Table of contents
Installing ApexTestDataGenerator Using a Scratch Org: This is the recommended installation option. Use this option if you are a developer who wants to experience the app and the code.

Installing ApexTestDataGenerator Using an Unlocked Package: This option allows anybody to experience the sample app without installing a local development environment.

Installing ApexTestDataGenerator using a Developer Edition Org or a Trailhead Playground: Useful when tackling Trailhead Badges or if you want the app deployed to a more permanent environment than a Scratch org.

Installing ApexTestDataGenerator using a Scratch Org
Set up your environment. Follow the steps in the Quick Start: Lightning Web Components Trailhead project. The steps include:

Enable Dev Hub in your Trailhead Playground
Install Salesforce CLI
Install Visual Studio Code
Install the Visual Studio Code Salesforce extensions, including the Lightning Web Components extension
If you haven't already done so, authorize your hub org and provide it with an alias (myhuborg in the command below):

sfdx auth:web:login -d -a myhuborg
Clone this repository:

git clone https://github.com/ApexTestDataGeneratorapp/ApexTestDataGenerator-lwc
cd ApexTestDataGenerator-lwc
Create a scratch org and provide it with an alias (ApexTestDataGenerator in the command below):

sfdx force:org:create -s -f config/project-scratch-def.json -a ApexTestDataGenerator
Push the app to your scratch org:

sfdx force:source:push
Assign the ApexTestDataGenerator permission set to the default user:

sfdx force:user:permset:assign -n ApexTestDataGenerator
(Optional) Assign the Walkthroughs permission set to the default user.

Note: this will enable your user to use In-App Guidance Walkthroughs, allowing you to be taken through a guided tour of the sample app. The Walkthroughs permission set gets auto-created with In-App guidance activation.

sfdx force:user:permset:assign -n Walkthroughs
Import sample data:

sfdx force:data:tree:import -p data/sample-data-plan.json
Open the scratch org:

sfdx force:org:open
In Setup, under Themes and Branding, activate the Lightning Lite theme.

In App Launcher, select the ApexTestDataGenerator app.

Installing ApexTestDataGenerator using an Unlocked Package
Follow this set of instructions if you want to deploy the app to a more permanent environment than a Scratch org or if you don't want to install the local developement tools. You can use a non source-tracked orgs such as a free Developer Edition Org or a Trailhead Playground.

Make sure to start from a brand-new environment to avoid conflicts with previous work you may have done.

Log in to your org

Start an In-App Guidance trial

In Setup, navigate to User Engagement > In-App Guidance.
Click on the Start Walkthrough Trial.
Click on Submit.
Click this link to install the ApexTestDataGenerator unlocked package in your org.

Select Install for All Users

In App Launcher, click View all, select the ApexTestDataGenerator app.

Click the Settings tab and click the Import Data button in the Sample Data Import component.

If you're attempting the Quick Start on Trailhead, this step is required, but otherwise, skip:

Go to Setup > Users > Permission Sets.
Click ApexTestDataGenerator.
Click Manage Assignments.
Check your user and click Add Assignments.
In Setup, under Themes and Branding, activate the Lightning Lite theme.

In App Launcher, select the ApexTestDataGenerator app.

Installing ApexTestDataGenerator using a Developer Edition Org or a Trailhead Playground
Follow this set of instructions if you want to deploy the app to a more permanent environment than a Scratch org. This includes non source-tracked orgs such as a free Developer Edition Org or a Trailhead Playground.

Make sure to start from a brand-new environment to avoid conflicts with previous work you may have done.

Clone this repository:

git clone https://github.com/ApexTestDataGeneratorapp/ApexTestDataGenerator-lwc
cd ApexTestDataGenerator-lwc
Authorize your Trailhead Playground or Developer org and provide it with an alias (mydevorg in the command below):

sfdx auth:web:login -s -a mydevorg
Start an In-App Guidance trial

In Setup, navigate to User Engagement > In-App Guidance.
Click on the Start Walkthrough Trial.
Click on Submit.
Run this command in a terminal to deploy the app.

sfdx force:source:deploy -p force-app
Assign the ApexTestDataGenerator permission set to the default user.

sfdx force:user:permset:assign -n ApexTestDataGenerator
Import some sample data.

sfdx force:data:tree:import -p ./data/sample-data-plan.json
If your org isn't already open, open it now:

sfdx force:org:open -u mydevorg
In Setup, under Themes and Branding, activate the Lightning Lite theme.

In App Launcher, select the ApexTestDataGenerator app.