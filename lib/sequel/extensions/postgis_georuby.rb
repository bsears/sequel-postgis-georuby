module Sequel
  module PostgisGeoRuby
    module DatabaseMethods

      def self.extended(db)
        db.instance_exec do
          factory = ::GeoRuby::SimpleFeatures::GeometryFactory::new
          hex_ewkb_parser = ::GeoRuby::SimpleFeatures::HexEWKBParser.new(factory)
          georuby_conversion_proc = lambda{|v| hex_ewkb_parser.parse(v);factory.geometry}

          #{ 'geometry' => ::GeoRuby::SimpleFeatures::Geometry,
          #  'geography' => ::GeoRuby::SimpleFeatures::Geometry }.each do #|geom_type, geom_class|
          #  add_named_conversion_proc(geom_type, &georuby_conversion_proc)
          #  @schema_type_classes[geom_type] = geom_class
          ['geometry', 'geography'].each do |geom_type|
            add_named_conversion_proc(geom_type, &georuby_conversion_proc)
          end
        end
      end
    end
  end
  Database.register_extension(:postgis_georuby, PostgisGeoRuby::DatabaseMethods)
end
