module Verifactu
  class GeneraQrService

    URL_BASE_VERIFACTU_PRE_PROD = "https://prewww2.aeat.es/wlpl/TIKE-CONT/ValidarQR"
    URL_BASE_VERIFACTU_PROD = "https://www2.agenciatributaria.gob.es/wlpl/TIKE-CONT/ValidarQR"
    URL_BASE_NO_VERIFACTU_PRE_PROD = "https://prewww2.aeat.es/wlpl/TIKE-CONT/ValidarQRNoVerifactu"
    URL_BASE_NO_VERIFACTU_PROD = "https://www2.agenciatributaria.gob.es/wlpl/TIKE-CONT/ValidarQRNoVerifactu"

    # Generates a QR code for Verifactu validation
    # param environment [Symbol] :pre_prod or :prod
    # @param verifactu [Boolean] true if Verifactu, false if not
    # @param nif [String] NIF of the issuer
    # @param numserie [String] Series number of the invoice
    # @param fecha [String] Date of the invoice in YYYY-MM-DD format
    # @param importe [String] Total amount of the invoice
    # @return [RQRCode::QRCode] QR code object
    #
    # @example
    #  qr_code = GeneraQrService.new.execute(environment: :prod,
    #                                        verifactu: true,
    #                                        nif: '12345678A',
    #                                        numserie: '0001',
    #                                        fecha: '2023-10-01',
    #                                        importe: '100.00')
    #  png = qr_code.as_png(size: 40, border_modules: 0)
    #
    def execute(environment:, verifactu:, nif:, numserie:, fecha:, importe:)
      raise Verifactu::VerifactuError, "Environment is required" if environment.nil?
      raise Verifactu::VerifactuError, "Verifactu flag is required" if verifactu.nil?
      raise Verifactu::VerifactuError, "NIF is required" if nif.nil? || nif.empty?
      raise Verifactu::VerifactuError, "Numserie is required" if numserie.nil? || numserie.empty?
      raise Verifactu::VerifactuError, "Fecha is required" if fecha.nil? || fecha.empty?
      raise Verifactu::VerifactuError, "Importe is required" if importe.nil? || importe.empty?
      unless [:pre_prod, :prod].include?(environment)
        raise Verifactu::VerifactuError, "Invalid environment: #{environment}. Use :pre_prod or :prod."
      end

      # Get the URL base
      url_base = url_base(verifactu: verifactu, environment: environment)

      args = []
      args << "nif=#{ERB::Util.url_encode(nif)}"
      args << "numserie=#{ERB::Util.url_encode(numserie)}"
      args << "fecha=#{ERB::Util.url_encode(fecha)}"
      args << "importe=#{ERB::Util.url_encode(importe)}"

      # Build the complete URL
      url = "#{url_base}?#{args.join('&')}"

      # Generate the QR code
      RQRCode::QRCode.new(url, level: :m)

    end

    private

    def url_base(verifactu:, environment:)
      if environment == :pre_prod
        case verifactu
        when true
          url_base = URL_BASE_VERIFACTU_PRE_PROD
        when false
          url_base = URL_BASE_NO_VERIFACTU_PRE_PROD
        end
      elsif environment == :prod
        case verifactu
        when true
          url_base = URL_BASE_VERIFACTU_PROD
        when false
          url_base = URL_BASE_NO_VERIFACTU_PROD
        end
      end
    end
  end
end
