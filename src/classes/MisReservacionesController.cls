public class MisReservacionesController{

    public  List<Reservacion_Amenidad__c> reservacionAmenidad {get;set;}
    
    public MisReservacionesController(){
        
        String userId = UserInfo.getUserId();
        
        reservacionAmenidad = (userId == null) ? new List<Reservacion_Amenidad__c>() :[SELECT Name, 
                                                                                   Amenidad__c, 
                                                                                   Fecha__c,
                                                                                   Hora_de_Inicio__c,
                                                                                   Hora_de_Termino__c
                                                                             FROM Reservacion_Amenidad__c];      
   
    }
    

}