require_relative '../../georuby/geometry_literal'
module Sequel
  module PostgisGeoRuby
    module DatabaseMethods

      def self.extended(db)
        db.instance_exec do
          # @aryk - Allow this to work in multi-threaded environment by using a threadlocal variable to store the parser.
          georuby_conversion_proc = lambda do |v|
            obj = Thread.current[:sequel_postgis_geo_ruby] ||= begin
              factory = ::GeoRuby::SimpleFeatures::GeometryFactory::new
              {
                :factory => factory,
                :hex_ewkb_parser => ::GeoRuby::SimpleFeatures::HexEWKBParser.new(factory),
              }
            end
            obj.fetch(:hex_ewkb_parser).parse(v)
            obj.fetch(:factory).geometry
          end

          ['geometry', 'geography'].each do |geom_type|
            add_named_conversion_proc(geom_type, &georuby_conversion_proc)
          end
        end
      end
    end
  end
  Database.register_extension(:postgis_georuby, PostgisGeoRuby::DatabaseMethods)
end
