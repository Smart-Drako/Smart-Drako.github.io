Paloma.controller 'Reportes', index: ->

  #Ocultar buscador y navbar inferior
  $(".carbar, #btn_busqueda_movil").removeClass("d-block").hide()
  $("#btn-cart_float").removeClass("d-md-block")

  #Ocultar los pickers por default
  $(".pickers").hide()
  
  #Mostrar los pickers y botones de generar reportes cuando seleccionan una opcuon
  $("#periodo_reporte").unbind("change").change ->
    $(".gj-picker").hide()
    if $(this).val() == "5" #Personalizado -> mostrar pickers
      $(".pickers").show()
    else
      $('#picker_desde, #picker_hasta').val("")
      $(".pickers").hide()
    
    if $(this).val() == ""
      $("#generar_reporte_pedidos, #generar_reporte_productos").addClass("disabled").val("")
    else
      $("#generar_reporte_pedidos, #generar_reporte_productos").removeClass("disabled").val("")
    calcular_reportes()
  
  #Pickers
  $('#picker_desde').datepicker
    uiLibrary: 'bootstrap4'
    locale: 'es-es'
    format: 'dd/mm/yy'
  $('#picker_hasta').datepicker
    uiLibrary: 'bootstrap4'
    locale: 'es-es'
    format: 'dd/mm/yy'
  
  $('#picker_desde, #picker_hasta').change ->
    calcular_reportes()
  
  calcular_reportes = ->
    periodo = parseInt($("#periodo_reporte").val())
    fecha_ini = $("#picker_desde").val()
    fecha_fin = $("#picker_hasta").val()

    if periodo == 5 && fecha_ini != "" && fecha_fin != ""
      params = "periodo=#{periodo}&fecha_ini=#{fecha_ini}&fecha_fin=#{fecha_fin}"
    else
      params = "periodo=#{periodo}"
    $('#generar_reporte_pedidos').attr("href", '/reportes/pedidos.xlsx?'+params)
    $('#generar_reporte_productos').attr("href", '/reportes/productos.xlsx?'+params)