#ifndef APPCORE_H
#define APPCORE_H

#include <QObject>
#include <QFile>
#include <QDir>
#include <QStandardPaths>
#include <QFileInfo>


class AppCore : public QObject
{
    Q_OBJECT
public:
    explicit AppCore(QObject *parent = nullptr);

signals:
    void sendString(QString current_line);

public slots:
    void receiveFromQml();

private:
    int m_counter {0};
    QString current_file_path;
    QStringList trackList;
};

#endif // APPCORE_H
