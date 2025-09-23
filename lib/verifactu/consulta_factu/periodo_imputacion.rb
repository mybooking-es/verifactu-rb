module Verifactu
  module ConsultaFactu
    class PeriodoImputacion
      attr_reader :ejercicio, :periodo

      def initialize(ejercicio:, periodo:)
        raise Verifactu::VerifactuError, "Ejercicio is required" if ejercicio.nil?
        raise Verifactu::VerifactuError, "Periodo is required" if periodo.nil?

        raise Verifactu::VerifactuError, "Ejercicio must be a 4-digit string" unless Verifactu::Helper::Validador.cadena_valida?(ejercicio) && ejercicio.match?(/^\d{4}$/)
        raise Verifactu::VerifactuError, "Periodo must be between #{Verifactu::Config::L2C.join(', ')}" unless Verifactu::Config::L2C.include?(periodo)

        @ejercicio = ejercicio
        @periodo = periodo
      end
    end
  end
end
