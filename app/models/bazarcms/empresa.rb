module Bazarcms
  
  unloadable
  
  class Empresa < ActiveRecord::Base
    set_table_name "empresas"
    has_many :ubicaciones
    has_many :empresasconsultas
    has_many :empresasperfiles
    
    acts_as_taggable
    acts_as_taggable_on :actividades, :intereses
    
    has_attached_file :logo, :styles => {
          :thumb=> "100x50>",
          :small  => "150x150>" },
          :path => ":rails_root/public/:class/:attachment/:id/:style_:basename.:extension",
          :url => "/:class/:attachment/:id/:style_:basename.:extension",
          :default_url => "/images/sinlogo.png"
    
    
    # TODO deberíamos incluir nombre de la ciudad y el pais en la indexación
    
    
    scope :ultimascreadas, order("empresas.created_at DESC").limit(5)
    scope :ultimasactualizadas, order("empresas.updated_at DESC").limit(5)
        
    acts_as_ferret :fields => [ :nombre, :desc, :actividades, :intereses, :sitios, :sectores ]

    has_friendly_id :nombre, :use_slug => true, :approximate_ascii => true
    
    def sitios
      tmp = []
      for ubi in ubicaciones
        tmp << ubi.desc
        tmp << ubi.ciudad.descripcion
        tmp << ubi.ciudad.pais.descripcion
      end
      return tmp
    end
    
    def self.Monedas
        {
         "Euro" => "0", 
         "USD"  => "1"       
         }
    end
    
    def self.Monedastexto(ind)
      self.Monedas.each do |k,v| 
        if v.to_i == ind 
          return k
        end
      end
      return "No definido"
    end 
    
    def sectores
      tmp = []
      for per in empresasperfiles

        tmp << per.codigo
        
        sec = Bazarcms::Perfil.find_by_codigo(per.codigo)
        tmp << sec.desc
        tmp << sec.ayuda

      end
      logger.debug "sectores añadidos a la busqueda: "+tmp.inspect
      return tmp
    end
    
    def interesantes
      puts "Empresas interesantes para: #{self.id} #{self.nombre}"
      
      missectores = Bazarcms::Empresasperfil.select("distinct codigo").where("empresa_id = ?", self.id).order("codigo")

      sectores = []

      for sector in missectores 
        sectores << sector.codigo
      end

      puts sectores.inspect
      
      empresas = Bazarcms::Empresasperfil.select("distinct empresa_id").where("empresa_id = ? and codigo in (?)", self.id, sectores).order("empresa_id")
      
      
      

    end
    
  end
end