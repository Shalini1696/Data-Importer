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
            Schema.DescribeFieldResult dfr = mfields.get(fieldName).getDescribe();  
            if(!auditFields.contains(fieldName) && !dfr.isCalculated()){
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
        try{
        
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
         }
         catch(Exception e){
            return null;
         }
         return fieldNameAndTypeMap;
    }
}