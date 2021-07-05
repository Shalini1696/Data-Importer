public inherited sharing class SObjectFieldsInfo {
    /**
     * This method is used to fetch all the Standard & Custom Object Names in the Salesforce Org.
     * @return List of Object Names
    */
   @AuraEnabled(cacheable=true)
    public static List<String> getsObjectNames(){
        List<string> sObjectList = new List<string>();

        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            String name = objTyp.getDescribe().getName();
            if(!objTyp.getDescribe().isCustomSetting() && 
                     !name.containsignorecase('history') && !name.containsignorecase('tag')&&
                     !name.containsignorecase('share') && !name.containsignorecase('feed')&&
                     objTyp.getDescribe().isCreateable() && objTyp.getDescribe().isAccessible()){
                 
                sObjectList.add(name);
            }

        }
        return sObjectList;
    }

    /**
     * This method is used to fetch the list of fields in the given Object.
     * @param objectName Object Name selected by user from UI
     * @return List of Field Names
    */
    @AuraEnabled(cacheable=true)
    public static List<String> getObjectFields(String objectName){
        List<String> sObjectFieldsList = new List<String>();
        SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = objectType.getDescribe().fields.getMap();

        Map<String, System_Fields__mdt> sysFields = System_Fields__mdt.getAll();
        List<String> auditFields = new List<String>();
        for(String str : sysFields.keySet()){
            auditFields =  sysFields.get(str).Audit_Fields__c.split(',');
        }
        
        for(String fieldName : mfields.keySet()){
            if(!auditFields.contains(fieldName)){
                sObjectFieldsList.add(String.valueOf(mfields.get(fieldName)));
            }
           
        }
        return sObjectFieldsList;
    }

    
    /**
     * This method is used to fetch the list of required fields in the given Object.
     * @param objectName Object Name selected by user from UI
     * @return List of Required Field Names
    */
    @AuraEnabled(cacheable=true)
    public static List<String> getRequiredFields(String objectName){
        List<String> requiredFields = new List<String>();
        SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = objectType.getDescribe().fields.getMap();

        for(String field : mfields.keyset()) {
            Schema.DescribeFieldResult describeResult = mfields.get(field).getDescribe();
            if (describeResult.isCreateable()  && !describeResult.isNillable() && !describeResult.isDefaultedOnCreate()) {
                requiredFields.add(String.valueOf(mfields.get(field)));
            }
        }
        return requiredFields;
    }

    
    /**
     * This method is used to fetch the list of field types for the selected fields.
     * @param objectName Object Name selected by user from UI
     * @param selectedFieldNames Fields selected by user from UI
     * @return Map of Field Names and Field Types
    */
    @AuraEnabled(cacheable=true)
    public static Map<String,String> getFieldType(String objectName, String[] selectedFieldNames){

    SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
    Map<String,Schema.SObjectField> mfields = objectType.getDescribe().fields.getMap();
    Map<String,Schema.DescribeFieldResult> fieldDescMap = new Map<String,Schema.DescribeFieldResult>();

    Map<String,String> fieldNameAndTypeMap = new Map<String,String>();
    for(Schema.SObjectField sfield : mfields.Values())
    {
        Schema.DescribeFieldResult dfield = sfield.getDescribe();
        String fname = String.valueOf(sfield);
        fieldDescMap.put(fname,dfield);
    }

    for(String fieldName : selectedFieldNames){
      String dataType = String.valueOf(fieldDescMap.get(fieldName).getType());
        if(dataType == 'STRING'){
            String str = fieldDescMap.get(fieldName).getType()+'('+fieldDescMap.get(fieldName).getLength()+')';
            fieldNameAndTypeMap.put(fieldName,str);
        }
        else if(dataType == 'CURRENCY'){
            Integer maxDigit = Integer.valueOf(fieldDescMap.get(fieldName).getPrecision()) - Integer.valueOf( fieldDescMap.get(fieldName).getScale());
            String currencyLength = fieldDescMap.get(fieldName).getType()+'('+maxDigit+','+fieldDescMap.get(fieldName).getScale()+')';
            fieldNameAndTypeMap.put(fieldName,currencyLength);
        }
        else{
            String ftype = String.valueOf(fieldDescMap.get(fieldName).getType());
            fieldNameAndTypeMap.put(fieldName,ftype);
        }
       
    }
    return fieldNameAndTypeMap;
    }

    /**
     * This method is used to parse the CSV File uploaded by user
     * @param idContentDocument ID of ContentDocument(CSV File) uploaded by user
     * @param objectName Object Name selected by user from UI
     * @return List of Sobject records to be created
    */
    @AuraEnabled
    public static String[] parseCSVFileData(Id idContentDocument, String objectName){
		
		List<SObject> objToCreate = new List<SObject>();
		List<String> dataLoadProgress = new List<String>();
		Integer totalRecords = 0;
		try{
			if(idContentDocument != null) {
				ContentVersion objVersion = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =: idContentDocument WITH SECURITY_ENFORCED];
				List<String> csvLines = objVersion.VersionData.toString().split('\n');
				List<String> fieldNamesInHeader =  csvLines[0].split(',');
				Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
				Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
				totalRecords = csvLines.size() - 1;
				dataLoadProgress.add(String.valueOf(totalRecords));
				
				Map<String,Schema.SObjectField> fieldNameMap = new Map<String,Schema.SObjectField>();
				for(Schema.SObjectField sfield : fieldMap.Values()){
					String fn = String.valueOf(sfield);
					fieldNameMap.put(fn,sfield);
				}
			   
				for(Integer csvRow = 1; csvRow < csvLines.size(); csvRow++){
					Schema.SObjectType sObjType  = Schema.getGlobalDescribe().get(objectName);
					SObject sobj = sObjType.newSObject();
					List<String> csvRowData = csvLines[csvRow].split(',');
					for(Integer k=0; k < fieldNamesInHeader.size(); k++){
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
			}
			dataLoadProgress = createDataForSObject(objToCreate,dataLoadProgress);
			return dataLoadProgress;
		}catch(Exception e){
			System.debug(e.getMessage());
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
    public static String[] createDataForSObject(List<SObject> objToCreate, List<String> dataLoadProgress){
        Integer successCount = 0;
        Integer errorCount = 0;
        String csvErrorLog = 'ERROR CODE,ERROR MESSAGE,FIELDS AFFECTED\n';
        String csvErrorRow;
       
        Database.SaveResult[] srSObjectList = Database.insert(objToCreate, false);
        for (Database.SaveResult sr : srSObjectList) {
            if (sr.isSuccess()) {
                successCount++;               
            }
            else{
                
                for(Database.Error err : sr.getErrors()) {
                    errorCount++;
                    csvErrorRow = csvErrorLog + err.getStatusCode() + ','+ err.getMessage() + ','+ err.getFields() + '\n';
                }
                csvErrorLog = csvErrorRow;
            }
        }

        dataLoadProgress.add(String.valueOf(successCount));       
        dataLoadProgress.add(String.valueOf(errorCount));
        dataLoadProgress.add(csvErrorLog);
        return dataLoadProgress;
    }
}