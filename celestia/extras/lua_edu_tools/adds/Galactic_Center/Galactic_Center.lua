-- The table can include the following values:
--    >    objects = { string:object1path, string:object2path, ... }
--    Defines the list of objects whose visibility will be enabled/disabled.
--    >    labelcolor = {number:red, number:green, number:blue, number:alpha}
--    Defines the color of the addon labels. The name of the addon will be then displayed using
--    this same color in the 'Addon Visibility' window.
--    >    locationtypes = {string:locationtype1, string:locationtype2, ...}
--    Defines the types of location that will be enabled/disabled simultaneously with the objects visibility.
--    List of all location types: http://en.wikibooks.org/wiki/Celestia/SSC_File#Type_.22string.22
--    >    script = string:scriptfilename
--    Defines the filename of the script that is run whenever the addon checkbox is clicked (either checked or unchecked)
--    The script path is relative to the addon's directory.

Galactic_Center =
{
    objects =
        {
            "Galactic Center/Sgr A*",
            "Galactic Center/Sgr A*/Dust Belt",
            "Galactic Center/Sgr A*/Jets",
            "Galactic Center/Sgr A*/Disk 1",
            "Galactic Center/Sgr A*/Disk 2",
            "Galactic Center/Sgr A*/Disk 3",
            "Galactic Center/Sgr A*/Disk 4",
        },
    script = "Galactic_Center.celx"
}
