#include "appcore.h"
#include "QDebug"


AppCore::AppCore(QObject* parent) : QObject(parent)
{
    //receiveFromQml();
}

void AppCore::receiveFromQml()
{
    // Увеличиваем счётчик и высылаем сигнал с его значением
   // ++m_counter;
   QString path;
   path = "/home/alex/Музыка/";
    QDir dirname(path);
    QStringList dir = dirname.entryList();
  int count=0;
    for (const auto &file : dir){
        if (file.endsWith(".mp3")) {
            trackList.append("file://" + path + file);
          //  ++m_mp3ListCount;
            emit sendString(trackList.at(count));
            count ++;
        }
    }
}
