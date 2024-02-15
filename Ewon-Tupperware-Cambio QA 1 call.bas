Rem --- eWON start section: User Section
Rem --- eWON user (start)
AIB_event_requesthttpx:
        eventRequest% = GETSYS PRG, "EVTINFO"
        IF (actionIDRequest% = eventRequest%) THEN
            SETSYS PRG, "ACTIONID", eventRequest%
            statevent% = GETSYS PRG, "ACTIONSTAT"
            IF (statevent% = 0) THEN
                GOTO AIB_track_responsehttpx:
            ELSE 
                PRINT "ERROR: Evento interno eWON REQUESTHTTPX (" + STR$(statevent%) + ")"
            ENDIF
        ENDIF
AIB_track_responsehttpx:
        resp_status$ = RESPONSEHTTPX "STATUSCODE"
        IF (resp_status$ = "200") THEN
            resp_body$ = RESPONSEHTTPX "RESPONSE-BODY"
            IF (LEN(resp_body$) < 1000) THEN
                PRINT "200"
                
            ELSE
                PRINT "ADVERTENCIA:"
                PRINT "Tamaño de respuesta mayor al establecido (1000): ";
                PRINT LEN(resp_body$)
                PRINT "200"
            ENDIF
        ELSE
          PRINT "ERROR:"
          PRINT "Código de respuesta WEB = " + resp_status$ 
        ENDIF
Rem --- eWON user (end)
End
Rem --- eWON end section: User Section
Rem --- eWON start section: Cyclic Section
eWON_cyclic_section:
Rem --- eWON user (start)
data_monitor_1% = IOMOD "Consolidado_TrackID"
data_monitor_2% = IOMOD "Inventory_Transfer_TrackID"


IF data_monitor_1% THEN
  PRINT Codigo_Consolidado_Scanner_1@
  $server$ = "http://159.234.152.91:8080/aibapi/data/FinishG" 
  $method$ = "POST"
  $header$ = "Content-Type=application/json"
  
  $apiData1$= '{"QRCode":"'+Codigo_Consolidado_Scanner_1@+'","Clave_Producto":"'+Clave_Producto_Scanner_1@+'","Consecutivo":"'+Identificador_Unico_Scanner_1@+'","Verificador":"'+Codigo_Verificador_Scanner_1@+'",'
  $apiData2$= '"OT":"'+Work_Order_Scanner_1@+'","Fecha":"'+Fecha_Scanner_1@+'","Turno":"'+Turno_Scanner_1@+'","Maquina_Area":"'+Maquina_Scanner_1@+'","Empaque":"'+Empaque_Scanner_1@+'","Impresora":"'+Impresora_Scanner_1@+'",'
  $apiData3$= '"Peso":"'+Peso_Teorico_Scanner_1@+'","username":"JDEORCH","password":"arty#1990","environment":"JQA920","role":"*ALL",'
  $apiData4$= '"inputs":[{"name":"Member Description 1","value":"'+Codigo_Consolidado_Scanner_1@+'"}]}'
 
  $apiData$ = $apiData1$ +$apiData2$ + $apiData3$ + $apiData4$
  REQUESTHTTPX $server$, $method$, $header$, $apiData$
  actionIDRequest% = GETSYS PRG, "ACTIONID"
  Rem Print Codigo_rechazo%
ENDIF

IF data_monitor_2% THEN
  PRINT Codigo_Inventory_Transfer_Scanner_6@
  $server$ = "http://159.234.152.91:8080/aibapi/data/Bulk" 
  $method$ = "POST"
  $header$ = "Content-Type=application/json"
  
  $apiData1$= '{"QR_Code":"'+Codigo_Inventory_Transfer_Scanner_6@+'","Clave_Producto":"'+Clave_Producto_Scanner_6@+'","Consecutivo":"'+Identificador_Unico_Scanner_6@+'","Verificador":"'+Codigo_Verificador_Scanner_6@+'",'
  $apiData2$= '"OT":"'+Work_Order_Scanner_6@+'","Fecha":"'+Fecha_Scanner_6@+'","Turno":"'+Turno_Scanner_6@+'","Maquina_Area":"'+Maquina_Scanner_6@+'","Empaque":"'+Empaque_Scanner_6@+'","Impresora":"'+Impresora_Scanner_6@+'",'
  $apiData3$= '"Peso":"'+Peso_Teorico_Scanner_6@+'","username":"JDEORCH","password":"arty#1990","environment":"JQA920","role":"*ALL",'
  $apiData4$= '"inputs":[{"name":"QR_Code","value":"'+Codigo_Inventory_Transfer_Scanner_6@+'"}]}'
 
  $apiData$ = $apiData1$ +$apiData2$ + $apiData3$ + $apiData4$
  REQUESTHTTPX $server$, $method$, $header$, $apiData$
  actionIDRequest% = GETSYS PRG, "ACTIONID"
ENDIF


Rem --- eWON user (end)
End
Rem --- eWON end section: Cyclic Section
Rem --- eWON start section: Init Section
eWON_init_section:
Rem --- eWON user (start)
ONSTATUS "GOTO AIB_event_requesthttpx"
Rem --- eWON user (end)
End
Rem --- eWON end section: Init Section
