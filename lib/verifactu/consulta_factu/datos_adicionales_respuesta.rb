module Verifactu
  module ConsultaFactu
    #
    # Representa <con:DatosAdicionalesRespuesta> del servicio de consulta.
    #
    # Los dos indicadores encarecen la respuesta de la AEAT, por eso son
    # opcionales y por defecto van a "N".
    #
    # MostrarSistemaInformatico debe ser "N" cuando la consulta la hace el
    # DESTINATARIO (sólo el obligado de emisión puede pedirlo).
    #
    class DatosAdicionalesRespuesta
      attr_reader :mostrar_nombre_razon_emisor, :mostrar_sistema_informatico

      def initialize(mostrar_nombre_razon_emisor: false, mostrar_sistema_informatico: false)
        @mostrar_nombre_razon_emisor = mostrar_nombre_razon_emisor
        @mostrar_sistema_informatico = mostrar_sistema_informatico
      end
    end
  end
end
