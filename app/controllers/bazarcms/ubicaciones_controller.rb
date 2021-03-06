module Bazarcms

  class UbicacionesController < ApplicationController

  unloadable 
  layout "bazar"
  
  def index
    @ubicaciones = Ubicacion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ubicaciones }
    end
  end

    def show
      @ubicacion = Ubicacion.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @ubicacion }
      end
    end

    def new
      @ubicacion = Ubicacion.new
      @ubicacion.empresa_id = params[:empresa]
      respond_to do |format|
        format.html { render :layout => false }
        format.xml  { render :xml => @ubicacion }
      end
    end

    def edit
      @ubicacion = Ubicacion.find(params[:id])
      respond_to do |format|
        format.html { render :layout => false }
        format.xml  { render :xml => @ubicacion }
      end
      
    end

    def create
      @ubicacion = Ubicacion.new(params[:bazarcms_ubicacion])

      puts "empresa id: "+params.inspect
      puts "ubicacion : "+@ubicacion.inspect

      respond_to do |format|
        if @ubicacion.save
          
          @empresa = Bazarcms::Empresa.find_by_id(current_user.id)          
          
          if !@ubicacion.ciudad.nil?
              Actividad.graba("Nueva ubicación: '#{@ubicacion.desc}' <a href='#{ciudades_path+'/'+@ubicacion.ciudad.friendly_id}'>#{@ubicacion.ciudad.descripcion}</a> - <a href='#{paises_path+'/'+@ubicacion.ciudad.pais.friendly_id}'>#{@ubicacion.ciudad.pais.descripcion}</a>",
                  "USER", BZ_param("BazarId"), current_user.id, @empresa.nombre)

        	else
            Actividad.graba("Nueva ubicación: #{@ubicacion.desc}", "USER", BZ_param("BazarId"), current_user.id, @empresa.nombre)
        	end
          
          # invalidamos los caches para que aparezca la oferta inmediatamente en la home page

          expire_fragment "bazar_actividades_dashboard"
          
          
          # actualizamos cuando se ha actualizado la empresa para que además se reindexe
          
          @empresa.updated_at = DateTime.now 
          @empresa.save
          
          format.html { redirect_to(edit_bazarcms_empresa_url(current_user.id)+'#tabs-3') }
          format.xml  { render :xml => @ubicacion, :status => :created, :location => @ubicacion }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @ubicacion.errors, :status => :unprocessable_entity }
        end
      end
    end

    def update
      @ubicacion = Ubicacion.find(params[:id])
      
      respond_to do |format|
        if @ubicacion.update_attributes(params[:bazarcms_ubicacion])
          
          @empresa = Bazarcms::Empresa.find_by_id(current_user.id)

          if !@ubicacion.ciudad.nil?
              Actividad.graba("Actualizada ubicación: '#{@ubicacion.desc}' <a href='#{ciudades_path+'/'+@ubicacion.ciudad.friendly_id}'>#{@ubicacion.ciudad.descripcion}</a> - <a href='#{paises_path+'/'+@ubicacion.ciudad.pais.friendly_id}'>#{@ubicacion.ciudad.pais.descripcion}</a>",
                  "USER", BZ_param("BazarId"), current_user.id, @empresa.nombre)

        	else
            Actividad.graba("Actualizada ubicación: #{@ubicacion.desc}", "USER", BZ_param("BazarId"), current_user.id, @empresa.nombre)
        	end
          
          # invalidamos los caches para que aparezca la oferta inmediatamente en la home page

          expire_fragment "bazar_actividades_dashboard"
          
          # actualizamos cuando se ha actualizado la empresa para que además se reindexe
          
          @empresa.updated_at = DateTime.now 
          @empresa.save
          
          format.html { redirect_to(edit_bazarcms_empresa_url(current_user.id)+'#tabs-3') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @ubicacion.errors, :status => :unprocessable_entity }
        end
      end
    end

    # TODO proteger todos los destroy para que solo puedan ser ejecutados por un usuarios 
    # en este caso cuestionarse si debe existir incluso la opción de borrado 
    
    def destroy
      @ubicacion = Ubicacion.find(params[:id])
      @ubicacion.destroy

      respond_to do |format|
        format.html { redirect_to(edit_bazarcms_empresa_url(current_user.id)+'#tabs-3') }
        format.xml  { head :ok }
      end
    end
  end

end