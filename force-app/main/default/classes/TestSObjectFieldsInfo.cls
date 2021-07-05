@isTest
private class TestSObjectFieldsInfo{

	@testSetup static void contentDocumentSetup() {
		String fileContent = 'Name,Type\n';
		fileContent += 'TestAccount1,Prospect\n';
		fileContent += 'TestAccount2,Prospect\n';
		ContentVersion cntversion = new ContentVersion(
            Title = 'Account Insert',
            PathOnClient = 'Account.csv',
            VersionData = Blob.valueOf(fileContent),
            IsMajorVersion = true
        );
		Test.startTest();
        insert cntversion;
		Test.stopTest();       
	}

	static testMethod void validateSchemaDescribe(){
		List<String> opportunityFields = new List<String>{'Name','Type','Amount','StageName'};

		User currentUser = [Select Id from User where Id =: UserInfo.getUserId()]; 
        System.RunAs(currentUser){
			SObjectFieldsInfo.getsObjectNames();
			SObjectFieldsInfo.getObjectFields('Account');

			String[] accountReqFields = SObjectFieldsInfo.getRequiredFields('Account');
			System.assertEquals(accountReqFields[0],'Name','Success');

			Map<String,String> fieldNameTypeMap = SObjectFieldsInfo.getFieldType('Opportunity', opportunityFields);
			System.assertEquals('STRING(120)',fieldNameTypeMap.get('Name'),'Success');
		}	
	}

	static testMethod void validateFileParsing(){
		ContentVersion contentVersion = [SELECT Id, ContentDocumentId, Title FROM ContentVersion WHERE Title='Account Insert'];
		SingleObjectDataCreation.parseCSVFileData(contentVersion.ContentDocumentId, 'Account');	
		System.assertEquals('Account Insert',contentVersion.Title,'Content Doc');		
	}

	static testMethod void insertSobjectPositiveCase(){
		List<String> dataLoadProgress = new List<String>{'2'};  
		List<SObject> objToCreate = new List<SObject>();
		objToCreate.add(new Account(Name='Test Account 1', Type='Prospect', Website='http://myaccount.com'));
		objToCreate.add(new Account(Name='Test Account 2', Type='Prospect', Website='http://myaccount.com'));
		SingleObjectDataCreation.createDataForSObject(objToCreate, dataLoadProgress);
		Account acc = [SELECT Id,Name,Type,Website FROM Account WHERE Name ='Test Account 1' LIMIT 1];
		System.assertEquals('Prospect', acc.Type,'Inserted Account Type');
		System.assertEquals('http://myaccount.com', acc.Website,'Inserted Account Website');
	}

	static testMethod void insertSobjectNegativeCase(){
		List<String> dataLoadProgress = new List<String>{'1'};
      	List<SObject> objToCreate = new List<SObject>();
		objToCreate.add(new Account(Type='Prospect'));
		String[] results = SingleObjectDataCreation.createDataForSObject(objToCreate, dataLoadProgress);	
		System.assertEquals(results[2],'1','Errored Account');
	}
}