public class ReservacionAmenidadTriggerService {

	public static Datetime convertToDateTime(Date fecha, String tiempo){

		List<String> tiempoSplit = tiempo.split(':');
        
        Integer hora = integer.valueof(tiempoSplit.get(0));

        
        List<String> minutoSplit = tiempoSplit.get(1).split(' ');
  
        
        Integer minuto = integer.valueof(minutoSplit.get(0));
        String AMPM = minutoSplit.get(1);

        
        if(AMPM.contains('pm') && hora != 12){
            hora=hora+12;        
        }
        
        
        Datetime miFecha = datetime.newInstanceGmt(fecha.year(), fecha.month(), fecha.day(), hora, minuto, 0);       

		return miFecha;
	}
}