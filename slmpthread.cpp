#include "slmpthread.h"

SLMPThread::SLMPThread() {}

int SLMPThread::init()
{
    ctxtype = MELCLI_TYPE_TCPIP;

    strcpy_s(target_ip_addr, "192.168.3.250");
    target_port = 401;

    /* Create a connection context and store it into `g_ctx`. */
    g_ctx = melcli_new_context(ctxtype, target_ip_addr, target_port, local_ip_addr, local_port, &target_station, &timeout);
    if (g_ctx == NULL)
    {
        qDebug() << "Failed to create connection context.";
        return -1;
    }

    // /* Enable debug information printout. */
    //melcli_set_debug(g_ctx, 1);

    qDebug() << "Connecting to " << target_ip_addr << ":" << target_port;
    if (melcli_connect(g_ctx) != 0)
    {
        qDebug() << "Failed to connect.";
        return -1;
    }

    qDebug() << "Connected.";

    return 0;
}

void SLMPThread::write_slmp()
{
    const char *word_addrs[] = { "M0", NULL };
    uint16_t *data = new uint16_t[1];

    qDebug() << "Writing M0";

    data[0] = 1;
    if (melcli_random_write_word(g_ctx, NULL, word_addrs, data) != 0)
    {
        qDebug() << "Failed.";
    }

    //melcli_free(data);
}

void SLMPThread::read_slmp()
{
    const char *word_addrs[] = { "D12", "D22", NULL };
    uint16_t *data = NULL;

    qDebug() << "Reading D12, D22";
    if (melcli_random_read_word(g_ctx, NULL, word_addrs, &data, NULL) != 0)
    {
        qDebug() << "Failed.";
    }
    else
    {
        qDebug() << "D12=" << data[0] << ", D22=" << data[1];
    }

    melcli_free(data);
}


void SLMPThread::run()
{

}
