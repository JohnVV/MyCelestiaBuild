--  Based on 'show-azimuth-elevation.celx (v1.2)'
--  by Harald Schmidt (http://www.h-schmidt.net/celestia/)
--  Adapted for the Lua Tools by Hank Ramsey
--  Modified for the Lua Edu Tools by Vincent

-- useful constants:
local pkg = {
    LOOK  = celestia:newvector(0,0,-1);
    UP    = celestia:newposition(0,1,0);
    UPV   = celestia:newvector(0,1,0);
    -- Angle between J2000 mean equator and the ecliptic plane.
    J2000Obliquity = 23.4392911 * math.pi / 180;
    -- EARTH = celestia:find("Sol/Earth");
}
celutil = pkg;

-- transform a vector by a rotation 
pkg.rotation_transform = function (v, rotation)
    --[[ Use native method if available (1.3.2pre8?) ]]
    if rotation.transform ~= nil then
        return rotation:transform(v)
    end
    local matrix = { }
    local x = rotation.x;
    local y = rotation.y;
    local z = rotation.z;
    local w = rotation.w;
    local wx = w * x * 2;
    local wy = w * y * 2;
    local wz = w * z * 2;
    local xx = x * x * 2;
    local xy = x * y * 2;
    local xz = x * z * 2;
    local yy = y * y * 2;
    local yz = y * z * 2;
    local zz = z * z * 2;
    matrix[0] = { x= 1 - yy - zz, y= xy - wz,     z= xz + wy }
    matrix[1] = { x= xy + wz,     y= 1 - xx - zz, z= yz - wx }
    matrix[2] = { x= xz - wy,     y= yz + wx,     z= 1 - xx - yy }
    local nx = (matrix[0].x * v.x + matrix[1].x * v.y + matrix[2].x * v.z)
    local ny = (matrix[0].y * v.x + matrix[1].y * v.y + matrix[2].y * v.z)
    local nz = (matrix[0].z * v.x + matrix[1].z * v.y + matrix[2].z * v.z)
    return celestia:newvector(nx, ny, nz)
end

-- Return a vector in the direction where the observer is looking
pkg.lookat = function (obs)
    local rot = obs:getorientation()
    return (pkg.rotation_transform(pkg.LOOK,rot)):normalize()
end

-- Transform coordinates from cartesian to polar(?)
pkg.transform_xyz2rtp = function (x,y,z)
    local r = math.sqrt(x*x + y*y + z*z)
    local theta = math.atan(math.sqrt(x*x + y*y)/z)
    local phi
    if x < 0 then
        phi = math.atan(y/x) + math.pi
    elseif x > 0 then
        phi = math.atan(y/x)
    elseif y > 0 then
        phi = math.pi/2
    else
        phi = -math.pi/2
    end
    return r,theta,phi
end

-- Transform coordinates from polar to cartesian
pkg.transform_pt2xyz = function (p,t)
 --[[ B&S, p. 177 ]]
    local r = 1
    local x = r*math.sin(t)*math.cos(p)
    local y = r*math.sin(t)*math.sin(p)
    local z = r*math.cos(t)
    return x,y,z
end

-- Create new axis.
--
--   local_up is a vector going from planet center to surface position
--   rot_axis is a vector along the rotation axis, pointing "north"
--   (both must be normalized)
--   Returns three perpendicular and normalized vectors,
--   a vector from south to north, one from east to west and the original local_up
--
--   the axis W-E is perpendicular to both the rotation axis
--   and the local UP (i.e. there is no EAST-WEST when at the poles)
pkg.create_local_axis = function (local_up, rot_axis)
    local W2E = (rot_axis ^ local_up):normalize()

    --[[ the axis N-S is perpendicular to the local up, and the W-E axis ]]
    local S2N = (local_up ^ W2E):normalize()

    --[[ NOW: local_up, W2E, S2N should all be perpendicular.
    // Test (all values should be near zero):
    // celestia:print("lw:" .. local_up*W2E .. " ws:" .. W2E*S2N .. " ls:".. local_up*S2N)

    // return X,Y,Z:
    ]]

    return S2N, W2E*(-1), local_up
end

-- Transform coordinate system:
--    From universal coordinates to the one given by x_axis, y_axis, z_axis
pkg.transform = function (vec, x_axis, y_axis, z_axis)
    local old_vecs = { celestia:newvector(1,0,0), celestia:newvector(0,1,0), celestia:newvector(0,0,1) }
    local new_vecs = { x_axis, y_axis, z_axis }
    local old_coords = { vec.x, vec.y, vec.z }
    local new_coords = { 0, 0, 0 }
    --[[ Bronstein & Semendjajew, TB der Mathematik, p. 179 ]]
    for new = 1, 3 do
        new_coords[new] = 0
        for old = 1, 3 do
        new_coords[new] = new_coords[new] + (new_vecs[new]*old_vecs[old])*old_coords[old]
        end
    end
    return celestia:newvector(new_coords[1], new_coords[2], new_coords[3])
end

-- Return three axis for a coordinate system relative to surface of planet.
--    z_axis is pointing up (away from planet center)
--    x_axis is pointing north (parallel to surface, in direction of rotation axis)
--    y_axis is pointing west
pkg.get_surfacelocal_coordinatesystem = function (obs, selected_planet)
    local frame = celestia:newframe("bodyfixed", selected_planet)
    local objectcenter  = selected_planet:getposition()
    --[[ this is the UP-vector for this frame in universal coords: ]]
    --[[ (rotation axis for body) ]]
    local univ_up = frame:from(pkg.UP) - objectcenter
    local curpos = obs:getposition()
    --[[ this is UP at the position of the observer (in univ. coords): ]]
    local local_up = (curpos - objectcenter):normalize()
    local x_axis, y_axis, z_axis = pkg.create_local_axis(local_up, univ_up)
    return x_axis, y_axis, z_axis
end

-- Return current azimuth and elevation of obs for selected_planet
pkg.get_az_elev = function (obs, selected_planet)
    x_axis, y_axis, z_axis = pkg.get_surfacelocal_coordinatesystem(obs, selected_planet)
    --[[ this is the direction where we are currently looking (i.e. observer orientation) ]]
    look = pkg.lookat(obs):normalize()
    v = pkg.transform(look , x_axis, y_axis, z_axis)
    r,theta,phi = pkg.transform_xyz2rtp(v.x, v.y, v.z)
    --[[ change from ccw to cw (if seen from z>0): ]]
    az = math.mod(720 - math.deg(phi), 360)
    --[[ change to elevation above/below ground: ]]
    if theta > 0 then
        elev = 90 - math.deg(theta)
    else
        elev = - math.deg(theta) - 90
    end
    return az, elev
end

-- Return Equatorial Coordinates (Ra, Dec) for selection
pkg.get_ra_dec = function (sel)
    if not pkg.EARTH then pkg.EARTH = celestia:find("Sol/Earth") end;
    local base_rot = celestia:newrotation(celestia:newvector(1,0,0), -pkg.J2000Obliquity)
    --local rot = obs:getorientation() * base_rot
    local rot = pkg.EARTH:getposition():orientationto(sel:getposition(), pkg.LOOK) * base_rot
    local look = (pkg.rotation_transform(pkg.LOOK,rot)):normalize()
    local r,theta,phi = pkg.transform_xyz2rtp(look.x, look.z, look.y)
    local phi = math.mod(720 - math.deg(phi), 360)
    local theta = math.deg(theta)
    if theta > 0 then
        theta = 90 - theta
    else
        theta = (-90 - theta)
    end
    return phi, theta
end

-- Return Ecliptic Coordinates (Ecliptic Long, Ecliptic Lat) for selection
pkg.get_ecliptic_long_lat = function (sel)
    local ra, dec = pkg.get_ra_dec(sel);
    local ra = math.rad(ra);
    local dec = math.rad(dec);
    local ecliptic_lat = math.asin(math.cos(pkg.J2000Obliquity) * math.sin(dec) - math.sin(pkg.J2000Obliquity) * math.sin(ra) * math.cos(dec))
    --local ecliptic_long = math.atan((math.sin(pkg.J2000Obliquity) * math.sin(dec) + math.cos(pkg.J2000Obliquity) * math.sin(ra) * math.cos(dec)) / (math.cos(ra) * math.cos(dec)))
    local ecliptic_long = math.atan2((math.sin(pkg.J2000Obliquity) * math.sin(dec) + math.cos(pkg.J2000Obliquity) * math.sin(ra) * math.cos(dec)) / math.cos(ecliptic_lat), math.cos(ra) * math.cos(dec) / math.cos(ecliptic_lat))
    local ecliptic_lat = math.deg(ecliptic_lat)
    local ecliptic_long = math.deg(ecliptic_long)
    if ecliptic_long < 0 then
        ecliptic_long = ecliptic_long + 360;
    end

    return ecliptic_long, ecliptic_lat
end

-- Return Galactic Coordinates (Galactic Long, Galactic Lat) for selection
pkg.get_galactic_long_lat = function (sel)
-- North galactic pole at:
-- RA 12h 51m 26.282s (192.85958 deg)
-- Dec 27 d 07' 42.01" (27.1283361 deg)
-- Zero longitude at position angle 122.932
-- Galactic Node : 282.85958;
-- (J2000 coordinates)
    local ra, dec = pkg.get_ra_dec(sel);
    local ra = math.rad(ra);
    local dec = math.rad(dec);
    local galactic_lat = math.asin(math.cos(dec) * math.cos(math.rad(27.1283361)) * math.cos(ra - math.rad(192.85958)) + math.sin(dec) * math.sin(math.rad(27.1283361)));
    --local galactic_long = math.atan((math.sin(dec) - math.sin(galactic_lat) * math.sin(math.rad(27.1283361))) / (math.cos(dec) * math.sin(ra - math.rad(192.85958)) * math.cos(math.rad(27.1283361)))) + math.rad(32.932);
    local galactic_long = math.atan2((math.cos(dec) * math.sin(ra - math.rad(282.85958)) * math.cos(math.rad(62.8716639)) + math.sin(dec) * math.sin(math.rad(62.8716639))) / math.cos(galactic_lat), (math.cos(dec) * math.cos(ra - math.rad(282.85958))) / math.cos(galactic_lat)) + math.rad(32.932);
    local galactic_lat = math.deg(galactic_lat);
    local galactic_long = math.deg(galactic_long);
    if galactic_long < 0 then
        galactic_long = galactic_long + 360;
    end

    return galactic_long, galactic_lat;
end

-- Return distance from Earth surface for selection (unit: km)
pkg.get_dist_to_earth = function (sel)
    if not pkg.EARTH then pkg.EARTH = celestia:find("Sol/Earth") end;
    local earth_radius = pkg.EARTH:radius();
    local dist_to_earth = sel:getposition():distanceto(pkg.EARTH:getposition()) - earth_radius
    return dist_to_earth
end

-- Return current distance from object
pkg.get_dist = function (obs, obj)
    local dist = (obj:getposition():distanceto(obs:getposition()))
    return dist
end

-- Return longitude and latitude for the observer on the source object
-- from CelxVisualGuide V1.132.1 by Clive Pottinger
pkg.get_long_lat = function (obs, source)
    f = source:getinfo().oblateness
    if f == nil then f = 0 end;
    u_pos = obs:getposition()
    e_frame = celestia:newframe("bodyfixed", source)
    e_pos = e_frame:to(u_pos)
    local lambda = -math.atan2(e_pos.z, e_pos.x);
    local beta = math.pi / 2 - math.atan2(math.sqrt(e_pos.x * e_pos.x + e_pos.z * e_pos.z), e_pos.y)
    local phi = math.atan2(math.tan(beta), (1 - f));
    long = math.deg(lambda)
    lat = math.deg(phi)
    return long, lat
end

-- Transform (positive) degrees to hours, minutes, seconds.
pkg.deg2hms = function (deg)
    deg_p_hour = 360/24
    deg_p_minute = 360 / (24*60)
    deg_p_second = 360 / (24*60*60)
    hours = math.floor(deg / deg_p_hour)
    deg = deg - deg_p_hour * hours
    minutes = math.floor(deg / deg_p_minute )
    deg = deg - deg_p_minute * minutes
    seconds = deg / deg_p_second
    return hours, minutes, math.floor(10*seconds)/10
end

-- make obs look to az/elev (relative to selected_planet)
pkg.point_to = function (az, elev, obs, selected_planet)
    --[[ change from cw to ccw: ]]
    local phi = math.mod(720 - az, 360)
    local theta
    --[[ change to elevation above/below ground: ]]
    if elev > 0 then
        theta = 90 - elev
    else
        theta = - elev - 90
    end
    local x_axis, y_axis, z_axis = pkg.get_surfacelocal_coordinatesystem(obs, selected_planet)
    local x,y,z = pkg.transform_pt2xyz(math.rad(phi), math.rad(theta))
    local v = x*x_axis + y*y_axis + z*z_axis
    local pos = obs:getposition()
    obs:lookat(pos + v, z_axis)
end

-- Force up being really UP
pkg.force_up = function (obs, selected_planet)
    local x_axis, y_axis, z_axis = pkg.get_surfacelocal_coordinatesystem(obs, selected_planet)
    local orientation = obs:getorientation()
    local observer_up = pkg.rotation_transform(pkg.UPV, orientation)
    if math.abs(z_axis * observer_up) < 0.999 then
        local look_point = pkg.rotation_transform(pkg.LOOK, orientation)
        if z_axis * observer_up > 0 then
            obs:lookat(obs:getposition() + look_point, z_axis)
        else
            z_inv = celestia:newvector(-z_axis.x, -z_axis.y, -z_axis.z)
            obs:lookat(obs:getposition() + look_point, z_inv)
        end
    end
end

return pkg;