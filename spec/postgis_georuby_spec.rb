$:.unshift(File.join(File.dirname(File.expand_path(__FILE__)), "../lib/"))
require 'sequel-postgis-georuby'

describe "postgis_georuby extension" do
  before do

    @db = Sequel.connect('postgres://localhost/sequel_postgis_georuby_test')

    @db.execute("CREATE EXTENSION IF NOT EXISTS postgis;")
    @db.extension :postgis_georuby

    @db.create_table! :locations do
      primary_key :id
      String :name, unique: true, null: false
      column :geom, 'geometry(Point, 4326)', null: false, :index=>{:type=>:gist}
    end

    @db.create_table! :geographies do
      primary_key :id
      String :name, unique: true, null: false
      column :geom, 'geography(POINT, 4326)', unique: true, :index=>{:type=>:gist}
    end

    @cities = {"London" =>[-0.14,51.53], "Paris" => [2.27, 48.85], "Tokyo" => [139.60,35.67], "New York" => [-74.26,40.69], "Buenos Aires" => [-58.50,-34.61] }

  end

  it "creates a table with geography column" do
    @db.create_table! :geographies do
      primary_key :id
      String :name, unique: true, null: false
      column :geom, 'geography(POINT, 4326)', unique: true, :index=>{:type=>:gist}
    end
    #expect(@db[:schema])
  end

  it "inserts cities" do
    @cities.each do |city, coords|
      @db[:locations].insert(name: city, geom: GeoRuby::SimpleFeatures::Point.from_coordinates(coords))
    end
    expect(@db[:locations].count).to eql(5)
  end

  it "roundtrips from locations" do
    @db[:locations].insert(name: "Toronto", geom: GeoRuby::SimpleFeatures::Point.from_coordinates([-79.60,43.65]))

    res = @db[:locations].where(name: "Toronto").first
    expect(res[:geom].x).to eql(-79.60)
    expect(res[:geom].y).to eql(43.65)
  end

  it "roundtrips from geographies" do
    @db[:geographies].insert(name: "Toronto", geom: GeoRuby::SimpleFeatures::Point.from_coordinates([-79.60,43.65]))

    res = @db[:geographies].where(name: "Toronto").first
    expect(res[:geom].x).to eql(-79.60)
    expect(res[:geom].y).to eql(43.65)
  end

  # More of an example than a test
  it "works with postgis queries" do
    @cities.each do |city, coords|
      @db[:locations].insert(name: city, geom: GeoRuby::SimpleFeatures::Point.from_coordinates(coords))
    end

    cities = @db[:locations].where(Sequel.lit("geom && ST_MakeEnvelope(-1, 40, 5, 52, 4326)")).all
    expect(cities.count).to eq(2)
  end

end
