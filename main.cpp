#include <QtGui/QGuiApplication>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
#include <QtQuick/QQuickItem>
#include <QLoggingCategory>
#include <QQmlApplicationEngine>
#include "appcore.h"
#include <QQmlContext>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
   AppCore appCore;
    QGuiApplication app(argc, argv);

    //qmlRegisterType<AppModel>("WeatherInfo", 1, 0, "AppModel");
   // qRegisterMetaType<fileList>();


    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
     context->setContextProperty("cutieMusic", &appCore);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    appCore.receiveFromQml();
    return app.exec();
}
