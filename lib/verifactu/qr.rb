module Verifactu
  class QR
    require 'rqrcode'
    require 'erb'

    def generar_qr(nif:, numserie:, fecha:, importe:)
      raise ArgumentError, "NIF is required" if nif.nil? || nif.empty?
      raise ArgumentError, "Numserie is required" if numserie.nil? || numserie.empty?
      raise ArgumentError, "Fecha is required" if fecha.nil? || fecha.empty?
      raise ArgumentError, "Importe is required" if importe.nil? || importe.empty?

      @url = Verifactu::Config::VerifactuConfig::URL_QR +
             "?nif=#{ERB::Util.url_encode(nif)}" \
             "&numserie=#{ERB::Util.url_encode(numserie)}" \
             "&fecha=#{ERB::Util.url_encode(fecha)}" \
             "&importe=#{ERB::Util.url_encode(importe)}"

      RQRCode::QRCode.new(@url, level: :m)
      
      #qrcode = RQRCode::QRCode.new(@url, level: :m)
      #qrcode.as_png(size: 40, border_modules: 0)
    end
  end
end