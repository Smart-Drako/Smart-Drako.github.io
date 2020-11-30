Paloma.controller 'Reportes', index: ->

  #Ocultar buscador y navbar inferior
  $(".carbar, #btn_busqueda_movil").removeClass("d-block").hide()
  $("#btn-cart_float").removeClass("d-md-block")

  #Ocultar los pickers por default
  $(".pickers").hide()
  
  #Mostrar los pickers y botones de generar reportes cuando seleccionan una opcuon
  $("#periodo_reporte").change ->
    if $(this).val() == "5" #Personalizado -> mostrar pickers
      $(".pickers").show()
    else
      $(".pickers").hide()
    
    if $(this).val() == ""
      $("#generar_reporte_pedidos, #generar_reporte_productos").prop("disabled", true)
    else
      $("#generar_reporte_pedidos, #generar_reporte_productos").prop("disabled", false)
  
  #Pickers
  $('#picker_desde').datepicker
    uiLibrary: 'bootstrap4'
    locale: 'es-es'
    format: 'dd/mm/yy'
  $('#picker_hasta').datepicker
    uiLibrary: 'bootstrap4'
    locale: 'es-es'
    format: 'dd/mm/yy'
  
  #Eventos botones generar reporte
  $("#generar_reporte_pedidos").unbind("click").click ->
    console.log "Generar Reporte Pedidos"
    generar_reporte_pedidos()
  
  $("#generar_reporte_productos").unbind("click").click ->
    generar_reporte_productos()

  #Funciones generar reportes
  generar_reporte_pedidos =  ->
    alert("Generando Reporte de Pedidos...")

  generar_reporte_productos = ->
    alert("Generando Reporte de Productos...")