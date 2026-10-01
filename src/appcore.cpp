#include "appcore.h"
#include <QDebug>
#include <QDirIterator>
#include <QFileInfo>
#include <QSet>
#include <QStandardPaths>
#include <QUrl>
#include <taglib/fileref.h>
#include <taglib/tag.h>

AppCore::AppCore(QObject *parent)
    : QObject(parent)
{
    readTrackList(QStandardPaths::writableLocation(QStandardPaths::MusicLocation));
}

void AppCore::addExternalTrack(const QString &filePath)
{
    QUrl fileUrl = QUrl::fromLocalFile(filePath);
    qDebug().noquote() << "cutie-music: addExternalTrack initialised with file URI:" << fileUrl.toString();
    QFileInfo entry(filePath);
    
    if (!entry.exists()) 
        return;

    QSet<QUrl> existingUrls;

    m_trackList.removeIf([&](const QVariant &item) {
        return item.toMap().value("path").toUrl() == fileUrl;
    });

    if (processFile(fileUrl, entry, existingUrls, /*prepend=*/true))
        emit trackListChanged(m_trackList);
}

void AppCore::readTrackList(QDir dir)
{
    // 1. Only target valid audio extensions
    static const QStringList audioFilters = {
        "*.mp3", "*.flac", "*.m4a", "*.ogg", "*.wav", "*.opus", "*.aac", "*.wma"
    };

    // 2. Build a set of existing URLs to accurately check for duplicates
    QSet<QUrl> existingUrls;
    for (const QVariant &item : std::as_const(m_trackList)) {
        existingUrls.insert(item.toMap().value("path").toUrl());
    }

    // 3. Use QDirIterator for recursive directory scanning
    QDirIterator it(dir.absolutePath(), audioFilters, QDir::Files, QDirIterator::Subdirectories);

    bool itemsAdded = false;

    while (it.hasNext()) {
        it.next();
        QFileInfo entry = it.fileInfo();
        QUrl fileUrl = QUrl::fromLocalFile(entry.absoluteFilePath());

        if (processFile(fileUrl, entry, existingUrls))
            itemsAdded = true;
    }

    // 4. Emit signal ONCE after the entire scan finishes
    if (itemsAdded) {
        emit trackListChanged(m_trackList);
    }
}

bool AppCore::processFile(const QUrl &fileUrl, const QFileInfo &entry,
                           QSet<QUrl> &existingUrls, bool prepend)
{
    if (existingUrls.contains(fileUrl))
        return false;

    TagLib::FileRef tagF(entry.absoluteFilePath().toUtf8().constData());

    QString title;
    QString artist;

    if (!tagF.isNull() && tagF.tag()) {
        // toCString(true) guarantees UTF-8 string conversion
        title = QString::fromUtf8(tagF.tag()->title().toCString(true));
        artist = QString::fromUtf8(tagF.tag()->artist().toCString(true));
    }

    if (title.trimmed().isEmpty())
        title = entry.completeBaseName();
    if (artist.trimmed().isEmpty())
        artist = tr("Unknown Artist");

    QVariantMap musicFile;
    musicFile.insert("path", fileUrl);
    musicFile.insert("title", title);
    musicFile.insert("artist", artist);

    if (prepend)
        m_trackList.prepend(musicFile);
    else
        m_trackList.append(musicFile);

    existingUrls.insert(fileUrl);
    return true;
}

QVariantList AppCore::trackList()
{
    return m_trackList;
}
