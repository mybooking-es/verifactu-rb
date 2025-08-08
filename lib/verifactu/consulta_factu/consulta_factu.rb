module Verifactu
  module ConsultaFactu
    class Consulta
      attr_reader :cabecera, :filtro_consulta, :datos_adicionales_respuesta

      def initialize(cabecera, filtro_consulta, datos_adicionales_respuesta = nil)
        raise ArgumentError, "Cabecera is required" if cabecera.nil?
        raise ArgumentError, "Filtro de consulta is required" if filtro_consulta.nil?
        raise ArgumentError, "Datos adicionales de respuesta is required" if datos_adicionales_respuesta.nil?

        raise TypeError, "Cabecera must be an instance of Verifactu::Cabecera" unless cabecera.is_a?(Verifactu::Cabecera)
        raise TypeError, "Filtro de consulta must be an instance of Verifactu::ConsultaFactu::FiltroConsulta" unless filtro_consulta.is_a?(Verifactu::ConsultaFactu::FiltroConsulta)
        raise TypeError, "Datos adicionales de respuesta must be an instance of Verifactu::ConsultaFactu::DatosAdicionalesRespuesta" unless datos_adicionales_respuesta.is_a?(Verifactu::ConsultaFactu::DatosAdicionalesRespuesta)
        @cabecera = cabecera
        @filtro_consulta = filtro_consulta
        @datos_adicionales_respuesta = datos_adicionales_respuesta
      end
    end
  end
end