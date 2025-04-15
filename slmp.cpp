#include "slmp.h"

SLMP::SLMP(QObject *parent)
    : QObject{parent}
{
    init();
    // read_slmp();
    // write_slmp();

    timer = new QTimer(this);
    timer->setInterval(250);
    connect(timer, &QTimer::timeout, this, &SLMP::readingFromPLC);
    timer->start();
}

int SLMP::init()
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

void SLMP::write_slmp()
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

void SLMP::read_slmp()
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

        // set readData1 and readData2 variables for qml side
        setReadData1(data[0]);
        setReadData2(data[1]);
    }

    melcli_free(data);
}

void SLMP::readingFromPLC()
{
    read_slmp();

    static int c = 0;
    c++;
    setReadData1(c);    //QRandomGenerator::global()->bounded(281)
    setReadData2(100-c);

    qDebug() << "D12: " << c << ", D22: " << 100 -c;

    // chart series
    if (!m_series)
        return;

    m_series->append(c, QRandomGenerator::global()->bounded(281));    //c
    if (m_series->count() > 500)
    {
        m_series->removePoints(0, m_series->count() - 100);
    }
}

void SLMP::resetPLC()
{
    write_slmp();

    qDebug() << "PLC reset done.";
}

void SLMP::setSeries(QAbstractSeries *series)
{
    m_series = qobject_cast<QLineSeries*>(series);
}

double SLMP::getReadData2() const
{
    return readData2;
}

void SLMP::setReadData2(double newReadData2)
{
    if (qFuzzyCompare(readData2, newReadData2))
        return;
    readData2 = newReadData2;
    emit readData2Changed();
}

double SLMP::getReadData1() const
{
    return readData1;
}

void SLMP::setReadData1(double newReadData1)
{
    if (qFuzzyCompare(readData1, newReadData1))
        return;
    readData1 = newReadData1;
    emit readData1Changed();
}
