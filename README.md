Sequel-Postgis-GeoRuby
======================

A minimal Sequel extension for casting Postgis geometry columns as GeoRuby objects.

Installation:

    gem install sequel-postgis-georuby

Usage:

    require 'sequel-postgis-georuby'

    DB = Sequel.connect('postgres://localhost/my_shiny_database')

    DB.extension :postgis_georuby

    DB[:places].insert(
      name: "Tahoe City",
      geom: GeoRuby::SimpleFeatures::Point.from_x_y(-120.143999, 39.167099)
    )

    DB[:places].where(name: "Tahoe City").first

    #=> {:id => 1, :name => "Tahoe City", :geom => #<GeoRuby::SimpleFeatures::Point:0x00007fb294945180 @srid=4326 ...>}


## Spatial Column Definition

No special helpers are provided for creating spatial columns. Sequel's `column` method can be used with a string like `'geography(Point,4326)'` as the type.

Basic indices can be created with `:index => {:type=>:gist}`.

    Sequel.migration do
      up do
        # Enables the Postgis extension in Postgres
        add_extension :postgis

        alter_table :roads do
          # Adds column with geometry type and creates gist index
          column :the_geom,  'geometry(LINESTRINGZM,24879), :index=>{:type=>:gist}
        end

      end
    end

## Testing

Run using `rake spec`

This gem has been tested with Ruby 2.5, Sequel 5.10, and Postgis 2.4 on PostgreSQL 10.

## License

MIT License (c) 2018 Barry Sears
