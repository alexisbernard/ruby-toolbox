# Compute an approximation to geolocate in a given radius around a latitude and a longitude.
# It provides min and max for both latitude and longitude to quickly filter against a database.
# That is an approximation only, because the exact computation is really slow.
# The approximation is good enough for non scientific usage.
# Here is an example:
#
#   area = GeoSquareArea.new(latitude, longitude, radius_in_km)
#   User.where("latitude BETWEEN ? AND ? AND longitude BETWEEN ? AND ?",
#     area.min_latitude, area.max_latitude, area.min_longitude, area.max_longitude)

class GeoSquareArea
  EARTH_RADIUS = 6371.0

  attr_reader :latitude, :longitude, :radius
  attr_reader :min_latitude, :min_longitude, :max_latitude, :max_longitude

  def initialize(latitude, longitude, radius)
    @latitude, @longitude, @radius = latitude.to_f, longitude.to_f, radius.to_f
    compute
  end

  def deg2rad(degree)
    degree * Math::PI / 180
  end

  def rad2deg(radian)
    radian * 180 / Math::PI
  end

  # Following formula and comments are stolen from the Internet :-)
  def compute
    # first-cut bounding box (in degrees)
    @max_latitude = latitude + rad2deg(radius / EARTH_RADIUS)
    @min_latitude = latitude - rad2deg(radius / EARTH_RADIUS)

    # compensate for degrees longitude getting smaller with increasing latitude
    @max_longitude = longitude + rad2deg(radius / EARTH_RADIUS / Math.cos(deg2rad(latitude)))
    @min_longitude = longitude - rad2deg(radius / EARTH_RADIUS / Math.cos(deg2rad(latitude)))
  end
end
