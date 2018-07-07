# Monkey patches GeoRuby::SimpleFeatures::Geometry
# This method is called by Sequel when inserting records
class GeoRuby::SimpleFeatures::Geometry
  def sql_literal_append(ds, sql)
	  ds.literal_append(sql, self.as_hex_ewkb)
  end
end
