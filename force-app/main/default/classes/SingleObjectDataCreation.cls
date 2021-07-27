public inherited sharing class SingleObjectDataCreation {

	private static String successRecordIDs='';
	private static Boolean isChildObject = false;
	private static Map<Integer,Id> uniqueKeySFDCIdMap = new Map<Integer,Id>();

    /**
     * This method is used to parse the CSV File uploaded by user
     * @param idContentDocument ID of ContentDocument(CSV File) uploaded by user
     * @param objectName Object Name selected by user from UI
     * @return List of data load progress
    */
    @AuraEnabled
    public static String[] uploadCSVFile(Id idContentDocument, String objectName, String jsonObject)
	{
		List<String> dataLoadProgress = new List<String>();
		Integer totalRecords = 0;
		try{
			if(idContentDocument != null) 
			{
				ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =: idContentDocument WITH SECURITY_ENFORCED];
				List<String> csvLines = objVersion.VersionData.toString().split('\n');
				List<String> fieldNamesInHeader =  csvLines[0].split(',');
				
				Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(jsonObject);            
				isChildObject = (Boolean)results.get('isParentChild');
				successRecordIDs = (String)results.get('recordIDs');				
				
				System.debug('successRecordIDs:++ '+successRecordIDs);
				if((isChildObject == true  && String.isNotBlank(successRecordIDs))){
					String parentObjectName = (String)results.get('parentObjectName');	
					uniqueKeySFDCIdMap = ParentChildDataCreation.createUniqueKeyMap(successRecordIDs,parentObjectName);
				}
				totalRecords = csvLines.size() - 1;
				dataLoadProgress.add(String.valueOf(totalRecords));		
				List<SObject> objToCreate = parseCSVFile(csvLines,fieldNamesInHeader,objectName);		
				dataLoadProgress = createRecord(objToCreate,dataLoadProgress);				
			}
			return dataLoadProgress;
		}
		catch(Exception e){
			System.debug('Error ====>'+e.getMessage()+e.getStackTraceString());
			return null;
		}			
	}

	 /**
     * This method is used to create a Map of field names with string and sobjectfield type
	 * @param objectName Object Name selected by user from UI
     * @return Map of field names with string and sobjectfield type
    */
    public static Map<String,Schema.SObjectField> createSObjectFieldMap(String objectName){
		Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
		Map<String,Schema.SObjectField> fieldNameMap = new Map<String,Schema.SObjectField>();	
		for(Schema.SObjectField sfield : fieldMap.Values()){
			String fname = String.valueOf(sfield);
			fieldNameMap.put(fname,sfield);
		}
		return fieldNameMap;
	}

	/**
     * This method is used to prepare the records for insertion
     * @param csvLines Each row in the CSV File
     * @param fieldNamesInHeader CSV File Header
     * @param objectName Object Name selected by user from UI
     * @return List of Sobject records to be created
    */
	public static List<SObject> parseCSVFile(List<String> csvLines,List<String> fieldNamesInHeader,String objectName){
		List<SObject> objToCreate = new List<SObject>();
		try{
			Map<String,Schema.SObjectField> fieldNameMap = createSObjectFieldMap(objectName);
			for(Integer csvRow = 1; csvRow < csvLines.size(); csvRow++)
			{
				Schema.SObjectType sObjType  = Schema.getGlobalDescribe().get(objectName);
				SObject sobj = sObjType.newSObject();
				List<String> csvRowData = csvLines[csvRow].split(',');				 
				for(Integer k= 0; k < fieldNamesInHeader.size(); k++)
				{
					if(isChildObject== true && String.isNotBlank(successRecordIDs) && k==0){
						if(uniqueKeySFDCIdMap.containsKey(Integer.valueOf(csvRowData[k]))){
							csvRowData[k]= uniqueKeySFDCIdMap.get(Integer.valueOf(csvRowData[k]));
						}
						else{
							break;
						}
					}
					SObjectField sobjfield;
					if(k != fieldNamesInHeader.size() - 1){
						sobjfield = fieldNameMap.get(fieldNamesInHeader[k]);
					}
					else{
						String fname = fieldNamesInHeader[k].substring(0,fieldNamesInHeader[k].length() - 1);
						sobjfield = fieldNameMap.get(fname);
					}
					sobj.put(sobjfield,csvRowData[k]);  
				}
				objToCreate.add(sobj);    
			}			
			return objToCreate;
		}
		catch(Exception e){
			System.debug('Error ====>'+e.getMessage()+e.getStackTraceString());
			return null;
		}
	}
	
 
    /**
     * This method is used to create the list of sobject records and generate error log.
     * @param objToCreate List of Sobject records to be created
     * @param dataLoadProgress Holds the success and error count of the processed records
     * @return Progress of the data load and the error log
    */
    @AuraEnabled
    public static String[] createRecord(List<SObject> objToCreate, List<String> dataLoadProgress){
        Integer successCount = 0;
        Integer errorCount = 0;
        String errorLog = 'ERROR CODE,ERROR MESSAGE,FIELDS AFFECTED\n';
		String successRecords = '';      
        Database.SaveResult[] srSObjectList = Database.insert(objToCreate, false);		
        for (Database.SaveResult sr : srSObjectList) {
            if (sr.isSuccess()) {
                successCount++;  
				successRecords += '\''+String.escapeSingleQuotes(sr.getId()) + '\''+','; 				
				System.debug('successRecords===>'+successRecords);
            }
            else{                
                for(Database.Error err : sr.getErrors()) {
                    errorCount++;
                    errorLog += err.getStatusCode() + ','+ err.getMessage() + ','+ err.getFields() + '\n';
                }                
            }
        }
		if(successRecords.length()>0){
			successRecords= successRecords.substring(0,(successRecords.length()-1));
		}
	

        dataLoadProgress.add(String.valueOf(successCount));       
        dataLoadProgress.add(String.valueOf(errorCount));
        dataLoadProgress.add(errorLog);
		dataLoadProgress.add(successRecords);
        return dataLoadProgress;
    }
}