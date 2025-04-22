#ifndef SLMP_H
#define SLMP_H

#include <QObject>
#include <QTimer>
#include <QtCharts/QLineSeries>
#include <QRandomGenerator>
#include <QDebug>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <windows.h>
#include "melcli/melcli.h"


class SLMP : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double readData1 READ getReadData1 WRITE setReadData1 NOTIFY readData1Changed FINAL)
    Q_PROPERTY(double readData2 READ getReadData2 WRITE setReadData2 NOTIFY readData2Changed FINAL)

public:
    explicit SLMP(QObject *parent = nullptr);

    // QML side functions
    Q_INVOKABLE void startReading();
    Q_INVOKABLE void resetPLC();
    Q_INVOKABLE void setSeries(QAbstractSeries *series);

    // SLMP protocol functions
    int init();
    void write_slmp();
    void read_slmp();

    // qt c++ qml side
    double getReadData1() const;
    void setReadData1(double newReadData1);

    double getReadData2() const;
    void setReadData2(double newReadData2);

signals:
    void readData1Changed();
    void readData2Changed();

public slots:
    void readingFromPLC();

private:

    QTimer *timer;

    int ctxtype = MELCLI_TYPE_TCPIP;
    char target_ip_addr[64] = "192.168.3.250";
    int target_port = 401;
    char local_ip_addr[64] = "0.0.0.0";
    int local_port = 0;

    const melcli_station_t target_station = MELCLI_CONNECTED_STATION;
    const melcli_timeout_t timeout = MELCLI_TIMEOUT_DEFAULT;

    melcli_ctx_t *g_ctx = NULL;


    // qt variables
    double readData1 = 0.0;
    double readData2 = 0.0;
    QLineSeries *m_series;;
};

#endif // SLMP_H
