#include "slmpthread.h"

SLMPThread::SLMPThread(QObject* parent) : QThread(parent), m_running(true), m_file("D:/readout.txt")
{
    if (!m_file.open(QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text))
    {
        qWarning() << "Failed to open file for writing";
    }
    m_stream.setDevice(&m_file);
    m_stream.setRealNumberNotation(QTextStream::FixedNotation); // Optional: better formatting
    m_stream.setRealNumberPrecision(6);
}

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

void SLMPThread::stopReading()
{
    m_running.storeRelaxed(false);
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

    //emit this signal to anywhere (like to QML side)
    //emit newReading(data[0], data[1]);

    c++;
    emit newReading(c, c);
    m_buffer.append(c);
    if (m_buffer.size() >= 1000)
    {
        flushBufferToFile();
    }
    qDebug() << "Emit done. " << c;

    if (!m_series1 && !m_series2)
        return;

    //m_series->append(data[0], data[1]);    //c
    m_series1->append(c, c);    //c
    m_series2->append(c, 1000 - c);    //c

    // if (m_series->count() > 500)
    // {
    //     m_series->removePoints(0, m_series->count() - 100);
    // }

    melcli_free(data);
}

void SLMPThread::setSeries(QAbstractSeries *series1, QAbstractSeries *series2)
{
    m_series1 = qobject_cast<QLineSeries*>(series1);
    m_series2 = qobject_cast<QLineSeries*>(series2);
}

void SLMPThread::flushBufferToFile()
{
    // if (m_file.isOpen() && !m_buffer.isEmpty())
    // {
    //     m_file.write(reinterpret_cast<const char*>(m_buffer.constData()), m_buffer.size() * sizeof(double));
    //     m_buffer.clear();
    // }


    if (m_file.isOpen() && !m_buffer.isEmpty()) {
        for (double value : std::as_const(m_buffer)) {
            m_stream << value << "\n";
        }
        m_stream.flush();
        m_buffer.clear();
    }
}

void SLMPThread::run()
{
    m_buffer.reserve(100000); // Reserve space to reduce reallocations

    while (m_running.loadRelaxed())
    {
        read_slmp();

        QThread::msleep(20);
    }

    flushBufferToFile();
    m_file.close();
}
