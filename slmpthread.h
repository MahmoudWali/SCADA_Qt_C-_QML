#ifndef SLMPTHREAD_H
#define SLMPTHREAD_H

#include <QObject>
#include <QThread>
#include <QAtomicInt>
#include <QtCharts/QLineSeries>
#include <QFile>
#include <QTextStream>
#include <QElapsedTimer>
#include <QDebug>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <windows.h>
#include "melcli/melcli.h"



class SLMPThread : public QThread
{
    Q_OBJECT
public:
    SLMPThread(QObject* parent = nullptr);

    // SLMP Protocol functions
    Q_INVOKABLE void setSeries(QAbstractSeries *series1, QAbstractSeries *series2);
    Q_INVOKABLE int init();
    Q_INVOKABLE void stopReading();
    void write_slmp();
    void read_slmp();
    void flushBufferToFile();

    // QThread interface
protected:
    void run() override;


signals:
    void newReading(double D12, double D22);

private:
    int ctxtype = MELCLI_TYPE_TCPIP;
    char target_ip_addr[64] = "192.168.3.250";
    int target_port = 401;
    char local_ip_addr[64] = "0.0.0.0";
    int local_port = 0;

    const melcli_station_t target_station = MELCLI_CONNECTED_STATION;
    const melcli_timeout_t timeout = MELCLI_TIMEOUT_DEFAULT;

    melcli_ctx_t *g_ctx = NULL;

    double c {0};
    QLineSeries *m_series1, *m_series2;
    QVector<double> m_buffer;
    QFile m_file;
    QTextStream m_stream; // Text writer

    // Thread Control
    QAtomicInt m_running;
};

#endif // SLMPTHREAD_H
