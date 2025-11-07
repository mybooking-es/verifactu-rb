## [Unreleased]

## [0.1.0] - 2025-07-16

- Initial release

## [0.2.0] - 2025-09-23

- String validation now has its own validation in validador.rb (previously `cadena.is_a?(String)`)
- Date-time with timezone validation now has its own validation in validador.rb (previously an unless ... raise)

- Verifactu has made changes to the documents: (only changes affecting this gem are mentioned)
- - Characters '<', '>' and '=' are no longer allowed in alphanumeric fields

## [0.3.0] - 2025-10-16

- String validation now has its own validation in validador.rb (previously `cadena.is_a?(String)`)
- Date-time with timezone validation now has its own validation in validador.rb (previously an unless ... raise)

- Verifactu has made changes to the documents: (only changes affecting this gem are mentioned)
- - Characters '<', '>' and '=' are now allowed in alphanumeric fields (CHANGE NOT APPLIED FOR SECURITY. You can modify `Verifactu::Helper::Validador.cadena_valida()` to allow these characters)
- - Characters `"` `'` `<`, `>` and `=` are no longer allowed in NumSerieFactura