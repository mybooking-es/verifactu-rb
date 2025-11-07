require 'date'

module Verifactu
  module Helper
    class Validador
      # Validate the NIF format.
      # @param nif [String] NIF to validate
      # @raise [Verifactu::VerifactuError] If the NIF is nil, empty or not a string
      def self.validar_nif(nif)
        raise Verifactu::VerifactuError, "NIF cannot be nil or empty" if nif.nil? || nif.empty?
        raise Verifactu::VerifactuError, "NIF must be a string" unless nif.is_a?(String)
        #TODO implement NIF validation via AEAT API
      end

      # Validate if the date is valid and not in the future.
      # @param fecha [String, Date] Date to validate
      # @raise [Verifactu::VerifactuError] If the date is nil, not a Date object or a valid date string
      def self.validar_fecha_pasada(fecha)
        fecha_d = self.validar_fecha(fecha)
        raise Verifactu::VerifactuError, "Date cannot be in the future" if fecha_d > Date.today
      end

      # Validate if the date is valid and not in the past.
      # @param fecha [String, Date] Date to validate
      # @raise [Verifactu::VerifactuError] If the date is nil, not a Date object or a valid date string
      def self.validar_fecha_futura(fecha)
        fecha_d = self.validar_fecha(fecha)
        raise Verifactu::VerifactuError, "Date cannot be in the past" if fecha_d < Date.today
      end

      # Validate if the date is valid and is the last day of the year.
      # @param fecha [String, Date] Date to validate
      # @raise [Verifactu::VerifactuError] If the date is nil, not a Date object or a valid date string
      def self.validar_fecha_fin_de_ano(fecha)
        fecha_d = self.validar_fecha(fecha)

        aeat_year = Date.today.year
        valid_years = [aeat_year, aeat_year - 1]
        raise Verifactu::VerifactuError, "The year of the date must be equal to the current year or the previous year" unless valid_years.include?(fecha_d.year)
        raise Verifactu::VerifactuError, "Date must have the format 31-12-20XX" unless fecha_d == Date.new(fecha_d.year, 12, 31)
      end

      # Validate if the date is valid
      # @param fecha [String, Date] Date to validate
      # @raise [Verifactu::VerifactuError] If the date is nil, not a Date object
      def self.validar_fecha(fecha)
        raise Verifactu::VerifactuError, "Date cannot be nil" if fecha.nil?
        if fecha.is_a?(String)
          begin
            fecha_d = Date.parse(fecha, '%d-%m-%Y')
          rescue Verifactu::VerifactuError
            raise Verifactu::VerifactuError, "Invalid date format. Must be 'dd-mm-yyyy'."
          end
        elsif !fecha.is_a?(Date)
          raise Verifactu::VerifactuError, "Date must be a date string"
        end
        fecha_d
      end

      # Validate if the date is valid (version that returns true/false)
      # @param fecha [String, Date] Date to validate
      # @return [Boolean] true if the date is valid, false otherwise
      def self.fecha_valida?(fecha)
        validar_fecha(fecha)
        true
      rescue Verifactu::VerifactuError
        false
      end

      # Validate if the digit is a valid number
      # @note This function has been extracted to facilitate maintenance and reusability
      # @note This way, the decimal separator or validation format can be changed globally without affecting all classes that use it
      # @param digito [String] Digit to validate
      # @param max_length [Integer] Maximum length of the digit
      # @raise [Verifactu::VerifactuError] If the digit is nil, not a string or does not comply with the format
      def self.validar_digito(digito, digitos: 12)
        raise Verifactu::VerifactuError, "Digit cannot be nil" if digito.nil?
        raise Verifactu::VerifactuError, "Digit must be a string" unless digito.is_a?(String)
        return true if digito =~ /^-?\d{1,#{digitos}}(\.\d{0,2})?$/
        false
      end

      # Validate if the string contains only printable ASCII characters
      # @param cadena [String] String to validate
      # @raise [Verifactu::VerifactuError] If the string is nil, not a string or contains non-printable characters
      # @note Characters '<', '>' and '=' are excluded from 09/09/2025 (allowed again from 23/10/2025)
      def self.cadena_valida(cadena)
        raise Verifactu::VerifactuError, "String cannot be nil" if cadena.nil?
        raise Verifactu::VerifactuError, "String must be a string" unless cadena.is_a?(String)
        raise Verifactu::VerifactuError, "String must contain only printable ASCII characters" unless cadena.ascii_only? && cadena.chars.all? { |char| char.ord.between?(32, 126) }
        # Comment the following line to allow the characters '<', '>' and '='
        raise Verifactu::VerifactuError, "String cannot contain the characters '<', '>' or '='" if cadena.include?('<') || cadena.include?('>') || cadena.include?('=')
      end

      # Validate if the string is valid (version that returns true/false)
      # @param cadena [String] String to validate
      # @return [Boolean] true if the string is valid, false otherwise
      # @note Characters '<', '>' and '=' are excluded from 09/09/2025 (allowed again from 23/10/2025)
      def self.cadena_valida?(cadena)
        cadena_valida(cadena)
        true
      rescue Verifactu::VerifactuError
        false
      end

      # Validate if the date and time with timezone is in ISO 8601 format
      # @param fecha_hora_huso_gen [String] Date and time with timezone to validate
      # @return [Boolean] true if the date and time with timezone is in ISO 8601 format, false otherwise
      def self.fecha_hora_huso_gen_valida?(fecha_hora_huso_gen)
        return false if fecha_hora_huso_gen.nil?
        return false unless fecha_hora_huso_gen.is_a?(String)
        return false unless fecha_hora_huso_gen.match?(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:Z|[+-]\d{2}:\d{2})\z/)
        true
      end
    end
  end
end
