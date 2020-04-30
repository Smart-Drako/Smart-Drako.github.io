class ProductosController < ApplicationController
  before_action :set_producto, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:tienda]

  # GET /productos
  # GET /productos.json
  def index
    @productos = Producto.where(user_id: current_user.id)
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
    @prods = Array.new
    
    if params[:buscar].present?
      descr = Producto.arel_table[:descripcion]
      query = params[:buscar]
      @productos = Producto.where(descr.matches("%#{query}%"))
    else
      @productos = Producto.where(user_id: id)
    end
    @negocio = ConfigUser.find(id)
    @categorias = @productos.pluck(:categoria).uniq.compact
    
    @categorias.each_with_index do |cat, index|
      productos = @productos.where(user_id: id, categoria: cat)
      item = {
        id: cat,
        nombre: cat,
        productos: productos
      }
      @prods.push(item)
    end
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
      params.require(:producto).permit(:user_id, :codigo, :inventario, :categoria, :descripcion, :unidad, :precio, :impuesto)
    end
end
