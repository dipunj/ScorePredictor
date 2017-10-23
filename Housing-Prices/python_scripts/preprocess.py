import pandas as pd


def PREPROCESS(filename, labels, csv_filename):
    houseId = None
    date_built = None
    date_priced = None
    location = None
    dst_dock = None
    dst_capital = None
    dst_market = None
    dst_tower = None
    dst_river = None
    dst_knight_hs = None
    frnt_farm_sz = None
    garden = None
    renovation = None
    tree = None
    king_visit = None
    curse = None
    n_bed = None
    n_bath = None
    n_dining = None
    n_bless = None
    flag = True
    builder = filename[:filename.find('.txt')]
    dataFRAME = pd.DataFrame(columns=labels)
    with open(filename) as f:
        for line in f:
            if "House ID" in line:
                houseId = line[12:20]
            elif "Date Built" in line:
                date_built = line[line.find(" : ") + 3:line.find(" and")]
                date_priced = line[line.find(" :  ") + 4:line.find("\n")]
            elif "no space for garden" in line:
                garden = 0
            elif "Distance from the Dock is" in line:
                dst_dock = line[line.find(" is ") + 4:line.find("holy") - 1]
            elif "Distance from Capital" in line:
                dst_capital = line[line.find(" is ") + 4:line.find("holy") - 1]
            elif "Distance from Royal Market" in line:
                dst_market = line[line.find(" is ") + 4:line.find("holy") - 1]
            elif "Distance from Guarding Tower" in line:
                dst_tower = line[line.find(" is ") + 4:line.find("holy") - 1]
            elif "Distance from the River is" in line:
                dst_river = line[line.find(" is ") + 4:line.find("holy") - 1]
            elif "Distance from Knight's house" in line:
                dst_knight_hs = line[line.find(
                    " is ") + 4:line.find("holy") - 1]
            elif "renovation" in line:
                if "did not" in line:
                    renovation = 0
                elif "underwent" in line:
                    renovation = 1
            elif "dining rooms" in line:
                n_dining = line[line.find("There are ") +
                                10:line.find(" dining")]
            elif "bedrooms" in line:
                n_bed = line[line.find("There are ") +
                             10:line.find(" bedrooms")]
            elif "bathrooms" in line:
                n_bath = line[line.find("There are ") +
                              10:line.find(" bathrooms")]
            elif "couldn't pay his visit" in line:
                king_visit = 0
            elif "The great King Visited" in line:
                king_visit = 1
            elif "This house was cursed" in line:
                curse = 1
            elif "Sorcerer couldn't curse" in line:
                curse = 0
            elif "King blessed" in line:
                n_bless = line[line.find(" with ") + 6:line.find(" blessings")]
            elif "small land of farm" in line:
                frnt_farm_sz = -1
            elif "huge land of farm" in line:
                frnt_farm_sz = 1
            elif "no land of farm" in line:
                frnt_farm_sz = 0
            elif "Location of the house is" in line:
                location = line[line.find(" : ") + 3:line.find("\n")]
            elif "Holy tree" in line:
                if "tall" in line:
                    tree = 1
                else:
                    tree = 0
            if line in "\n":
                flag = not flag
                if flag is True:
                    row = pd.Series([builder, houseId, date_built, date_priced,
                                     location, dst_dock, dst_capital,
                                     dst_market, dst_tower, dst_river,
                                     dst_knight_hs, frnt_farm_sz, garden,
                                     renovation, tree, king_visit, curse,
                                     n_bed, n_bath, n_dining, n_bless], labels)

                    dataFRAME = dataFRAME.append([row], ignore_index=True)
                    houseId = date_built = date_priced \
                        = location = dst_dock = dst_capital \
                        = dst_market = dst_tower = dst_river \
                        = dst_knight_hs = frnt_farm_sz = garden\
                        = renovation = tree = king_visit = curse\
                        = n_bed = n_bath = n_dining = n_bless = None

    pass

    with open(csv_filename, 'a') as f:
        dataFRAME.to_csv(f, header=False, index=False)

    pass


pass
