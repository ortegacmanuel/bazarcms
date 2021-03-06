xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title BZ_param("Titular")+": Ofertas del Bazar Garum"
    xml.description BZ_param("Subtitular")
    xml.link Cluster.find(BZ_param("BazarId")).url

    for oferta in @ofertas
      xml.item do
        next if oferta.titulo.nil?
        next if oferta.bazar_id.nil? 
        next if oferta.id.nil? 
        next if oferta.texto.nil? 
        
        xml.title oferta.titulo
        xml.description oferta.texto+"<br/><br/>"+"Más Información de esta oferta/demanda:\n\n<a href='#{Cluster.find(BZ_param("BazarId")).url}/home/fichaempresa/#{oferta.bazar_id}/#{oferta.empresa_id}/?go=oferta&oferta=#{oferta.id}'>#{oferta.titulo}</a><br/><a href='#{Cluster.find(BZ_param("BazarId")).url}/home/fichaempresa/#{oferta.bazar_id}/#{oferta.empresa_id}'>Ver la ficha de la empresa</a>"
        xml.pubDate oferta.fecha.to_s(:rfc822)
        xml.link Cluster.find(BZ_param("BazarId")).url+"/home/fichaempresa/#{oferta.bazar_id}/#{oferta.empresa_id}/?go=oferta&oferta=#{oferta.id}"
        xml.guid Cluster.find(BZ_param("BazarId")).url+"/home/fichaempresa/#{oferta.bazar_id}/#{oferta.empresa_id}/?go=oferta&oferta=#{oferta.id}"
      end
    end
  end
end