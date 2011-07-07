module Bazarcms
  
  unloadable

  class Rating < ActiveRecord::Base
    set_table_name "ratings"
    
    def calculo (bazar, empresa)
        
      total_rating_global = 0 
      total_global = 0
    
      total_rating_cliente = 0
      total_val_cliente = 0 
    
      total_rating_proveedor = 0
      total_val_proveedor = 0 
    
      rats = Rating.where("(ori_bazar_id = ? and ori_empresa_id = ?) or (des_bazar_id = ? and des_empresa_id = ?)", bazar, empresa, bazar, empresa)

      hay = false 
  
      for rat in rats 
      
        # primero determinamos si la empresa es la que ha originado el rating 
        
        totrc = totrp = 0
        totc = totp = 0
        
        if rat.ori_bazar_id = bazar and rat.ori_empresa_id = empresa           
          ori = true
        else 
          ori = false
        end 
      
        if ori

          if rat.role == 'C'

            if (rat.des_cliente_plazos > 0)  
              totrc += rat.des_cliente_plazos
              totc += 1
            end

            if (rat.des_cliente_comunicacion > 0)  
              totrc += rat.des_cliente_comunicacion
              totc += 1
            end

          else 

            if (rat.des_proveedor_expectativas > 0)  
              totrp += rat.des_proveedor_expectativas
              totp += 1
            end

            if (rat.des_proveedor_plazos > 0)  
              totrp += rat.des_proveedor_plazos
              totp += 1
            end

            if (rat.des_proveedor_comunicacion > 0)  
              totrp += rat.des_proveedor_comunicacion
              totp += 1
            end

          end
            

        end


        if (totc > 0)
          total_rating_cliente += (totrc/totc)
          total_val_cliente += 1
        end  

        if (totp > 0)
          total_rating_proveedor += (totrp/totp)
          total_val_proveedor += 1
        end  

        else 
          
        end 

        #actualizamos los datos de la empresa 
      
        empresa = Empresa.find_by_id(empresa)

        empresa.rating_cliente = total_rating_cliente/total_val_cliente
        empresa.rating_total_cliente = total_val_cliente
        empresa.rating_total_proveedor = total_val_proveedor

        empresa.save
      
      end 
    
    end 

  end

end