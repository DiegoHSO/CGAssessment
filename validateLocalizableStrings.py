import os

localizedStringsPath = "CGAssessment/Infrastructure/LocalizedStrings/"

directories = os.listdir(localizedStringsPath)

localizedDirectories = filter(lambda x: ".lproj" in x, directories)

referenceKeySet = {}

for path in localizedDirectories:
    fullPath = localizedStringsPath + path + "/Localizable.strings"
    stringsFile = open(fullPath, "r")
    stringsList = stringsFile.read().split("\n")
    stringsList = stringsList[8:-1]

    currentKeysList = []

    for line in stringsList:

        key = (line.split("\"")[1])
        if key in currentKeysList:
            raise TypeError("There is a repetitive string \"" + key + "\" in "  + path)
        else:
            currentKeysList.append(key)

    currentKeysSet = set(currentKeysList)

    if len(referenceKeySet) == 0:
        referenceKeySet = currentKeysSet
    elif len(referenceKeySet - currentKeysSet) > 0:
        raise TypeError("Localized strings keys differs in " + path + ". keys: " + str(referenceKeySet - currentKeysSet))
    elif len(currentKeysSet - referenceKeySet) > 0:
        raise TypeError("Localized strings keys differs in " + path + ". keys: " + str(currentKeysSet - referenceKeySet))
