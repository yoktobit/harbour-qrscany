# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-qrscany

CONFIG += sailfishapp

include(qzxing/qzxing.pri)

SOURCES += src/harbour-qrscany.cpp

OTHER_FILES += qml/harbour-qrscany.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/harbour-qrscany.spec \
    rpm/harbour-qrscany.yaml \
    harbour-qrscany.desktop \
    qml/pages/AboutPage.qml \
    qml/pages/TagPage.qml

