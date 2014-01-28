trigger DisponibilidadReservacion on Reservacion_Amenidad__c (before insert, before update) {
    
    
    
    for (Reservacion_Amenidad__c objReservacionAmeni : Trigger.new) 
    {
        
        List<DATETIME> listaFechasHorasInicialesExistentes = new List<DATETIME>();
        List<DATETIME> listaFechasHorasFinalesExistentes = new List<DATETIME>();
        /// Seccion Obtencion de DATETIME Solicitada
        Date fechaSolicitada = objReservacionAmeni.Fecha__c;
        
        List<String> LihoraInicioSolicitada = objReservacionAmeni.Hora_de_Inicio__c.split(':');
        List<String> LishoraFinSolicitada = objReservacionAmeni.Hora_de_Termino__c.split(':');
        
        integer horaInicioUnicamente = integer.valueof(LihoraInicioSolicitada[0]);
        integer horaFinUnicamente = integer.valueof(LishoraFinSolicitada[0]);
        
        List<String> minIniPAM = LihoraInicioSolicitada[1].split(' ');
        List<String> minFinPAM = LishoraFinSolicitada[1].split(' ');
        
        integer minIni = integer.valueof(minIniPAM[0]);
        string PAMIni = minIniPAM[1];
        
        integer minFin = integer.valueof(minFinPAM[0]);
        string PAMFin = minFinPAM[1];
        
        if(PAMIni.contains('pm') && horaInicioUnicamente != 12)
        {
            horaInicioUnicamente=horaInicioUnicamente+12;
        }
        
        if(PAMFin.contains('pm') && horaFinUnicamente != 12)
        {
            horaFinUnicamente=horaFinUnicamente+12;
        }
        
        Datetime fechaHoraInicial = datetime.newInstanceGmt(fechaSolicitada.year(), fechaSolicitada.month(), fechaSolicitada.day(), horaInicioUnicamente, minIni, 0);
        Datetime fechaHoraFinal = datetime.newInstanceGmt(fechaSolicitada.year(), fechaSolicitada.month(), fechaSolicitada.day(), horaFinUnicamente, minFin, 0);
        
        System.Debug('XDfechaHoraInicial'+fechaHoraInicial);
        System.Debug('XDfechaHoraFinal '+fechaHoraFinal);
        /////// Fin de la Seccion 
        
        for( Reservacion_Amenidad__c a : [SELECT Name, 
                                          Amenidad__c, 
                                          Fecha__c,
                                          Hora_de_Inicio__c,
                                          Hora_de_Termino__c
                                          FROM Reservacion_Amenidad__c
                                          Where Amenidad__c = : objReservacionAmeni.Amenidad__c
                                          AND Fecha__c = :objReservacionAmeni.Fecha__c
                                         ])
        {
            ///Seccion hace listas de las Datetime existentes
            Date fechaExistenteaAnadir = a.Fecha__c;
            
            List<String> LihoraInicioAnadir = a.Hora_de_Inicio__c.split(':');
            List<String> LishoraFinAnadir = a.Hora_de_Termino__c.split(':');
            
            integer horaInicioUnicamenteAnadir = integer.valueof(LihoraInicioAnadir[0]);
            integer horaFinUnicamenteAnadir = integer.valueof(LishoraFinAnadir[0]);
            
            List<String> minIniPAMAnadir = LihoraInicioAnadir[1].split(' ');
            List<String> minFinPAMAnadir = LishoraFinAnadir[1].split(' ');
            
            integer minIniAnadir = integer.valueof(minIniPAMAnadir[0]);
            string PAMIniAnadir = minIniPAMAnadir[1];
            
            integer minFinAnadir = integer.valueof(minFinPAMAnadir[0]);
            string PAMFinAnadir = minFinPAMAnadir[1];
            
            if(PAMIniAnadir.contains('pm') && horaInicioUnicamenteAnadir != 12)
            {
                horaInicioUnicamenteAnadir=horaInicioUnicamenteAnadir+12;
            }
            
            if(PAMFinAnadir.contains('pm') && horaFinUnicamenteAnadir != 12)
            {
                horaFinUnicamenteAnadir=horaFinUnicamenteAnadir+12;
            }
            
            Datetime fechaHoraInicialAnadir = datetime.newInstanceGmt(fechaExistenteaAnadir.year(), fechaExistenteaAnadir.month(), fechaExistenteaAnadir.day(), horaInicioUnicamenteAnadir, minIniAnadir, 0);
            Datetime fechaHoraFinalAnadir = datetime.newInstanceGmt(fechaExistenteaAnadir.year(), fechaExistenteaAnadir.month(), fechaExistenteaAnadir.day(), horaFinUnicamenteAnadir, minFinAnadir, 0);
            
                System.debug('XDFECHAINICIALAÑADIR'+fechaHoraInicialAnadir);
            
            listaFechasHorasInicialesExistentes.add(fechaHoraInicialAnadir);
            listaFechasHorasFinalesExistentes.add(fechaHoraFinalAnadir);
            
                            System.debug('XDlista'+listaFechasHorasInicialesExistentes);

            ///fin seccion
        }
        
        System.debug('XDlistaAfuera '+listaFechasHorasInicialesExistentes);

        //Seccion de Comparecion de Datetime actual con lista
        if(listaFechasHorasInicialesExistentes != null && listaFechasHorasInicialesExistentes.size() > 0)
        {
            string pruebaError= 'ok';
            System.debug('XDlistatamaño '+listaFechasHorasInicialesExistentes.size());

                System.debug('XDpruebaeRROR'+pruebaError);
            for(integer i=0; i == listaFechasHorasInicialesExistentes.size(); i++)
            {
                System.debug('XDpruebaeRROR'+pruebaError);
                if((fechaHoraInicial >= listaFechasHorasInicialesExistentes[i] && fechaHoraInicial <= listaFechasHorasFinalesExistentes[i]) 
                   || (fechaHoraFinal >= listaFechasHorasInicialesExistentes[i] && fechaHorafinal <= listaFechasHorasFinalesExistentes[i]) 
                   || (listaFechasHorasInicialesExistentes[i] >= fechaHoraInicial &&  listaFechasHorasInicialesExistentes[i] <= fechaHoraFinal) 
                   || (listaFechasHorasFinalesExistentes[i] >= fechaHoraInicial && listaFechasHorasFinalesExistentes[i] < = fechaHoraFinal )
                   || pruebaError=='ok')
                    
                {
                    objReservacionAmeni.Hora_de_Inicio__c.addError('No hay Reservaciones disponibles en ese rango de Tiempo');
                }
            }
        }
        /// fin seccion
    }
    
}