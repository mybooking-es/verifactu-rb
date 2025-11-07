require 'bigdecimal'

module Verifactu
  module InvoiceRegistration
    # It represents a high invoice registration at Verifactu.
    # Do not create instances of this class directly, use HighRecordBuilder instead
    # Represents <sum:RegistroAlta>
    class HighRecord
      attr_reader :id_version,
                  :invoice_id,
                  :external_ref,
                  :issuer_name,
                  :rectification,
                  :previous_rejection,
                  :invoice_type,
                  :rectification_type,
                  :rectified_invoices,
                  :replaced_invoices,
                  :rectification_amount,
                  :operation_date,
                  :operation_description,
                  :simplified_invoice_art7273,
                  :invoice_without_recipient_id_art61d,
                  :macro_data,
                  :issued_by_third_party_or_recipient,
                  :third_party,
                  :recipients,
                  :coupon,
                  :breakdown,
                  :total_tax,
                  :total_amount,
                  :chaining,
                  :information_system,
                  :record_generation_datetime,
                  :num_registro_acuerdo_facturacion,
                  :information_system_agreement_id,
                  :fingerprint_type,
                  :fingerprint,
                  :signature

      def initialize(invoice_id:,
                    external_ref: nil,
                    issuer_name:,
                    rectification: nil,
                    previous_rejection: nil,
                    invoice_type:,
                    rectification_type: nil,
                    rectified_invoices: nil,
                    replaced_invoices: nil,
                    rectification_amount: nil,
                    operation_date: nil,
                    operation_description:,
                    simplified_invoice_art7273: nil,
                    invoice_without_recipient_id_art61d: nil,
                    macro_data: nil,
                    issued_by_third_party_or_recipient: nil,
                    third_party: nil,
                    recipients: nil,
                    coupon: nil,
                    breakdown:,
                    total_tax: nil,
                    total_amount:,
                    chaining: nil,
                    information_system:,
                    record_generation_datetime:,
                    num_registro_acuerdo_facturacion: nil,
                    information_system_agreement_id: nil,
                    fingerprint_type:,
                    fingerprint:,
                    signature: nil)

        # Validation of id_factura
        raise Verifactu::VerifactuError, "invoice_id is required" if invoice_id.nil?
        raise Verifactu::VerifactuError, "invoice_id must be an instance of IDFactura" unless invoice_id.is_a?(InvoiceId)

        # Validation of ref_externa
        unless external_ref.nil?
          raise Verifactu::VerifactuError, "external_ref must be a String" unless Verifactu::Helper::Validador.cadena_valida?(external_ref)
          raise Verifactu::VerifactuError, "ref_externa must have a maximum length of 60 characters" if ref_externa.length > 60
        end

        # Validation of nombre_razon_emisor
        raise Verifactu::VerifactuError, "issuer_name is required" if issuer_name.nil?
        raise Verifactu::VerifactuError, "issuer_name must be a String" unless Verifactu::Helper::Validador.cadena_valida?(issuer_name)
        raise Verifactu::VerifactuError, "issuer_name must have a maximum length of 120 characters" if issuer_name.length > 120

        # Validation of subsanacion
        raise Verifactu::VerifactuError, "rectification must be within #{Verifactu::Config::L4.join(', ')} or be nil" unless rectification.nil? || Verifactu::Config::L4.include?(rectification.upcase)

        # Validation of rechazo_previo 
        if rectification == "S"
          raise Verifactu::VerifactuError, "rechazo_previo must be within #{Verifactu::Config::L17.join(', ')}" unless rechazo_previo.nil? || Verifactu::Config::L14.include?(rechazo_previo.upcase)
          @previous_rejection = rechazo_previo
        else
          @previous_rejection = nil
        end

        # Validation of tipo_factura
        raise Verifactu::VerifactuError, "invoice_type is required" if invoice_type.nil?
        raise Verifactu::VerifactuError, "invoice_type must be a String" unless Verifactu::Helper::Validador.cadena_valida?(invoice_type)
        raise Verifactu::VerifactuError, "invoice_type must be one of the following values: #{Verifactu::Config::L2.join(', ')}" unless Verifactu::Config::L2.include?(invoice_type.upcase)

        # Validation of tipo_rectificativa
        if invoice_type == "R1" || invoice_type == "R2" || invoice_type == "R3" || invoice_type == "R4" || invoice_type == "R5"
          raise Verifactu::VerifactuError, "rectification_type is required si tipo_factura es rectificativa" if rectification_type.nil?
          raise Verifactu::VerifactuError, "rectification_type must be a String" unless Verifactu::Helper::Validador.cadena_valida?(rectification_type)
          raise Verifactu::VerifactuError, "rectification_type must be within #{Verifactu::Config::L3.join(', ')}" unless Verifactu::Config::L3.include?(rectification_type.upcase)
        end

        # Validation of facturas_rectificadas y facturas_sustituidas (VARIABLE ASSIGNMENTS)
        #TODO The NIF of the IDEmisorFactura field must be identified.
        if invoice_type == "R1" || invoice_type == "R2" || invoice_type == "R3" || invoice_type == "R4" || invoice_type == "R5"
          unless rectification_type.nil?
            raise Verifactu::VerifactuError, "facturas_rectificadas must be an Array" unless facturas_rectificadas.is_a?(Array)
            raise Verifactu::VerifactuError, "facturas_rectificadas cannot be empty" if facturas_rectificadas.empty?
            raise Verifactu::VerifactuError, "facturas_rectificadas cannot have more than 1000 elements" if facturas_rectificadas.size > 1000
            invalid_factura = facturas_rectificadas.find { |f| !f.is_a?(InvoiceId) }
            raise Verifactu::VerifactuError, "All elements of facturas_rectificadas must be instances of IDFactura" if invalid_factura
            @rectified_invoices = facturas_rectificadas
            @replaced_invoices = nil
          end
        elsif invoice_type == "F3"
          unless rectification_type.nil?
            raise Verifactu::VerifactuError, "facturas_sustituidas must be an Array" unless facturas_sustituidas.is_a?(Array)
            raise Verifactu::VerifactuError, "facturas_sustituidas cannot be empty" if facturas_sustituidas.empty?
            raise Verifactu::VerifactuError, "facturas_sustituidas cannot have more than 1000 elements" if facturas_sustituidas.size > 1000

            invalid_factura = facturas_sustituidas.find { |f| !f.is_a?(InvoiceId) }
            raise Verifactu::VerifactuError, "All elements of facturas_sustituidas must be instances of IDFactura" if invalid_factura
          end
          @replaced_invoices = facturas_sustituidas
          @rectified_invoices = nil
        else
          @rectified_invoices = nil
          @replaced_invoices = nil
        end

        # Validation of importe_rectificacion 
        if rectification_type == 'S'
          raise Verifactu::VerifactuError, "rectification_amount is required si rectification_type es 'S'" if rectification_amount.nil?
          raise Verifactu::VerifactuError, "importe_rectificacion must be an instance of ImporteRectificacion" unless importe_rectificacion.is_a?(RectificationAmount)
          @rectification_amount = importe_rectificacion
        else
          @rectification_amount = nil
        end

        # Validation of fecha_operacion
        if operation_date
          current_date = Date.today
          min_date = current_date << (20 * 12) # Fecha actual menos 20 años
          max_date = current_date >> 12       # Fecha actual más 1 año

          raise Verifactu::VerifactuError, "operation_date must be an instance of Date" unless operation_date.is_a?(Date)
          raise Verifactu::VerifactuError, "operation_date cannot be inferior a #{min_date}" if operation_date < min_date
          raise Verifactu::VerifactuError, "operation_date cannot be superior a #{max_date}" if operation_date > max_date

          if ["01", "03", nil].include?(impuesto) && !["14", "15"].include?(clave_regimen)
            raise Verifactu::VerifactuError, "operation_date cannot be superior a la fecha actual para Impuesto='01', '03' o no cumplimentado, salvo que ClaveRegimen sea '14' o '15'" if operation_date > current_date
          end
        end

        # Validation of descripcion_operacion
        raise Verifactu::VerifactuError, "operation_description is required" if operation_description.nil?
        raise Verifactu::VerifactuError, "operation_description #{operation_description} must be a String" unless Verifactu::Helper::Validador.cadena_valida?(operation_description)
        raise Verifactu::VerifactuError, "operation_description must have a maximum length of 500 caracteres" if operation_description.length > 500

        # Validation of factura_simplificada_Art7273
        if simplified_invoice_art7273
          raise Verifactu::VerifactuError, "simplified_invoice_art7273 must be a String" unless Verifactu::Helper::Validador.cadena_valida?(simplified_invoice_art7273)
          raise Verifactu::VerifactuError, "simplified_invoice_art7273 must be within #{Verifactu::Config::L4.join(', ')}" unless Verifactu::Config::L4.include?(simplified_invoice_art7273.upcase)

          if simplified_invoice_art7273 == "S"
            valid_tipo_factura = ["F1", "F3", "R1", "R2", "R3", "R4"]
            raise Verifactu::VerifactuError, "simplified_invoice_art7273 can only be 'S' si TipoFactura es one of the following values: #{valid_tipo_factura.join(', ')}" unless valid_tipo_factura.include?(invoice_type)
          end
        end

        # Validation of factura_sin_identif_destinatario_art61d
        if invoice_without_recipient_id_art61d
          raise Verifactu::VerifactuError, "invoice_without_recipient_id_art61d must be a String" unless Verifactu::Helper::Validador.cadena_valida?(invoice_without_recipient_id_art61d)
          raise Verifactu::VerifactuError, "invoice_without_recipient_id_art61d must be within #{Verifactu::Config::L5.join(', ')}" unless Verifactu::Config::L5.include?(invoice_without_recipient_id_art61d.upcase)

          if invoice_without_recipient_id_art61d == "S"
            valid_tipo_factura = ["F2", "R5"]
            raise Verifactu::VerifactuError, "invoice_without_recipient_id_art61d can only be 'S' si TipoFactura es one of the following values: #{valid_tipo_factura.join(', ')}" unless valid_tipo_factura.include?(invoice_type)
          end
        end

        # Validation of macrodato
        if macro_data
          raise Verifactu::VerifactuError, "macro_data must be a String" unless Verifactu::Helper::Validador.cadena_valida?(macro_data)
          raise Verifactu::VerifactuError, "macro_data must be within #{Verifactu::Config::L14.join(', ')}" unless Verifactu::Config::L14.include?(macro_data.upcase)
        end

        # Validation of issued_by_third_party_or_recipient
        if issued_by_third_party_or_recipient
          raise Verifactu::VerifactuError, "issued_by_third_party_or_recipient must be a String" unless Verifactu::Helper::Validador.cadena_valida?(issued_by_third_party_or_recipient)
          raise Verifactu::VerifactuError, "issued_by_third_party_or_recipient must be within #{Verifactu::Config::L6.join(', ')}" unless Verifactu::Config::L6.include?(issued_by_third_party_or_recipient.upcase)
        end
        # Validation of tercero 
        if issued_by_third_party_or_recipient == "T"
          raise Verifactu::VerifactuError, "third_party is required" if third_party.nil?
          raise Verifactu::VerifactuError, "third_party must be an instance of PersonaFisicaJuridica" unless third_party.is_a?(LegalEntity)

          raise Verifactu::VerifactuError, "third_party must have a NIF different from the invoice issuer's NIF" if third_party.nif == id_factura.issuer_id
          raise Verifactu::VerifactuError, "third_party must be registered (id_type != 07)" if third_party.other_id && third_party.other_id.id_type == '07'
          @third_party = third_party
        else
          @third_party = nil
        end

        # Validation of destinatarios
        if ['F1', 'F3', 'R1', 'R2', 'R3', 'R4'].include?(invoice_type)
          raise Verifactu::VerifactuError, "recipients is required" if recipients.nil?
          raise Verifactu::VerifactuError, "recipients must be an instance of Destinatarios" unless recipients.is_a?(Array)
          raise Verifactu::VerifactuError, "recipients must have at least one destinatario" if recipients.empty?
          recipients.each do |destinatario|
            raise Verifactu::VerifactuError, "If the recipient is not registered, the country code must be Spanish. Recipient: #{destinatario.inspect}" if destinatario.other_id && destinatario.other_id.id_type == '07' && destinatario.other_id.codigo_pais != 'ES'
          end
        elsif ['F2', 'R5'].include?(invoice_type)
          raise Verifactu::VerifactuError, "recipients must be nil if TipoFactura es F2 o R5" unless recipients.nil?
        end

        # Validation of cupon
        raise Verifactu::VerifactuError, "coupon must be within #{Verifactu::Config::L4.join(', ')} o ser nil" unless coupon.nil? || Verifactu::Config::L4.include?(coupon.upcase)
        if coupon == 'S'
          raise Verifactu::VerifactuError, "solo las facturas R5 y R1 pueden tener coupon" unless invoice_type == 'R5' || tipo_factura == 'R1'
        end

        # Validation of desglose
        # Breakdown validations that require registro_alta values are performed here
        raise Verifactu::VerifactuError, "breakdown is required" if breakdown.nil?
        raise Verifactu::VerifactuError, "breakdown must be a list of instances of Desglose" unless breakdown.is_a?(Array)
        raise Verifactu::VerifactuError, "breakdown cannot be empty" if breakdown.empty?
        sum_base_imponible_cuota_repercutida = 0
        sum_tax = 0
        sum_importe_desglose = 0
        breakdown.each do |d|
          raise Verifactu::VerifactuError, "Each breakdown element must be an instance of Desglose" unless d.is_a?(BreakdownDetail)
          if d.impuesto == "01"
            invoice_date = Date.parse(operation_date || invoice_id.issue_date, "dd-mm-yyyy")
            case d.tax_rate
            when "5"
              raise Verifactu::VerifactuError, "tipo_impositivo cannot be 5 if the invoice date is not between 1 de julio de 2022 y 30 de septiembre de 2024" unless fecha_factura.between?(Date.new(2022, 7, 1), Date.new(2024, 9, 30))
              if d.tipo_recargo_equivalencia == "0.5"
                raise Verifactu::VerifactuError, "tipo_recargo_equivalencia must be 0.5 if the invoice date is less than or equal to December 31, 2022" unless fecha_factura <= Date.new(2022, 12, 31)
              elsif d.tipo_recargo_equivalencia == "0.62"
                raise Verifactu::VerifactuError, "tipo_recargo_equivalencia must be 0.62 if the invoice date is between January 1, 2023 and September 30, 2024" unless fecha_factura.between?(Date.new(2023, 1, 1), Date.new(2024, 9, 30))
              end
            when "2"
              raise Verifactu::VerifactuError, "tipo_impositivo cannot be 2 if the invoice date is not between 1 de octubre de 2024 y 31 de diciembre de 2024" unless fecha_factura.between?(Date.new(2024, 10, 1), Date.new(2024, 12, 31))
            when "7.5"
              raise Verifactu::VerifactuError, "tipo_impositivo cannot be 7.5 if the invoice date is not between 1 de octubre de 2024 y 31 de diciembre de 2024" unless fecha_factura.between?(Date.new(2024, 10, 1), Date.new(2024, 12, 31))
            when "0"
              if d.tipo_recargo_equivalencia == "0"
                raise Verifactu::VerifactuError, "tipo_recargo_equivalencia must be 0 if the invoice date is between January 1, 2023 and before September 30, 2024" unless fecha_factura.between?(Date.new(2023, 1, 1), Date.new(2024, 9, 30))
              end
            end

            # Added in 1.1.5
            if d.regime_key == "E5"
              recipients.each do |destinatario|
                raise Verifactu::VerifactuError, "When the tax is VAT, and the exempt operation is E5, all recipients must have IdOtro. Recipient: #{destinatario.inspect}" if destinatario.other_id.nil?
              end
            end
          end

          if d.operation_qualification == "S2"
            valid_tipo_factura = ["F1", "F3", "R1", "R2", "R3", "R4"]
            raise Verifactu::VerifactuError, "when calificacion_operacion is S2, tipo_factura must be one of the following values: #{valid_tipo_factura.join(', ')}" unless valid_tipo_factura.include?(invoice_type)
          end

          error_message = "when clave_regimen is #{d.regime_key}"
          case d.regime_key
          when "06"
            if d.impuesto == "01" || d.impuesto == "03"
              invalid_tipo_factura = ["F2", "F3", "R5"]
              raise Verifactu::VerifactuError, "#{error_message}, tipo_factura cannot be one of the following values: #{invalid_tipo_factura.join(', ')}" if invalid_tipo_factura.include?(invoice_type)
            end
          when "10"
            valid_tipo_factura = ["F1"]
            raise Verifactu::VerifactuError, "#{error_message}, tipo_factura must be one of the following values: #{valid_tipo_factura.join(', ')}" unless valid_tipo_factura.include?(invoice_type)
            recipients.each do |destinatario|
              raise Verifactu::VerifactuError, "#{error_message}, all recipients must have a NIF" unless destinatario.nif
            end
          when "14"
            if d.impuesto == "01" || d.impuesto == "03"
              raise Verifactu::VerifactuError, "#{error_message}, fecha_operacion is required" if fecha_operacion.nil?
              raise Verifactu::VerifactuError, "#{error_message}, fecha_operacion must be later than fecha_expedicion_factura" if fecha_operacion < id_factura.issue_date
            end
          end

          unless rectification_type == "I" || invoice_type == "R2" || invoice_type == "R3"
            d.validate_charged_tax
          end

          sum_base_imponible_cuota_repercutida += d.taxable_base_o_importe_no_sujeto.to_f + d.charged_tax.to_f
          sum_tax += d.charged_tax.to_f + d.cuota_recargo_equivalencia.to_f

          clave_regimen_exempta_importe_total = ['03', '05', '06', '08', '09']
          unless clave_regimen_exempta_importe_total.include?(d.regime_key)
            sum_importe_desglose += d.taxable_base_o_importe_no_sujeto.to_f + d.charged_tax.to_f + d.cuota_recargo_equivalencia.to_f
          end
        end

        if invoice_type == "F2"
          unless num_registro_acuerdo_facturacion || factura_sin_identif_destinatario_art61d == "S"
            raise Verifactu::VerifactuError, "The sum of base_imponible_o_importe_no_sujeto and cuota_repercutida of all breakdowns must be less than #{Verifactu::Config::MAXIMO_FACTURA_SIMPLIFICADA+Verifactu::Config::MARGEN_ERROR_FACTURA_SIMPLIFICADA}" if sum_base_imponible_cuota_repercutida > Verifactu::Config::MAXIMO_FACTURA_SIMPLIFICADA + Verifactu::Config::MARGEN_ERROR_FACTURA_SIMPLIFICADA
          end
        end

        # Validation of total_tax
        raise Verifactu::VerifactuError, "total_tax is required" if total_tax.nil?
        raise Verifactu::VerifactuError, "total_tax must have maximum 12 digitos antes del decimal y 2 decimales" unless Verifactu::Helper::Validador.validar_digito(total_tax, digitos: 12)
        tax_difference = total_tax.to_f - sum_tax
        raise Verifactu::VerifactuError, "Cuota total does not match the sum of breakdowns: #{total_tax} - #{sum_tax} = #{tax_difference}" if tax_difference.abs > Config::MARGEN_ERROR_CUOTA_TOTAL

        # Validation of total_amount
        raise Verifactu::VerifactuError, "total_amount is required" if total_amount.nil?
        raise Verifactu::VerifactuError, "total_amount must have maximum 12 digitos antes del decimal y 2 decimales" unless Verifactu::Helper::Validador.validar_digito(total_amount, digitos: 12)
        amount_difference = total_amount.to_f - sum_importe_desglose
        raise Verifactu::VerifactuError, "total_amount does not match the sum of breakdowns: #{total_amount} - #{sum_importe_desglose} = #{amount_difference}" if amount_difference.abs > Config::MARGEN_ERROR_IMPORTE_TOTAL

        # Validation of sistema_informatico
        raise Verifactu::VerifactuError, "information_system is required" if information_system.nil?
        raise Verifactu::VerifactuError, "information_system must be an instance of SistemaInformatico" unless information_system.is_a?(InformationSystem)

        # Validation of record_generation_datetime
        raise Verifactu::VerifactuError, "record_generation_datetime is required" if record_generation_datetime.nil?
        raise Verifactu::VerifactuError, "record_generation_datetime must be in ISO 8601 format: YYYY-MM-DDThh:mm:ssTZD (ej: 2024-01-01T19:20:30+01:00)" unless Verifactu::Helper::Validador.fecha_hora_huso_gen_valida?(record_generation_datetime)


        # Validation of num_registro_acuerdo_facturacion
        if num_registro_acuerdo_facturacion
          raise Verifactu::VerifactuError, "num_registro_acuerdo_facturacion must be a String" unless Verifactu::Helper::Validador.cadena_valida?(num_registro_acuerdo_facturacion)
          raise Verifactu::VerifactuError, "num_registro_acuerdo_facturacion must have a maximum length of 15 caracteres" if num_registro_acuerdo_facturacion.length > 15
          # TODO verificar que exista en la AEAT
        end

        # Validation of information_system_agreement_id
        if information_system_agreement_id
          raise Verifactu::VerifactuError, "information_system_agreement_id must be a String" unless Verifactu::Helper::Validador.cadena_valida?(information_system_agreement_id)
          raise Verifactu::VerifactuError, "information_system_agreement_id must have a maximum length of 16 caracteres" if information_system_agreement_id.length > 16
          # TODO verificar que exista en la AEAT
        end

        # Validation of encadenamiento
        raise Verifactu::VerifactuError, "chaining is required" if chaining.nil?
        raise Verifactu::VerifactuError, "chaining must be an instance of Encadenamiento" unless chaining.is_a?(Chaining)

        # Validation of fingerprint_type
        raise Verifactu::VerifactuError, "fingerprint_type is required" if fingerprint_type.nil?
        raise Verifactu::VerifactuError, "fingerprint_type must be within #{Verifactu::Config::L12.join(', ')}" unless Verifactu::Config::L12.include?(fingerprint_type.upcase)

        # Validation of fingerprint
        raise Verifactu::VerifactuError, "fingerprint is required" if fingerprint.nil?
        # TODO: Verify that fingerprint complies with the requirements of the technical specifications document for generating the fingerprint or "hash" of billing records

        # Validation of signature
        if signature
          # TODO: Verify that signature complies with the "schema" format at http://www.w3.org/2000/09/xmldsig#
        end

        raise Verifactu::VerifactuError, "ID VERSION NO ES UNA VERSION ACEPTADA POR VERIFACTU" unless Verifactu::Config::L15.include?(Verifactu::Config::ID_VERSION)

        @id_version = Verifactu::Config::ID_VERSION
@invoice_id = invoice_id # Instance of IDFactura
@external_ref = external_ref
@issuer_name = issuer_name
        @rectification = rectification
        @previous_rejection = previous_rejection
@invoice_type = invoice_type
        @rectification_type = rectification_type
        @rectified_invoices = rectified_invoices
        @replaced_invoices = replaced_invoices
        @rectification_amount = rectification_amount
@operation_date = operation_date
@operation_description = operation_description
        @simplified_invoice_art7273 = simplified_invoice_art7273
        @invoice_without_recipient_id_art61d = invoice_without_recipient_id_art61d
        @macro_data = macro_data
        @issued_by_third_party_or_recipient = issued_by_third_party_or_recipient
        @third_party = third_party # Instance of PersonaFisicaJuridica
        @recipients = recipients # Array of instances of Destinatario
        @coupon = coupon
        @breakdown = breakdown # Array of instances of BreakdownDetail
        @total_tax = total_tax
        @total_amount = total_amount
        @chaining = chaining
        @information_system = information_system # Instance of SistemaInformatico
        @record_generation_datetime = record_generation_datetime
        @num_registro_acuerdo_facturacion = num_registro_acuerdo_facturacion
        @information_system_agreement_id = information_system_agreement_id
        @fingerprint_type = fingerprint_type
        @fingerprint = fingerprint
        @signature = signature

        if BigDecimal(total_amount).abs > 100_000_000.00
          @macro_data = 'S'
        end
      end
    end
  end
end
