module Verifactu
  module ConsultaFactu
    class FiltroConsulta
      attr_reader :periodo_imputacion, :num_serie_factura, :contraparte, :fecha_expedicion_factura, :sistema_informatico, :ref_externa, :clave_paginacion

      def initialize(periodo_imputacion:,
        num_serie_factura: nil,
        contraparte: nil,
        fecha_expedicion_factura: nil,
        sistema_informatico: nil,
        ref_externa: nil,
        clave_paginacion: nil)

        raise Verifactu::VerifactuError, "Periodo de imputación is required" if periodo_imputacion.nil?

        raise Verifactu::VerifactuError, "Periodo de imputación must be an instance of PeriodoImputacion" unless periodo_imputacion.is_a?(PeriodoImputacion)
        raise Verifactu::VerifactuError, "Contraparte must be an instance of PersonaFisicaJuridica" if contraparte && !contraparte.is_a?(PersonaFisicaJuridica)
        raise Verifactu::VerifactuError, "Fecha de expedición de factura must be an instance of FechaExpedicionFactura" if fecha_expedicion_factura && !fecha_expedicion_factura.is_a?(FechaExpedicionFactura)
        raise Verifactu::VerifactuError, "Sistema informático must be an instance of SistemaInformatico" if sistema_informatico && !sistema_informatico.is_a?(SistemaInformatico)
        raise Verifactu::VerifactuError, "Clave de paginación must be an instance of ClavePaginacion" if clave_paginacion && !clave_paginacion.is_a?(ClavePaginacion)

        @periodo_imputacion = periodo_imputacion
        @num_serie_factura = num_serie_factura
        @contraparte = contraparte
        @fecha_expedicion_factura = fecha_expedicion_factura
        @sistema_informatico = sistema_informatico
        @ref_externa = ref_externa
        @clave_paginacion = clave_paginacion
      end
    end
  end
end
