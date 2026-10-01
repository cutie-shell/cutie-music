#ifndef APPCORE_H
#define APPCORE_H

#include <QDir>
#include <QFileInfo>
#include <QObject>
#include <QSet>
#include <QStandardPaths>
#include <QUrl>
#include <QVariant>
#include <fileref.h>
#include <tag.h>

class AppCore : public QObject {
	Q_OBJECT
	Q_PROPERTY(QVariantList trackList READ trackList NOTIFY trackListChanged)

    public:
	explicit AppCore(QObject *parent = nullptr);
	QVariantList trackList();
	void readTrackList(QDir dir);
private:
    bool processFile(const QUrl &fileUrl, const QFileInfo &entry,
                      QSet<QUrl> &existingUrls, bool prepend = false);

public:
    Q_INVOKABLE void addExternalTrack(const QString &filePath);
    signals:
	void trackListChanged(QVariantList trackList);

    private:
	QVariantList m_trackList;
};

#endif // APPCORE_H