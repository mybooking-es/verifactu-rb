module Verifactu
  module ConsultaFactu
    class Consulta
      attr_reader :cabecera, :filtro_consulta, :datos_adicionales_respuesta

      def initialize(cabecera, filtro_consulta, datos_adicionales_respuesta = nil)
        raise Verifactu::VerifactuError, "Cabecera is required" if cabecera.nil?
        raise Verifactu::VerifactuError, "Filtro de consulta is required" if filtro_consulta.nil?
        raise Verifactu::VerifactuError, "Datos adicionales de respuesta is required" if datos_adicionales_respuesta.nil?

        raise Verifactu::VerifactuError, "Cabecera must be an instance of Verifactu::Cabecera" unless cabecera.is_a?(Verifactu::Cabecera)
        raise Verifactu::VerifactuError, "Filtro de consulta must be an instance of Verifactu::ConsultaFactu::FiltroConsulta" unless filtro_consulta.is_a?(Verifactu::ConsultaFactu::FiltroConsulta)
        raise Verifactu::VerifactuError, "Datos adicionales de respuesta must be an instance of Verifactu::ConsultaFactu::DatosAdicionalesRespuesta" unless datos_adicionales_respuesta.is_a?(Verifactu::ConsultaFactu::DatosAdicionalesRespuesta)
        @cabecera = cabecera
        @filtro_consulta = filtro_consulta
        @datos_adicionales_respuesta = datos_adicionales_respuesta
      end
    end
  end
end
