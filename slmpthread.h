#ifndef SLMPTHREAD_H
#define SLMPTHREAD_H

#include <QObject>
#include <QThread>
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
    SLMPThread();

    // SLMP Protocol functions
    int init();
    void write_slmp();
    void read_slmp();

    // QThread interface
protected:
    void run();


private:
    int ctxtype = MELCLI_TYPE_TCPIP;
    char target_ip_addr[64] = "192.168.3.250";
    int target_port = 401;
    char local_ip_addr[64] = "0.0.0.0";
    int local_port = 0;

    const melcli_station_t target_station = MELCLI_CONNECTED_STATION;
    const melcli_timeout_t timeout = MELCLI_TIMEOUT_DEFAULT;

    melcli_ctx_t *g_ctx = NULL;
};

#endif // SLMPTHREAD_H
