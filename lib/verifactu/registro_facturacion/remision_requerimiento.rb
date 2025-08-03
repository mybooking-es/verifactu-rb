module Verifactu
  module RegistroFacturacion
    # Representa <sum1:RemisionRequerimiento>
    class RemisionRequerimiento
      attr_reader :ref_requerimiento, :fin_requerimiento

      # @param [String] ref_requerimiento Sólo cuando el motivo de la remisión sea para dar respuesta
      #                   a un requerimiento de información previo efectuado por parte de la AEAT,
      #                   se deberá indicar aquí la referencia de dicho requerimiento,
      #                   lo que forma parte del detalle de las circunstancias de generación del registro de facturación.
      #                   Por lo tanto, NO deberá informarse este campo en el caso de una remisión voluntaria «VERI*FACTU».
      # @param [Any, nil] fin_requerimiento Indicador que especifica que se ha
      #                   finalizado la remisión de registros de facturación tras un requerimiento,
      #                   especialmente útil cuando se realice un envío o remisión múltiple
      #                   y se ha de dejar constancia de que se trata del último envío.
      #                   Si no se informa este campo se entenderá que tiene valor “N”.
      #                   Solo puede cumplimentarse si el campo ref_requerimiento viene informado.
      def initialize(ref_requerimiento:, fin_requerimiento:  "N")
        raise ArgumentError, 'ref_requerimiento is required' if ref_requerimiento.nil?
        raise ArgumentError, 'ref_requerimiento must be a String' unless ref_requerimiento.is_a?(String)
        raise ArgumentError, 'ref_requerimiento debe tener como maximo 18 caracteres' if ref_requerimiento.length > 18
        @ref_requerimiento = ref_requerimiento
        raise ArgumentError, 'fin_requerimiento must be a S or N' unless Verifactu::Config::L4.include?(fin_requerimiento)
        @fin_requerimiento = fin_requerimiento
      end
    end
  end
end
