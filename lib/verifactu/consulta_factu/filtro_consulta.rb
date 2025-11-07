module Verifactu
  module ConsultaFactu
    class FiltroConsulta
      attr_reader :periodo_imputacion, :series_number, :contraparte, :issue_date, :information_system, :external_ref, :clave_paginacion

      def initialize(periodo_imputacion:,
        series_number: nil,
        contraparte: nil,
        issue_date: nil,
        information_system: nil,
        external_ref: nil,
        clave_paginacion: nil)

        raise Verifactu::VerifactuError, "Periodo de imputación is required" if periodo_imputacion.nil?

        raise Verifactu::VerifactuError, "Periodo de imputación must be an instance of PeriodoImputacion" unless periodo_imputacion.is_a?(PeriodoImputacion)
        raise Verifactu::VerifactuError, "Contraparte must be an instance of LegalEntity" if contraparte && !contraparte.is_a?(Verifactu::InvoiceRegistration::LegalEntity)
        raise Verifactu::VerifactuError, "Fecha de expedición de factura must be an instance of FechaExpedicionFactura (#{issue_date})" if issue_date && !issue_date.is_a?(Verifactu::ConsultaFactu::FechaExpedicionFactura)
        raise Verifactu::VerifactuError, "Sistema informático must be an instance of InformationSystem" if information_system && !information_system.is_a?(Verifactu::InvoiceRegistration::InformationSystem)
        raise Verifactu::VerifactuError, "Clave de paginación must be an instance of ClavePaginacion" if clave_paginacion && !clave_paginacion.is_a?(ClavePaginacion)

        @periodo_imputacion = periodo_imputacion
        @series_number = series_number
        @contraparte = contraparte
        @issue_date = issue_date
        @information_system = information_system
        @external_ref = external_ref
        @clave_paginacion = clave_paginacion
      end
    end
  end
end
