Paloma.controller 'Productos', tienda: ->
  #Cargarlos si estan ya en localStorage
  cargar_productos()
  eventos()

@cargar_productos = ->
  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  total_pedido = localStorage.getItem("total_pedido") || "0"

  #Mostrar items en badges y total $
  $(".total-items").text(productos.length)
  $(".total-pedido").text(number_to_currency(total_pedido))
  handlebars_productos()


eventos = ->
  $('.btn-cart-item').unbind("click").click ->
    agregar_producto($(this))
    
  $('#btn-procesar').unbind("click").click ->
    localStorage.removeItem("total_pedido")
    localStorage.removeItem("productos")
    cargar_productos()
  
handlebars_productos = ->
    productos = JSON.parse(localStorage.getItem("productos") || "[]")
    source = $("#handlebars_carrito_item").html()
    template = Handlebars.compile(source)
    $('#carrito_items').html(template(productos: productos))

agregar_producto = (producto) ->
  #Cantidad de productos
  id = producto.data("id")
  precio = parseInt(producto.data("precio"))
  nombre = producto.data("nombre")
  productos = JSON.parse(localStorage.getItem("productos") || "[]")
  total_pedido = parseFloat(localStorage.getItem("total_pedido") || 0 )

  if productos.length == 0 
    total_pedido = precio
    productos.push({id: id, nombre: nombre, precio: precio, cantidad: 1 , subtotal: precio, precio_string: number_to_currency(precio), subtotal_string: number_to_currency(precio)})
  else
    existe = false
    productos.forEach (prod) ->
      if prod.id == id
        existe = true
        prod.cantidad = prod.cantidad + 1
        prod.subtotal = prod.cantidad * prod.precio
        total_pedido = total_pedido + prod.precio
        prod.subtotal_string = number_to_currency(prod.subtotal)
      return
    if existe == false
      productos.push({id: id, nombre: nombre, precio: precio, cantidad: 1 , subtotal: precio, precio_string: number_to_currency(precio), subtotal_string: number_to_currency(precio)})
      total_pedido = total_pedido + precio

  localStorage.setItem("total_pedido", total_pedido)
  localStorage.setItem("productos", JSON.stringify(productos))
  cargar_productos()

  #Utilidades

@number_to_currency = (number, options) ->
  `var options`
  try
    options = options or {}
    precision = options['precision'] or 2
    unit = options['unit'] or '$'
    separator = if precision > 0 then options['separator'] or '.' else ''
    delimiter = options['delimiter'] or ','
    parts = parseFloat(number).toFixed(precision).split('.')
    return unit + number_with_delimiter(parts[0], delimiter) + separator + parts[1].toString()
  catch e
    return number
  return

number_with_delimiter = (number, delimiter, separator) ->
  `var delimiter`
  `var separator`
  try
    delimiter = delimiter or ','
    separator = separator or '.'
    parts = number.toString().split('.')
    parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1' + delimiter)
    return parts.join(separator)
  catch e
    return number
  return