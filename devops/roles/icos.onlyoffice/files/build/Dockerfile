ARG ONLYOFFICE_VERSION

# <2021-02-06> The documentserver-ie (integration edition) lags behind the
# ordinary edition. Tried the ordinary but it didn't work out of the box with
# onlyoffice.
FROM onlyoffice/documentserver-ie:$ONLYOFFICE_VERSION

# https://helpcenter.onlyoffice.com/server/linux/document/install-fonts.aspx
ADD droidserif.tgz /usr/share/fonts
