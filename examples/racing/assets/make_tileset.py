from subprocess import call
import os
import errno

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)


def ensure_dir(path):
    try:
        os.makedirs(path)
    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise


def list_of_pics(prefix, first, last):
    ret = []
    for x in range(first, last + 1):
        ret.append("%s%02d.png" % (prefix, x))
    return ret


def make_tileset(dir, file_prefix, output_dir, number_of_columns, number_of_lines):

    number_of_tiles = number_of_columns * number_of_lines

    temp_dir = os.path.join(dir, "temp")
    ensure_dir(temp_dir)
    ensure_dir(output_dir)

    for p in list_of_pics(os.path.join(dir, file_prefix), 1, number_of_tiles):
        out = os.path.join(temp_dir, os.path.basename(p))
        print "resizing %s into %s" % (p, out)
        call(["convert", p, "-resize", "16x16", out])

    for line in range(0, number_of_lines):
        pics = list_of_pics(os.path.join(temp_dir, file_prefix),
                            line * number_of_columns + 1,
                            (line + 1) * number_of_columns)

        print "making line%02d.png" % line
        call(["convert", "+append"] + pics +
             [os.path.join(temp_dir, "line%02d.png" % line)])

    line_pics = list_of_pics(os.path.join(temp_dir, "line"),
                             0, number_of_lines - 1)

    tileset = os.path.join(output_dir, file_prefix + "16x16.png")
    print "making tileset " + tileset
    call(["convert", "-append"] + line_pics + [tileset])


output_dir="../../tilesets"
make_tileset("Asphalt road", "road_asphalt", output_dir, 18, 5)
make_tileset("Dirt road", "road_dirt", output_dir, 18, 5)
make_tileset("Sand road", "road_sand", output_dir, 18, 5)

make_tileset("Dirt", "land_dirt", output_dir, 7, 2)
make_tileset("Grass", "land_grass", output_dir, 7, 2)
make_tileset("Sand", "land_sand", output_dir, 7, 2)
