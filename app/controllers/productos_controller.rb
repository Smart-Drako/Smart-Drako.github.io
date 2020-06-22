class ProductosController < ApplicationController
  before_action :set_producto, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:tienda]

  # GET /productos
  # GET /productos.json
  def index
    @productos = Producto.where(user_id: current_user.id)
  end

  def importar
    Producto.importar(params[:file], current_user)
    redirect_to productos_path and return
  end

  # Se exporta con Axlsx, template view en: admin/empresas_productos/exportar.xlsx.axlsx
  def exportar
    @productos = Producto.where(user_id: current_user.id)
    respond_to do |format|
      format.html
      format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="listado_productos.xlsx"' }
    end
  end

  # GET /productos/1
  # GET /productos/1.json
  def show
  end

  # GET /productos/new
  def new
    @producto = Producto.new
  end

  # GET /productos/1/edit
  def edit
  end

  def tienda
    id = params[:id].to_i
    slug = params[:id]
    #Buscar por slug unico
    if id == 0
      @negocio = ConfigUser.find_by(slug: slug)
      @productos = Producto.where(user_id: @negocio.user_id).order('categoria, descripcion')
    else
      @negocio = ConfigUser.find(id)
      @productos = Producto.where(user_id: @negocio.user_id).order('categoria, descripcion')
    end

    @prods = Array.new
    
    @categorias = @productos.pluck(:categoria).uniq.compact
    @higiene = @negocio.condiciones_higiene.split(/\s*,\s*/)
    @horario = @negocio.horario.split(/\s*,\s*/)
    
    @categorias.each_with_index do |cat, index|
      productos = @productos.where(user_id: @negocio.user_id, categoria: cat)
      item = {
        id: cat,
        nombre: cat,
        productos: productos
      }
      @prods.push(item)
    end
    #Busqueda de productos
    # if params[:buscar].present?
    #   descr = Producto.arel_table[:descripcion]
    #   query = params[:buscar]
    #   @productos = Producto.where(descr.matches("%#{query}%"))
    # end
  end

  # POST /productos
  # POST /productos.json
  def create
    @producto = Producto.new(producto_params)
    @producto.user_id = current_user.id
    respond_to do |format|
      if @producto.save
        format.html { redirect_to productos_path, notice: 'Producto was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /productos/1
  # PATCH/PUT /productos/1.json
  def update
    respond_to do |format|
      if @producto.update(producto_params)
        format.html { redirect_to productos_path, notice: 'Producto was successfully updated.' }
        format.json { render :show, status: :ok, location: @producto }
      else
        format.html { render :edit }
        format.json { render json: @producto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /productos/1
  # DELETE /productos/1.json
  def destroy
    @producto.destroy
    respond_to do |format|
      format.html { redirect_to productos_url, notice: 'Producto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_producto
      @producto = Producto.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def producto_params
      params.require(:producto).permit(:user_id, :codigo, :inventario, :categoria, :descripcion, :unidad, :precio, :impuesto, :foto)
    end
end
