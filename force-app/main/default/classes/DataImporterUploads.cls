public with sharing class DataImporterUploads {
   
    public static void trackDataUploads(String objectName, Boolean isChildObject, List<String> dataLoadProgress, ContentVersion cntVersion){

        Data_Importer_Uploads__c uploadRecord = new Data_Importer_Uploads__c();
        uploadRecord.Object_Name__c = objectName;
        if(isChildObject == true){
            uploadRecord.ObjectType__c = 'Parent-Child';
        }
        else{
            uploadRecord.ObjectType__c = 'Single';
        }
        uploadRecord.Total_Records__c = dataLoadProgress[0];
        uploadRecord.Success_Count__c = dataLoadProgress[1];
        uploadRecord.Error_Count__c = dataLoadProgress[2];
        uploadRecord.Uploaded_By__c = cntVersion.OwnerId;
        uploadRecord.Upload_Time__c = cntVersion.CreatedDate;
        Database.SaveResult result = Database.insert(uploadRecord, false);	
        if(!result.isSuccess()){
            System.debug('Error!');
        }
    }   
}