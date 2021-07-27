public inherited sharing class ParentChildDataCreation {

    public static Map<Integer,Id> createUniqueKeyMap(String successRecords, String parentObjectName){
        Map<Integer,Id> uniqueKeyMap = new  Map<Integer,Id>();
        try{
            String uniqueKey = parentObjectName+'_Key__c';
            String queryFields = 'Id,'+uniqueKey;
            String query = 'SELECT '+ queryFields + ' FROM '+ parentObjectName + ' WHERE Id IN('+ successRecords+')';
            System.debug('Query----->'+query);
            for(Sobject sobj : Database.query(query)){
                Integer key = Integer.valueOf(sobj.get(uniqueKey));
                uniqueKeyMap.put(key,sobj.Id);
            }
            return uniqueKeyMap;
        }
        catch(Exception e){
			System.debug('Error ====>'+e.getMessage()+e.getStackTraceString());
			return null;
		}
    }
}