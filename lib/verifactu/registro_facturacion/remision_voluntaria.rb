module Verifactu
  module RegistroFacturacion
    # Representa <sum1:RemisionVoluntaria>
    class RemisionVoluntaria
      attr_reader :fecha_fin_verifactu, :incidencia

      def initialize(fecha_fin_verifactu: nil, incidencia:  nil)
        Helper::Validador.validar_fecha_fin_de_ano(fecha_fin_verifactu) if fecha_fin_verifactu
        raise ArgumentError, "incidencia debe estar entre los valores #{Verifactu::Config::L4.join(', ')} o ser nil" if incidencia && !Verifactu::Config::L4.include?(incidencia)
        @fecha_fin_verifactu = fecha_fin_verifactu
        @incidencia = incidencia
      end
    end
  end
end
