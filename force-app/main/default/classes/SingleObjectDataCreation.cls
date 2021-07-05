public inherited sharing class SingleObjectDataCreation {
    
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