module Verifactu
  module ConsultaFactu
    class PeriodoImputacion
      attr_reader :ejercicio, :periodo

      def initialize(ejercicio:, periodo:)
        raise ArgumentError, "Ejercicio is required" if ejercicio.nil?
        raise ArgumentError, "Periodo is required" if periodo.nil?

        raise ArgumentError, "Ejercicio must be a 4-digit string" unless ejercicio.is_a?(String) && ejercicio.match?(/^\d{4}$/)
        raise ArgumentError, "Periodo must be between #{Verifactu::Config::L2C.join(', ')}" unless Verifactu::Config::L2C.include?(periodo)
      
        @ejercicio = ejercicio
        @periodo = periodo
      end
    end
  end
end