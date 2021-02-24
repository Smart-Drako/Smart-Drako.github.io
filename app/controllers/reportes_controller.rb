class ReportesController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end

  def reporte_pedidos
    
    periodo = params[:periodo].to_i
    case periodo
    when 1 #Hoy
      fecha_ini = Date.today
      fecha_fin = Date.today + 1
    when 2 #Ayer
      fecha_ini = Date.today - 1
      fecha_fin = Date.today
    when 3 #Mes Actual
      fecha_ini = Date.today.beginning_of_month
      fecha_fin = Date.today.end_of_month
    when 4 #Mes Pasado
      fecha_ini = (Date.today-1.month).beginning_of_month
      fecha_fin = (Date.today-1.month).end_of_month
    when 5 #Custom
      fecha_ini = Date.strptime(params[:fecha_ini], '%d/%m/%y')
      fecha_fin = Date.strptime(params[:fecha_fin], '%d/%m/%y')
    end

    @usuario = ConfigUser.find_by(user_id: current_user.id)
    if fecha_ini.present? && fecha_fin.present?
      @pedidos = Pedido.where(user_id: @usuario.id).where('date(created_at) >= ? and date(created_at) <=?', fecha_ini, fecha_fin).order(id: :desc)
    else
      @pedidos = Pedido.where(user_id: @usuario.id).order(id: :desc)
    end
    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="reporte_pedidos.xlsx"' }
    end
  end

  def reporte_productos
    periodo = params[:periodo].to_i
    case periodo
    when 1 #Hoy
      fecha_ini = Date.today
      fecha_fin = Date.today + 1
    when 2 #Ayer
      fecha_ini = Date.today - 1
      fecha_fin = Date.today
    when 3 #Mes Actual
      fecha_ini = Date.today.beginning_of_month
      fecha_fin = Date.today.end_of_month
    when 4 #Mes Pasado
      fecha_ini = (Date.today-1.month).beginning_of_month
      fecha_fin = (Date.today-1.month).end_of_month
    when 5 #Custom
      fecha_ini = Date.strptime(params[:fecha_ini], '%d/%m/%y')
      fecha_fin = Date.strptime(params[:fecha_fin], '%d/%m/%y')
    end

    @usuario = ConfigUser.find_by(user_id: current_user.id)
    if fecha_ini.present? && fecha_fin.present?
      @pedidos = Pedido.where(user_id: @usuario.id).where('date(created_at) >= ? and date(created_at) <=?', fecha_ini, fecha_fin).order(id: :desc)
    else
      @pedidos = Pedido.where(user_id: @usuario.id).order(id: :desc)
    end

    @productos = []

    if @pedidos.present?
      @pedidos.each do |ped|
        ped.producto_pedido.each do |pp|
          producto = Producto.find(pp.producto_id)
          item = {
            pedido: ped.numero,
            fecha: ped.fecha,
            cliente: ped.cliente_nombre,
            correo: ped.cliente_email,
            telefono: ped.cliente_telefono,
            categoria: producto.categoria,
            producto: pp.nombre,
            descripcion: producto.descripcion2,
            proveedor: producto.proveedor,
            precio: pp.precio,
            cantidad: pp.cantidad,
            unidad: pp.unidad,
            subtotal: pp.subtotal
          }
          @productos.push(item)
        end
      end
    end
    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="reporte_productos_pedidos.xlsx"' }
    end
  end

  def reporte_recomendados
    
    periodo = params[:periodo].to_i
    case periodo
    when 1 #Hoy
      fecha_ini = Date.today
      fecha_fin = Date.today + 1
    when 2 #Ayer
      fecha_ini = Date.today - 1
      fecha_fin = Date.today
    when 3 #Mes Actual
      fecha_ini = Date.today.beginning_of_month
      fecha_fin = Date.today.end_of_month
    when 4 #Mes Pasado
      fecha_ini = (Date.today-1.month).beginning_of_month
      fecha_fin = (Date.today-1.month).end_of_month
    when 5 #Custom
      fecha_ini = Date.strptime(params[:fecha_ini], '%d/%m/%y')
      fecha_fin = Date.strptime(params[:fecha_fin], '%d/%m/%y')
    end

    @usuario = ConfigUser.find_by(user_id: current_user.id)
    if fecha_ini.present? && fecha_fin.present?
      @pedidos = Pedido.where(id_embajador: @usuario.id).where('date(created_at) >= ? and date(created_at) <=?', fecha_ini, fecha_fin).order(id: :desc)
    else
      @pedidos = Pedido.where(id_embajador: @usuario.id).order(id: :desc)
    end
    
    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="reporte _recomendados.xlsx"' }
    end
  end

end
