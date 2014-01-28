trigger ReservacionAmenidadTrigger on Reservacion_Amenidad__c (before insert) {


	if(trigger.isBefore && trigger.isInsert){

		Set<Date> fechasInvolcradas = new Set<Date>();
		Set<Id> amenidadesInvolcradas = new Set<Id>();

		for (Reservacion_Amenidad__c reservacion : trigger.new) {
			fechasInvolcradas.add(reservacion.Fecha__c);
			amenidadesInvolcradas.add(reservacion.Amenidad__c);
		}



		List<Reservacion_Amenidad__c> reservacionesActuales = [Select id, 
																		Fecha__c,
																		Amenidad__c,
																		Hora_de_Inicio__c,
																		Hora_de_Termino__c
																		from Reservacion_Amenidad__c where Fecha__c in:fechasInvolcradas and Amenidad__c in: amenidadesInvolcradas];

															
		for (Reservacion_Amenidad__c reservacion : trigger.new) {


			for(Reservacion_Amenidad__c reservacionActual :  reservacionesActuales){

				//Revisamos que la reservación sea para la misma amenidad de nuestra reservación Actual
				if(reservacionActual.Amenidad__c == reservacion.Amenidad__c){

					//Convertimos a Datetime la fecha inicio y fecha final de mi reservación Actual
					Datetime fechaInicio = ReservacionAmenidadTriggerService.convertToDateTime(reservacion.Fecha__c, reservacion.Hora_de_Inicio__c);
					Datetime fechaFin = ReservacionAmenidadTriggerService.convertToDateTime(reservacion.Fecha__c, reservacion.Hora_de_Termino__c);

					Datetime fechaInicioActual = ReservacionAmenidadTriggerService.convertToDateTime(reservacionActual.Fecha__c, reservacionActual.Hora_de_Inicio__c);
					Datetime fechaFinActual = ReservacionAmenidadTriggerService.convertToDateTime(reservacionActual.Fecha__c, reservacionActual.Hora_de_Termino__c);

					if((fechaInicio >= fechaInicioActual && fechaInicio <= fechaFinActual) 
			                   || (fechaFin >= fechaInicioActual && fechaFin <= fechaFinActual) 
			                   || (fechaInicioActual >= fechaInicio &&  fechaInicioActual <= fechaFin) 
			                   || (fechaFinActual >= fechaInicio && fechaFinActual < = fechaFin )){

                    	reservacion.Hora_de_Inicio__c.addError('No hay Reservaciones disponibles en ese rango de Tiempo');

                	}
				}
			}
		}
	}

}