module Verifactu
  module InvoiceRegistration
    # Represents <sum1:DetalleDesglose>
    class BreakdownDetail

      private_class_method :new

      attr_reader :impuesto,
                  :regime_key,
                  :operation_qualification,
                  :operacion_exenta,
                  :tax_rate,
                  :taxable_base_o_importe_no_sujeto,
                  :taxable_base_a_coste,
                  :charged_tax,
                  :tipo_recargo_equivalencia,
                  :cuota_recargo_equivalencia

      #
      # Creates an instance of DetalleDesglose for a non-exempt tax operation
      #
      # @param [String] impuesto Tax code (L1)
      # @param [String] clave_regimen Regime key (L8A or L8B)
      # @param [String] calificacion_operacion Operation qualification (L9)
      # @param [String] tipo_impositivo Tax rate (L16)
      # @param [String] base_imponible_o_importe_no_sujeto Taxable base or non-subject amount
      # @param [String] base_imponible_a_coste Cost-based taxable base (optional, only if clave_regimen is '06' or impuesto is '02' or '05')
      # @param [String] cuota_repercutida Charged tax (optional, must not be present if calificacion_operacion is 'N1' or 'N2')
      # @param [String] tipo_recargo_equivalencia Equivalence surcharge type (optional, must not be present if calificacion_operacion is 'N1' or 'N2')
      # @param [String] cuota_recargo_equivalencia Equivalence surcharge amount (optional, must not be present if calificacion_operacion is 'N1' or 'N2')
      # @return [DetalleDesglose] Instance of DetalleDesglose
      #
      def self.create_operacion(impuesto:, clave_regimen:, calificacion_operacion: , tipo_impositivo: ,
                                base_imponible_o_importe_no_sujeto:, base_imponible_a_coste: nil, cuota_repercutida: nil,
                                tipo_recargo_equivalencia: nil, cuota_recargo_equivalencia: nil)

        # Validate operation
        validar_operacion(impuesto: impuesto, clave_regimen: clave_regimen,
                          calificacion_operacion: calificacion_operacion,
                          tipo_impositivo: tipo_impositivo, tipo_recargo_equivalencia: tipo_recargo_equivalencia,
                          cuota_recargo_equivalencia: cuota_recargo_equivalencia, cuota_repercutida: cuota_repercutida)

        # Validate operation qualification
        validar_calificacion_operacion(calificacion_operacion: calificacion_operacion,
                                      tipo_impositivo: tipo_impositivo,
                                      cuota_repercutida: cuota_repercutida)

        # Validate regime key
        validar_clave_regimen(clave_regimen: clave_regimen,
                              impuesto: impuesto,
                              tipo_impositivo: tipo_impositivo,
                              calificacion_operacion: calificacion_operacion,
                              base_imponible_a_coste: base_imponible_a_coste)

        detalle = new(impuesto: impuesto,
                      clave_regimen: clave_regimen,
                      calificacion_operacion: calificacion_operacion,
                      base_imponible_o_importe_no_sujeto: base_imponible_o_importe_no_sujeto,
                      base_imponible_a_coste: base_imponible_a_coste)

        detalle.instance_variable_set(:@tax_rate, tipo_impositivo)
        detalle.instance_variable_set(:@charged_tax, cuota_repercutida)
        detalle.instance_variable_set(:@tipo_recargo_equivalencia, tipo_recargo_equivalencia)
        detalle.instance_variable_set(:@cuota_recargo_equivalencia, cuota_recargo_equivalencia)

        return detalle

      end

      #
      # Creates an instance of DetalleDesglose for a tax-exempt operation
      # @param [String] impuesto Tax code (L1)
      # @param [String] clave_regimen Regime key (L8A or L8B)
      # @param [String] calificacion_operacion Operation qualification (L9)
      # @param [String] operacion_exenta Exemption reason (L10A or L10B)
      # @param [String] base_imponible_o_importe_no_sujeto Taxable base or non-subject amount
      # @param [String] base_imponible_a_coste Cost-based taxable base (optional, only if clave_regimen is '06' or impuesto is '02' or '05')
      # @return [DetalleDesglose] Instance of DetalleDesglose
      #
      def self.create_operacion_exenta(impuesto:, clave_regimen:, calificacion_operacion: , operacion_exenta:,
                                      base_imponible_o_importe_no_sujeto:, base_imponible_a_coste:)

        raise Verifactu::VerifactuError, "DetalleDesglose - operacion_exenta is required" if operacion_exenta.nil?

        # Validate exempt operation
        validar_operacion_exenta(impuesto: impuesto,
                                operacion_exenta: operacion_exenta)

        # Validate regime key
        validar_clave_regimen(clave_regimen: clave_regimen,
                              impuesto: impuesto,
                              operacion_exenta: operacion_exenta,
                              calificacion_operacion: calificacion_operacion,
                              base_imponible_a_coste: base_imponible_a_coste)

        detalle = new(impuesto: impuesto,
                      clave_regimen: clave_regimen,
                      calificacion_operacion: calificacion_operacion,
                      base_imponible_o_importe_no_sujeto: base_imponible_o_importe_no_sujeto,
                      base_imponible_a_coste: base_imponible_a_coste)

        detalle.instance_variable_set(:@operacion_exenta, operacion_exenta)

        return detalle

      end

      # Validation of charged tax that must be done except if RectificationType = "I" or InvoiceType "R2", "R3"
      def validate_charged_tax

        if @charged_tax.to_f * @taxable_base_o_importe_no_sujeto.to_f < 0
          return false
        end

        resultado = @taxable_base_o_importe_no_sujeto.to_f * @tax_rate.to_f / 100.0
        # Tolerance of +/- 10 euros
        ((@charged_tax.to_f - resultado).abs <= 10.0)
      end

      private

      #
      # TODO Split into two constructors, one for operations and one for exempt operations
      #
      def initialize(impuesto:, clave_regimen:, calificacion_operacion:,
                    base_imponible_o_importe_no_sujeto:, base_imponible_a_coste:)

        # Validate tax
        raise Verifactu::VerifactuError, "DetalleDesglose - impuesto is required" unless impuesto
        unless Verifactu::Config::L1.include?(impuesto)
          raise Verifactu::VerifactuError, "DetalleDesglose - impuesto must be one of #{Verifactu::Config::L1.join(', ')}"
        end

        # Validate regime key
        raise Verifactu::VerifactuError, "DetalleDesglose - calificacion_operacion is required" if calificacion_operacion.nil?
        unless calificacion_operacion.nil? || Verifactu::Config::L9.include?(calificacion_operacion)
          raise Verifactu::VerifactuError, "DetalleDesglose - calificacion_operacion must be #{Verifactu::Config::L9.join(', ')}"
        end

        # Validate taxable base or non-subject amount
        unless base_imponible_o_importe_no_sujeto
          raise Verifactu::VerifactuError, "DetalleDesglose - base_imponible_o_importe_no_sujeto is required"
        end
        unless Verifactu::Helper::Validador.validar_digito(base_imponible_o_importe_no_sujeto, digitos: 12)
          raise Verifactu::VerifactuError, "DetalleDesglose - base_imponible_o_importe_no_sujeto must be a number with maximum "\
                              "12 digits before the decimal and 2 decimals"
        end

        # Validate cost-based taxable base if present
        if base_imponible_a_coste
          unless clave_regimen == "06" || impuesto == "02" || impuesto == "05"
              raise Verifactu::VerifactuError, "DetalleDesglose - BaseImponibleACoste can only be filled if "\
                                  "ClaveRegimen is '06' or Impuesto is '02' (IPSI) or '05' (Others)"
          end
          unless Verifactu::Helper::Validador.validar_digito(base_imponible_a_coste, digitos: 12)
            raise Verifactu::VerifactuError, "DetalleDesglose - BaseImponibleACoste must be a number with maximum 12 digits "\
                                "before the decimal and 2 decimals"
          end
        end

        @impuesto = impuesto
        @regime_key = clave_regimen
        @operation_qualification = calificacion_operacion
        @taxable_base_o_importe_no_sujeto = base_imponible_o_importe_no_sujeto
        @taxable_base_a_coste = base_imponible_a_coste
      end

      #
      # Validate the operation
      #
      def self.validar_operacion(impuesto:, clave_regimen:, calificacion_operacion: , tipo_impositivo:, tipo_recargo_equivalencia:, cuota_recargo_equivalencia:, cuota_repercutida:)

        # Verify that tipo_impositivo is valid
        unless Verifactu::Helper::Validador.validar_digito(tipo_impositivo, digitos: 3)
          raise Verifactu::VerifactuError, "DetalleDesglose - tipo_impositivo must be less than 999.99"
        end

        if impuesto == "01" # IVA
          unless Verifactu::Config::L8A.include?(clave_regimen)
            raise Verifactu::VerifactuError, "DetalleDesglose - IVA - clave_regimen must be #{Verifactu::Config::L8A.join(', ')}"
          end
          if calificacion_operacion == "S1"
            unless Verifactu::Config::TIPO_IMPOSITIVO.include?(tipo_impositivo)
              raise Verifactu::VerifactuError, "DetalleDesglose - IVA - S1 - tipo_impositivo must be a valid percentage "\
                                  "#{Verifactu::Config::TIPO_IMPOSITIVO.join(', ')}"
            end
            # Validate equivalence surcharge
            if tipo_recargo_equivalencia
              unless Verifactu::Config::TIPO_RECARGO_EQUIVALENCIA.include?(tipo_recargo_equivalencia)
                raise Verifactu::VerifactuError, "DetalleDesglose - IVA - S1 - tipo_recargo_equivalencia must be one of "\
                                    "#{Verifactu::Config::TIPO_RECARGO_EQUIVALENCIA.join(', ')}"
              end
              # Validation of tax rate by date is performed in the invoice validator
              unless tipo_recargo_equivalencia == "0"
                self.validar_tipo_recargo_equivalencia(tipo_recargo_equivalencia: tipo_recargo_equivalencia,
                                                      tipo_impositivo: tipo_impositivo)
              end
            end
          elsif calificacion_operacion == "N1" || calificacion_operacion == "N2"
            unless tipo_impositivo.nil?
              raise Verifactu::VerifactuError, "DetalleDesglose - IVA - N1|N2 - tipo_impositivo must be nil"
            end
            unless cuota_repercutida.nil?
              raise Verifactu::VerifactuError, "DetalleDesglose - IVA - N1|N2 - cuota_repercutida must be nil"
            end
            unless tipo_recargo_equivalencia.nil?
              raise Verifactu::VerifactuError, "DetalleDesglose - IVA - N1|N2 - tipo_recargo_equivalencia must be nil"
            end
            unless cuota_recargo_equivalencia.nil?
              raise Verifactu::VerifactuError, "DetalleDesglose - IVA - N1|N2 - cuota_recargo_equivalencia must be nil"
            end
          end
        elsif impuesto == "03" # IGIC
          unless Verifactu::Config::L8B.include?(clave_regimen)
            raise Verifactu::VerifactuError, "DetalleDesglose - IGIC - clave_regimen must be #{Verifactu::Config::L8B.join(', ')}"
          end
        end

      end

      def self.validar_operacion_exenta(impuesto:, operacion_exenta:)
        if impuesto == "01" # IVA
          unless Verifactu::Config::L10.include?(operacion_exenta)
            raise Verifactu::VerifactuError, "DetalleDesglose - operacion_exenta must be #{Verifactu::Config::L10.join(', ')}"
          end
        elsif impuesto == "03" # IGIC
          unless Verifactu::Config::L10B.include?(operacion_exenta)
            raise Verifactu::VerifactuError, "DetalleDesglose - operacion_exenta must be #{Verifactu::Config::L10B.join(', ')}"
          end
        end
      end

      # Validate based on operation qualification
      def self.validar_calificacion_operacion(calificacion_operacion:, tipo_impositivo:, cuota_repercutida:)
        if calificacion_operacion == "S2"
          # Validation of tipo_factura is performed in the invoice validator
          unless tipo_impositivo == "0"
            raise Verifactu::VerifactuError, "DetalleDesglose - calificacionOperacion S2 - tipo_impositivo must be 0"
          end
          unless cuota_repercutida == "0"
            raise Verifactu::VerifactuError, "DetalleDesglose - calificacionOperacion S2 - cuota_repercutida must be 0"
          end
        elsif calificacion_operacion == "S1"
          unless tipo_impositivo
            raise Verifactu::VerifactuError, "DetalleDesglose - calificacionOperacion S1 - tipo_impositivo is required"
          end
          # Validation of cuota_repercutida is executed in the invoice validator
        end
      end


      # Validate based on regime key
      def self.validar_clave_regimen(clave_regimen:, impuesto:, tipo_impositivo: nil, operacion_exenta: nil, calificacion_operacion:, base_imponible_a_coste:)
        # Additional validations for regime key
        case clave_regimen
        when "02" # Export
          if impuesto == "01" || impuesto == "03" # IVA or IGIC
            unless operacion_exenta
              raise Verifactu::VerifactuError, "DetalleDesglose - claveRegimen 02 - OperacionExenta is required"
            end
          end
        when "03" # REBU
          if impuesto == "01" || impuesto == "03" # IVA or IGIC
            unless calificacion_operacion.nil? || calificacion_operacion == "S1"
              # Operation qualification must be S1 or nil
              raise Verifactu::VerifactuError, "DetalleDesglose - claveRegimen 03 - CalificacionOperacion must be S1 or nil"
            end
          end
        when "04" # Investment gold operations
          if impuesto == "01" || impuesto == "03" # IVA or IGIC
            unless calificacion_operacion.nil? || calificacion_operacion == "S2"
              raise Verifactu::VerifactuError, "DetalleDesglose - claveRegimen 04 - CalificacionOperacion must be S2 or nil"
            end
          end
        when "06" # Advanced level entity group
          if impuesto == "01" || impuesto == "03" # IVA or IGIC
            if base_imponible_a_coste.nil?
              raise Verifactu::VerifactuError, "DetalleDesglose - claveRegimen 06 - BaseImponibleACoste must not be nil"
            end
            # Validation of tipoFactura is performed in the invoice validator
          end
        when "07" # Cash accounting.
          if impuesto == "01" || impuesto == "03" # IVA or IGIC
            if calificacion_operacion
              invalid_calificaciones = ["S2", "N1", "N2"]
              if invalid_calificaciones.include?(calificacion_operacion)
                raise Verifactu::VerifactuError, "DetalleDesglose - claveRegimen 07 - CalificacionOperacion cannot be "\
                                    "#{invalid_calificaciones.join(', ')}"
              end
            elsif operacion_exenta
              invalid_operaciones_exentas = ["E2", "E3", "E4", "E5"]
              if invalid_operaciones_exentas.include?(operacion_exenta)
                raise Verifactu::VerifactuError, "DetalleDesglose - claveRegimen 07 - OperacionExenta cannot be "\
                                    "#{invalid_operaciones_exentas.join(', ')}"
              end
            end
          end
        when "08"
          if impuesto == "01" || impuesto == "03" # IVA or IGIC
            valid_calificaciones = ["N2"]
            unless valid_calificaciones.include?(calificacion_operacion)
              raise Verifactu::VerifactuError, "DetalleDesglose - claveRegimen 08 - CalificacionOperacion must be "\
                                  "#{valid_calificaciones.join(', ')}"
            end
          end
        when "10" # Collection on behalf of third parties
          if impuesto == "01" || impuesto == "03" # IVA or IGIC
            valid_calificaciones = ["N1"]
            unless valid_calificaciones.include?(calificacion_operacion)
              raise Verifactu::VerifactuError, "DetalleDesglose - claveRegimen 10 - CalificacionOperacion must be "\
                                  "#{valid_calificaciones.join(', ')}"
            end
            # Validation of tipoFactura is performed in the invoice validator
            # Validation of recipient is performed in the invoice validator
          end
        when "11" # Business premises lease
          if impuesto == "01" # IVA
            valid_tipo_impositivo = ["21"]
            unless valid_tipo_impositivo.include?(tipo_impositivo)
              raise Verifactu::VerifactuError, "DetalleDesglose - claveRegimen 11 - IVA - TipoImpositivo must be "\
                                  "#{valid_tipo_impositivo.join(', ')}"
            end
          end
        # when "14" # Pending VAT for public administrations.
          # Validation of fechaOperacion is performed in the invoice validator
          # Validation of recipient is performed in the invoice validator
          # Validation of tipoFactura is performed in the invoice validator
        end
      end

      # Validation of equivalence surcharge type - Assumes tax is IVA and operation qualification is S1
      def self.validar_tipo_recargo_equivalencia(tipo_recargo_equivalencia:, tipo_impositivo:)
        case tipo_impositivo
        when "21"
          valid_impuestos = ["5.2", "1.75"]
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise Verifactu::VerifactuError, "DetalleDesglose - equivalence surcharge must be #{valid_impuestos.join(', ')}"
          end
        when "10"
          valid_impuestos = ["1.4"]
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise Verifactu::VerifactuError, "DetalleDesglose - equivalence surcharge must be #{valid_impuestos.join(', ')}"
          end
        when "7.5"
          valid_impuestos = ["1"]
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise Verifactu::VerifactuError, "DetalleDesglose - equivalence surcharge must be #{valid_impuestos.join(', ')}"
          end
        when "5"
          valid_impuestos = ["0.5", "0.62"]
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise Verifactu::VerifactuError, "DetalleDesglose - equivalence surcharge must be #{valid_impuestos.join(', ')}"
          end
        when "4"
          valid_impuestos = ["0.5"]
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise Verifactu::VerifactuError, "DetalleDesglose - equivalence surcharge must be #{valid_impuestos.join(', ')}"
          end
        when "2"
          valid_impuestos = ["0.26"]
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise Verifactu::VerifactuError, "DetalleDesglose - equivalence surcharge must be #{valid_impuestos.join(', ')}"
          end
        when "0"
          valid_impuestos = Verifactu::Config::TIPO_RECARGO_EQUIVALENCIA
          unless valid_impuestos.include?(tipo_recargo_equivalencia)
            raise Verifactu::VerifactuError, "DetalleDesglose - equivalence surcharge must be #{valid_impuestos.join(', ')}"
          end
        end
      end


    end
  end
end
