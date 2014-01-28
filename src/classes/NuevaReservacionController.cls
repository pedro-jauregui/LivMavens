public class NuevaReservacionController{
    
    public  Reservacion_Amenidad__c reservacionAmenidad {get;set;}
    public  Amenidad__c amenidad {get;set;}
    public List<Reservacion_Amenidad__c> reservacionesActuales {get;set;}
    
    public NuevaReservacionController(){
            
        Id id = ApexPages.currentPage().getParameters().get('id');
        reservacionesActuales = new List<Reservacion_Amenidad__c>();
        reservacionAmenidad = (id == null) ? new Reservacion_Amenidad__c() :[SELECT Name, 
                                                                                   Amenidad__c, 
                                                                                   Fecha__c,
                                                                                   Hora_de_Inicio__c,
                                                                                   Hora_de_Termino__c
                                                                             FROM Reservacion_Amenidad__c 
                                                                             WHERE Id = :id];      
    }

    public void agendar(){
        try {
            
          upsert(reservacionAmenidad);
          apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.Confirm,'Tu Reservación ha sido realizada '+amenidad.name+' '+reservacionAmenidad.Fecha__c+' de '+reservacionAmenidad.Hora_de_Inicio__c+' a '+reservacionAmenidad.Hora_de_Termino__c);
    		  apexpages.addmessage(msg);

        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
        }
    } 
    
    public List<selectOption> getAmenidades() {

      List<selectOption> opcionesAmenid = new List<selectOption>(); 
      opcionesAmenid.add(new selectOption('', '- None -')); 

      for (Amenidad__c amenidades : [SELECT Id, Name FROM Amenidad__c]) { 
        opcionesAmenid.add(new selectOption(amenidades.Id, amenidades.Name)); 
      }

      return opcionesAmenid; 
    }
    
    public void detallesAmenidad(){

      amenidad = (reservacionAmenidad.Amenidad__c == null) ? new Amenidad__c():[SELECT id, 
                                                                                      Name,
                                                                                      Descripcion__c, 
                                                                                      Restricciones__c,
                                                                                      IdImagen__c
                                                                                FROM Amenidad__c
                                                                                WHERE  id = : reservacionAmenidad.Amenidad__c];
     
                                                                                    }
    
    public void listaReservacionesPorDia()
    {
        reservacionesActuales = new List<Reservacion_Amenidad__c>();

         for( Reservacion_Amenidad__c a : [SELECT Name, 
                                          Amenidad__c, 
                                          Fecha__c,
                                          Hora_de_Inicio__c,
                                          Hora_de_Termino__c
                                          FROM Reservacion_Amenidad__c
                                          WHERE Fecha__c = :reservacionAmenidad.Fecha__c
                                          ORDER BY Amenidad__c
                                          ])
        {
            reservacionesActuales.add(a);
        }
    }
    
}