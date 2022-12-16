#include "appcore.h"
#include <QDebug>

AppCore::AppCore(QObject *parent) : QObject(parent) {
  readTrackList(QStandardPaths::writableLocation(QStandardPaths::MusicLocation));
}

void AppCore::readTrackList(QDir dir) {
  QFileInfoList dirlist = dir.entryInfoList();
  
  for (int i = 0; i < dirlist.size(); i++) {
    QFileInfo entry = dirlist.at(i);
    QString filePath = entry.absoluteFilePath();
    QUrl fileUrl = QUrl::fromLocalFile(filePath);
    if (entry.isDir()) {
        if (entry.fileName() != ".." && entry.fileName() != ".")
            readTrackList(QDir(filePath));
    } else if (entry.isFile() && !m_trackList.contains(fileUrl)) {
	QVariantMap musicFile;
	TagLib::FileRef tagF(filePath.toUtf8().constData());
	musicFile.insert("path", QVariant(fileUrl));
	musicFile.insert("title", QVariant(tagF.tag()->title().toCString()));
	musicFile.insert("artist", QVariant(tagF.tag()->artist().toCString()));
        m_trackList.append(QVariant(musicFile));
        emit trackListChanged(m_trackList);
    }
  }
}

QVariantList AppCore::trackList() {
    return m_trackList;
}
