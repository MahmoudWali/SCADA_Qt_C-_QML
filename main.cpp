#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "slmp.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    SLMP slmpConnection;

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("SLMP", &slmpConnection);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("SCADA", "Main");

    return app.exec();
}
